#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <winsock2.h>
#include <ws2tcpip.h>
#include <windows.h>
#include <mmdeviceapi.h>
#include <audioclient.h>
#include <avrt.h>
#include <mmsystem.h>
#include <functiondiscoverykeys_devpkey.h>
#include <ks.h>
#include <ksmedia.h>

#include <atomic>
#include <cstdio>
#include <string>
#include <thread>

#include "audio_pipeline.h"

typedef void (*ConnectCallback)(const char*);

struct DeviceEntry {
    std::string id;
    std::string name;
    bool isDefault;
};

static std::vector<DeviceEntry> g_devices;
static std::string g_deviceId;
static int g_source = 0;
static int g_queueMs = 60;
static int g_outputBits = 16;
static std::atomic<bool> g_running{false};
static std::atomic<bool> g_connected{false};
static std::atomic<SOCKET> g_listener{INVALID_SOCKET};
static std::atomic<SOCKET> g_client{INVALID_SOCKET};
static std::thread g_listenThread;
static std::thread g_captureThread;
static std::thread g_sendThread;
static HANDLE g_stopEvent = nullptr;
static bool g_wsaInitialized = false;
static AudioPipeline g_pipeline;
static std::mutex g_errorMutex;
static int g_errorCode = 0;
static std::string g_errorMessage;
static std::string g_connectCode;
static const GUID kPcmSubtype = {1, 0, 0x10, {0x80, 0, 0, 0xaa, 0, 0x38, 0x9b, 0x71}};
static const GUID kFloatSubtype = {3, 0, 0x10, {0x80, 0, 0, 0xaa, 0, 0x38, 0x9b, 0x71}};

static std::string Utf8(const wchar_t* text) {
    const int length = WideCharToMultiByte(CP_UTF8, 0, text, -1, nullptr, 0, nullptr, nullptr);
    if (length <= 1) return {};
    std::string result(static_cast<size_t>(length), '\0');
    WideCharToMultiByte(CP_UTF8, 0, text, -1, result.data(), length, nullptr, nullptr);
    result.resize(static_cast<size_t>(length - 1));
    return result;
}

static std::wstring Wide(const std::string& text) {
    const int length = MultiByteToWideChar(CP_UTF8, 0, text.c_str(), -1, nullptr, 0);
    if (length <= 1) return {};
    std::wstring result(static_cast<size_t>(length), L'\0');
    MultiByteToWideChar(CP_UTF8, 0, text.c_str(), -1, result.data(), length);
    result.resize(static_cast<size_t>(length - 1));
    return result;
}

static void SetError(int code, const char* operation, HRESULT hr = S_OK) {
    std::lock_guard<std::mutex> lock(g_errorMutex);
    if (g_errorCode) return;
    char message[256];
    snprintf(message, sizeof(message), "%s (0x%08lX)", operation, static_cast<unsigned long>(hr));
    g_errorCode = code;
    g_errorMessage = message;
}

static void CloseSocket(std::atomic<SOCKET>& socket) {
    const SOCKET value = socket.exchange(INVALID_SOCKET);
    if (value != INVALID_SOCKET) {
        shutdown(value, SD_BOTH);
        closesocket(value);
    }
}

static bool SendAll(SOCKET socket, const uint8_t* bytes, size_t length) {
    while (length && g_running) {
        const int sent = send(socket, reinterpret_cast<const char*>(bytes),
            static_cast<int>(length), 0);
        if (sent <= 0) return false;
        bytes += sent;
        length -= static_cast<size_t>(sent);
    }
    return length == 0;
}

static bool ParseFormat(const WAVEFORMATEX* wave, InputFormat* result) {
    result->channels = wave->nChannels;
    result->bytesPerSample = wave->wBitsPerSample / 8;
    WORD tag = wave->wFormatTag;
    if (tag == WAVE_FORMAT_EXTENSIBLE && wave->cbSize >= 22) {
        const auto* extended = reinterpret_cast<const WAVEFORMATEXTENSIBLE*>(wave);
        result->channelMask = extended->dwChannelMask;
        if (IsEqualGUID(extended->SubFormat, kPcmSubtype)) tag = WAVE_FORMAT_PCM;
        else if (IsEqualGUID(extended->SubFormat, kFloatSubtype)) {
            tag = WAVE_FORMAT_IEEE_FLOAT;
        } else return false;
    } else {
        result->channelMask = 0;
    }
    if (result->channels < 1 || result->channels > 32 ||
        wave->nBlockAlign != result->channels * result->bytesPerSample) return false;
    if (tag == WAVE_FORMAT_IEEE_FLOAT) {
        if (wave->wBitsPerSample == 32) result->type = SampleType::Float32;
        else if (wave->wBitsPerSample == 64) result->type = SampleType::Float64;
        else return false;
        return true;
    }
    if (tag != WAVE_FORMAT_PCM) return false;
    switch (wave->wBitsPerSample) {
    case 8: result->type = SampleType::Pcm8; break;
    case 16: result->type = SampleType::Pcm16; break;
    case 24: result->type = SampleType::Pcm24; break;
    case 32: result->type = SampleType::Pcm32; break;
    default: return false;
    }
    return true;
}

static void SendThread() {
    DWORD taskIndex = 0;
    HANDLE task = AvSetMmThreadCharacteristicsW(L"Audio", &taskIndex);
    if (task) AvSetMmThreadPriority(task, AVRT_PRIORITY_HIGH);
    AudioPacket packet;
    while (g_running && g_pipeline.Pop(&packet)) {
        const auto started = std::chrono::steady_clock::now();
        if (!SendAll(g_client.load(), packet.bytes.data(), packet.bytes.size())) {
            if (g_running) SetError(1303, "Sending audio failed", HRESULT_FROM_WIN32(WSAGetLastError()));
            g_running = false;
            SetEvent(g_stopEvent);
            g_pipeline.Stop();
            CloseSocket(g_client);
            break;
        }
        g_pipeline.Sent(packet, std::chrono::duration<double, std::milli>(
            std::chrono::steady_clock::now() - started).count());
    }
    if (task) AvRevertMmThreadCharacteristics(task);
}

static HRESULT FillSilence(IAudioClient* client, IAudioRenderClient* render, UINT32 capacity) {
    UINT32 padding = 0;
    HRESULT hr = client->GetCurrentPadding(&padding);
    if (FAILED(hr)) return hr;
    if (padding > capacity) return E_UNEXPECTED;
    const UINT32 available = capacity - padding;
    if (!available) return S_OK;
    BYTE* unused = nullptr;
    hr = render->GetBuffer(available, &unused);
    if (FAILED(hr)) return hr;
    return render->ReleaseBuffer(available, AUDCLNT_BUFFERFLAGS_SILENT);
}

// WASAPI interfaces, including GetBuffer/ReleaseBuffer, belong to this
// COM-initialized worker. Socket backpressure never blocks this thread.
static void CaptureThread() {
    // Keep short audio deadlines precise even without another active player.
    const bool preciseTimer = timeBeginPeriod(1) == TIMERR_NOERROR;
    const HRESULT com = CoInitializeEx(nullptr, COINIT_MULTITHREADED);
    IMMDeviceEnumerator* enumerator = nullptr;
    IMMDevice* device = nullptr;
    IAudioClient* client = nullptr;
    IAudioCaptureClient* capture = nullptr;
    IAudioClient* silentClient = nullptr;
    IAudioRenderClient* render = nullptr;
    WAVEFORMATEX* wave = nullptr;
    HANDLE audioEvent = CreateEvent(nullptr, FALSE, FALSE, nullptr);
    HANDLE silentEvent = g_source ? nullptr : CreateEvent(nullptr, FALSE, FALSE, nullptr);
    DWORD taskIndex = 0;
    HANDLE task = AvSetMmThreadCharacteristicsW(L"Audio", &taskIndex);
    if (task) AvSetMmThreadPriority(task, AVRT_PRIORITY_HIGH);
    HRESULT hr = com;
    InputFormat format;
    UINT32 silentCapacity = 0;
    bool started = false;
    bool silentStarted = false;
    do {
        if (FAILED(hr) || !audioEvent || (!g_source && !silentEvent)) {
            if (!audioEvent || (!g_source && !silentEvent)) hr = HRESULT_FROM_WIN32(GetLastError());
            break;
        }
        hr = CoCreateInstance(__uuidof(MMDeviceEnumerator), nullptr, CLSCTX_ALL,
            __uuidof(IMMDeviceEnumerator), reinterpret_cast<void**>(&enumerator));
        if (FAILED(hr)) break;
        const auto selectedId = Wide(g_deviceId);
        hr = selectedId.empty()
            ? enumerator->GetDefaultAudioEndpoint(g_source ? eCapture : eRender, eConsole, &device)
            : enumerator->GetDevice(selectedId.c_str(), &device);
        if (FAILED(hr)) break;
        hr = device->Activate(__uuidof(IAudioClient), CLSCTX_ALL, nullptr,
            reinterpret_cast<void**>(&client));
        if (FAILED(hr)) break;
        hr = client->GetMixFormat(&wave);
        if (FAILED(hr)) break;
        if (!ParseFormat(wave, &format)) {
            hr = AUDCLNT_E_UNSUPPORTED_FORMAT;
            break;
        }
        const DWORD flags = AUDCLNT_STREAMFLAGS_EVENTCALLBACK |
            (g_source ? 0 : AUDCLNT_STREAMFLAGS_LOOPBACK);
        hr = client->Initialize(AUDCLNT_SHAREMODE_SHARED, flags, 0, 0, wave, nullptr);
        if (FAILED(hr)) break;
        hr = client->SetEventHandle(audioEvent);
        if (FAILED(hr)) break;
        hr = client->GetService(__uuidof(IAudioCaptureClient), reinterpret_cast<void**>(&capture));
        if (FAILED(hr)) break;
        if (!g_source) {
            // Keep the selected loopback endpoint clocked when other players
            // stop. A silent shared render stream contributes no audible PCM.
            hr = device->Activate(__uuidof(IAudioClient), CLSCTX_ALL, nullptr,
                reinterpret_cast<void**>(&silentClient));
            if (FAILED(hr)) break;
            hr = silentClient->Initialize(AUDCLNT_SHAREMODE_SHARED,
                AUDCLNT_STREAMFLAGS_EVENTCALLBACK, 0, 0, wave, nullptr);
            if (FAILED(hr)) break;
            hr = silentClient->SetEventHandle(silentEvent);
            if (FAILED(hr)) break;
            hr = silentClient->GetService(__uuidof(IAudioRenderClient),
                reinterpret_cast<void**>(&render));
            if (FAILED(hr)) break;
            hr = silentClient->GetBufferSize(&silentCapacity);
            if (FAILED(hr)) break;
            hr = FillSilence(silentClient, render, silentCapacity);
            if (FAILED(hr)) break;
        }
        g_pipeline.Reset(wave->nSamplesPerSec, static_cast<uint32_t>(g_outputBits),
            static_cast<uint32_t>(g_queueMs), wave->nChannels, wave->wBitsPerSample);
        const uint32_t header[] = {wave->nSamplesPerSec,
            static_cast<uint32_t>(2 | (g_outputBits << 16))};
        if (!SendAll(g_client.load(), reinterpret_cast<const uint8_t*>(header), sizeof(header))) {
            hr = E_FAIL;
            break;
        }
        // Do not capture while Android is constructing AudioTrack: that
        // startup backlog otherwise remains queued for the entire session.
        char ready[6]{};
        size_t received = 0;
        while (g_running && received < sizeof(ready)) {
            const int count = recv(g_client.load(), ready + received,
                static_cast<int>(sizeof(ready) - received), 0);
            if (count <= 0) break;
            received += static_cast<size_t>(count);
        }
        if (received != sizeof(ready) || std::memcmp(ready, "READY\n", sizeof(ready)) != 0) {
            if (g_running) SetError(1303, "Android playback did not become ready");
            hr = E_FAIL;
            break;
        }
        g_sendThread = std::thread(SendThread);
        hr = client->Start();
        if (FAILED(hr)) break;
        started = true;
        if (silentClient) {
            hr = silentClient->Start();
            if (FAILED(hr)) break;
            silentStarted = true;
        }
        g_pipeline.SetRunning(true);
        HANDLE events[] = {g_stopEvent, audioEvent, silentEvent};
        while (g_running) {
            const DWORD wait = WaitForMultipleObjects(g_source ? 2 : 3, events, FALSE, 1000);
            if (wait == WAIT_OBJECT_0) break;
            if (wait == WAIT_FAILED) { hr = HRESULT_FROM_WIN32(GetLastError()); break; }
            if (silentClient) {
                hr = FillSilence(silentClient, render, silentCapacity);
                if (FAILED(hr)) break;
            }
            UINT32 frames = 0;
            while (g_running && SUCCEEDED(hr = capture->GetNextPacketSize(&frames)) && frames) {
                BYTE* input = nullptr;
                DWORD bufferFlags = 0;
                hr = capture->GetBuffer(&input, &frames, &bufferFlags, nullptr, nullptr);
                if (FAILED(hr)) break;
                CaptureStats levels;
                auto packet = ConvertStereo(
                    (bufferFlags & AUDCLNT_BUFFERFLAGS_SILENT) ? nullptr : input,
                    frames, format, g_outputBits, &levels);
                capture->ReleaseBuffer(frames);
                g_pipeline.Push(std::move(packet), levels,
                    (bufferFlags & AUDCLNT_BUFFERFLAGS_DATA_DISCONTINUITY) != 0);
            }
            if (FAILED(hr)) break;
        }
    } while (false);
    if (FAILED(hr) && g_running) SetError(1301, "WASAPI capture failed", hr);
    g_running = false;
    g_pipeline.Stop();
    CloseSocket(g_client);
    if (started) client->Stop();
    if (silentStarted) silentClient->Stop();
    if (g_sendThread.joinable()) g_sendThread.join();
    if (capture) capture->Release();
    if (render) render->Release();
    if (silentClient) silentClient->Release();
    if (wave) CoTaskMemFree(wave);
    if (client) client->Release();
    if (device) device->Release();
    if (enumerator) enumerator->Release();
    if (audioEvent) CloseHandle(audioEvent);
    if (silentEvent) CloseHandle(silentEvent);
    if (task) AvRevertMmThreadCharacteristics(task);
    if (SUCCEEDED(com)) CoUninitialize();
    if (preciseTimer) timeEndPeriod(1);
}

extern "C" __declspec(dllexport) void AudioCapture_Stop() {
    g_running = false;
    g_connected = false;
    if (g_stopEvent) SetEvent(g_stopEvent);
    g_pipeline.Stop();
    CloseSocket(g_client);
    CloseSocket(g_listener);
    if (g_listenThread.joinable()) g_listenThread.join();
    if (g_captureThread.joinable()) g_captureThread.join();
    CloseSocket(g_client);
    g_connected = false;
}

extern "C" __declspec(dllexport) int AudioCapture_Configure(
    const char* deviceId, int source, int queueMs, int outputBits) {
    if (g_running || (source != 0 && source != 1) || queueMs < 10 ||
        queueMs > 500 || (outputBits != 16 && outputBits != 32)) return 0;
    g_deviceId = deviceId ? deviceId : "";
    g_source = source;
    g_queueMs = queueMs;
    g_outputBits = outputBits;
    return 1;
}

extern "C" __declspec(dllexport) int AudioCapture_Initialize() {
    {
        std::lock_guard<std::mutex> lock(g_errorMutex);
        g_errorCode = 0;
        g_errorMessage.clear();
    }
    if (!g_wsaInitialized) {
        WSADATA data;
        if (WSAStartup(MAKEWORD(2, 2), &data)) return 0;
        g_wsaInitialized = true;
    }
    if (!g_stopEvent) g_stopEvent = CreateEvent(nullptr, TRUE, FALSE, nullptr);
    return g_stopEvent ? 1 : 0;
}

extern "C" __declspec(dllexport) int AudioCapture_Listen(int port, ConnectCallback callback) {
    AudioCapture_Stop();
    ResetEvent(g_stopEvent);
    g_connectCode.clear();
    const SOCKET listener = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (listener == INVALID_SOCKET) return 0;
    sockaddr_in address{};
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
    address.sin_port = htons(static_cast<u_short>(port));
    if (bind(listener, reinterpret_cast<sockaddr*>(&address), sizeof(address)) == SOCKET_ERROR ||
        listen(listener, 1) == SOCKET_ERROR) {
        closesocket(listener);
        SetError(1102, "Binding audio listener failed", HRESULT_FROM_WIN32(WSAGetLastError()));
        return 0;
    }
    g_listener = listener;
    g_listenThread = std::thread([listener, callback] {
        const SOCKET client = accept(listener, nullptr, nullptr);
        if (client == INVALID_SOCKET) return;
        g_client = client;
        // Stop may have closed the previous client slot before accept returned.
        // Publish first, then check cancellation so Stop can always join promptly.
        if (WaitForSingleObject(g_stopEvent, 0) != WAIT_TIMEOUT) return;
        int enabled = 1;
        int sendBuffer = 8192;
        DWORD timeout = 5000;
        setsockopt(client, IPPROTO_TCP, TCP_NODELAY, reinterpret_cast<char*>(&enabled), sizeof(enabled));
        setsockopt(client, SOL_SOCKET, SO_SNDBUF, reinterpret_cast<char*>(&sendBuffer), sizeof(sendBuffer));
        setsockopt(client, SOL_SOCKET, SO_RCVTIMEO, reinterpret_cast<char*>(&timeout), sizeof(timeout));
        timeout = 500;
        setsockopt(client, SOL_SOCKET, SO_SNDTIMEO, reinterpret_cast<char*>(&timeout), sizeof(timeout));
        char code[256]{};
        int length = 0;
        // Newline frames the handshake, rather than relying on one recv call.
        while (length < 255) {
            if (recv(client, code + length, 1, 0) != 1) return;
            if (code[length] == '\n') break;
            ++length;
        }
        if (!length || length == 255) return;
        g_connectCode.assign(code, static_cast<size_t>(length));
        g_connected.store(true, std::memory_order_release);
        if (callback) callback(g_connectCode.c_str());
    });
    return 1;
}

extern "C" __declspec(dllexport) int AudioCapture_Start() {
    if (!g_connected || g_client == INVALID_SOCKET || g_captureThread.joinable()) return 0;
    g_running = true;
    ResetEvent(g_stopEvent);
    g_captureThread = std::thread(CaptureThread);
    return 1;
}

extern "C" __declspec(dllexport) int AudioCapture_IsConnected(char* buffer, int size) {
    if (!g_connected.load(std::memory_order_acquire)) return 0;
    if (buffer && size > 0) {
        const size_t length = std::min(g_connectCode.size(), static_cast<size_t>(size - 1));
        std::memcpy(buffer, g_connectCode.data(), length);
        buffer[length] = 0;
    }
    return 1;
}

extern "C" __declspec(dllexport) int AudioCapture_GetStats(CaptureStats* stats) {
    if (!stats) return 0;
    *stats = g_pipeline.Snapshot();
    return 1;
}

extern "C" __declspec(dllexport) int AudioCapture_EnumerateDevices(int source) {
    g_devices.clear();
    const HRESULT com = CoInitializeEx(nullptr, COINIT_MULTITHREADED);
    IMMDeviceEnumerator* enumerator = nullptr;
    IMMDeviceCollection* collection = nullptr;
    IMMDevice* defaultDevice = nullptr;
    LPWSTR defaultId = nullptr;
    HRESULT hr = CoCreateInstance(__uuidof(MMDeviceEnumerator), nullptr, CLSCTX_ALL,
        __uuidof(IMMDeviceEnumerator), reinterpret_cast<void**>(&enumerator));
    if (SUCCEEDED(hr)) {
        const EDataFlow flow = source ? eCapture : eRender;
        if (SUCCEEDED(enumerator->GetDefaultAudioEndpoint(flow, eConsole, &defaultDevice))) {
            defaultDevice->GetId(&defaultId);
        }
        hr = enumerator->EnumAudioEndpoints(flow, DEVICE_STATE_ACTIVE, &collection);
    }
    if (SUCCEEDED(hr)) {
        UINT count = 0;
        collection->GetCount(&count);
        for (UINT index = 0; index < count; ++index) {
            IMMDevice* device = nullptr;
            IPropertyStore* properties = nullptr;
            LPWSTR id = nullptr;
            PROPVARIANT name;
            PropVariantInit(&name);
            if (SUCCEEDED(collection->Item(index, &device)) &&
                SUCCEEDED(device->GetId(&id)) &&
                SUCCEEDED(device->OpenPropertyStore(STGM_READ, &properties)) &&
                SUCCEEDED(properties->GetValue(PKEY_Device_FriendlyName, &name)) &&
                name.vt == VT_LPWSTR) {
                g_devices.push_back({Utf8(id), Utf8(name.pwszVal),
                    defaultId && wcscmp(defaultId, id) == 0});
            }
            PropVariantClear(&name);
            if (properties) properties->Release();
            if (id) CoTaskMemFree(id);
            if (device) device->Release();
        }
    }
    if (defaultId) CoTaskMemFree(defaultId);
    if (defaultDevice) defaultDevice->Release();
    if (collection) collection->Release();
    if (enumerator) enumerator->Release();
    if (SUCCEEDED(com)) CoUninitialize();
    return static_cast<int>(g_devices.size());
}

extern "C" __declspec(dllexport) const char* AudioCapture_GetDeviceId(int index) {
    return index >= 0 && static_cast<size_t>(index) < g_devices.size()
        ? g_devices[static_cast<size_t>(index)].id.c_str() : "";
}

extern "C" __declspec(dllexport) const char* AudioCapture_GetDeviceName(int index) {
    return index >= 0 && static_cast<size_t>(index) < g_devices.size()
        ? g_devices[static_cast<size_t>(index)].name.c_str() : "";
}

extern "C" __declspec(dllexport) int AudioCapture_GetDeviceIsDefault(int index) {
    return index >= 0 && static_cast<size_t>(index) < g_devices.size() &&
        g_devices[static_cast<size_t>(index)].isDefault ? 1 : 0;
}

extern "C" __declspec(dllexport) int AudioCapture_GetLastErrorCode() {
    std::lock_guard<std::mutex> lock(g_errorMutex);
    return g_errorCode;
}

extern "C" __declspec(dllexport) const char* AudioCapture_GetLastErrorMessage() {
    static thread_local std::string snapshot;
    std::lock_guard<std::mutex> lock(g_errorMutex);
    snapshot = g_errorMessage;
    return snapshot.c_str();
}

extern "C" __declspec(dllexport) void AudioCapture_ClearLastError() {
    std::lock_guard<std::mutex> lock(g_errorMutex);
    g_errorCode = 0;
    g_errorMessage.clear();
}

extern "C" __declspec(dllexport) void AudioCapture_Cleanup() {
    AudioCapture_Stop();
    if (g_stopEvent) { CloseHandle(g_stopEvent); g_stopEvent = nullptr; }
    if (g_wsaInitialized) { WSACleanup(); g_wsaInitialized = false; }
}
