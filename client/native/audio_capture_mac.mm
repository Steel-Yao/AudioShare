// macOS system audio capture via ScreenCaptureKit (macOS 13+).
// Exports the same C interface as audio_capture.dll on Windows so the
// Dart layer can use identical FFI bindings on both platforms.
//
// Flow mirrors the Windows WASAPI implementation:
//   Initialize → Listen (TCP server) → Start (begin audio stream) → Stop/Cleanup

#import <Foundation/Foundation.h>
#import <ScreenCaptureKit/ScreenCaptureKit.h>
#import <CoreGraphics/CoreGraphics.h>
#include <AudioToolbox/AudioToolbox.h>
#include <sys/socket.h>
#include <netinet/tcp.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <pthread.h>
#include <string.h>
#include <stdlib.h>
#include <atomic>
#include <memory>
#include <thread>
#include "audio_pipeline.h"

// ---- Callback type (matches Windows declaration) ----
typedef void (*ConnectCallback)(const char* connectCode);

// ---- Global state ----
static std::atomic<int> g_bListening{0};
static std::atomic<int> g_bRunning{0};
static std::atomic<int> g_bConnected{0};
static char         g_connectCodeBuf[256] = {0};
static ConnectCallback g_connectCallback  = NULL;

static std::atomic<int> g_listenFd{-1};
static std::atomic<int> g_clientFd{-1};

static pthread_t     g_listenThread;
static pthread_cond_t  g_listenReadyCond  = PTHREAD_COND_INITIALIZER;
static pthread_mutex_t g_listenReadyMutex = PTHREAD_MUTEX_INITIALIZER;
static int g_listenReady = 0;  // 0=pending, 1=ok, -1=error
static bool g_hasListenThread = false;
static int g_outputBits = 16;
static int g_queueMs = 60;
static AudioPipeline g_pipeline;
static std::thread g_sendThread;

// Objective-C objects — retained via __strong in a wrapper to avoid ARC issues
// in a mixed C/ObjC++ translation unit.
static __strong id g_stream   = nil;
static __strong id g_delegate = nil;
static std::mutex g_streamMutex;
static uint64_t g_generation = 0;
static bool g_starting = false;

static pthread_mutex_t g_errorMutex = PTHREAD_MUTEX_INITIALIZER;
static int  g_lastErrorCode = 0;
static char g_lastErrorMessage[1024] = {0};
static thread_local char g_errorMessageSnapshot[1024] = {0};

static const int kSocketAudioBufferBytes = 8192;

// ---- Helpers ----
static void ClearCaptureError() {
    pthread_mutex_lock(&g_errorMutex);
    g_lastErrorCode = 0;
    g_lastErrorMessage[0] = '\0';
    pthread_mutex_unlock(&g_errorMutex);
}

static void SetCaptureError(int code) {
    pthread_mutex_lock(&g_errorMutex);
    g_lastErrorCode = code;
    g_lastErrorMessage[0] = '\0';
    pthread_mutex_unlock(&g_errorMutex);
}

static void SetNSErrorCaptureError(int code, NSError* error) {
    pthread_mutex_lock(&g_errorMutex);
    g_lastErrorCode = code;
    snprintf(g_lastErrorMessage, sizeof(g_lastErrorMessage), "%s",
        error ? error.localizedDescription.UTF8String : "");
    pthread_mutex_unlock(&g_errorMutex);
}

static bool IsScreenCapturePermissionError(NSError* error) {
    return error && [error.domain isEqualToString:SCStreamErrorDomain] &&
        error.code == SCStreamErrorUserDeclined;
}

static bool SendAll(int fd, const void* data, size_t len) {
    const uint8_t* ptr = (const uint8_t*)data;
    while (len > 0) {
        ssize_t sent = send(fd, ptr, len, 0);
        if (sent <= 0) return false;
        ptr += sent;
        len -= (size_t)sent;
    }
    return true;
}

static void CloseSocket(std::atomic<int>& socket) {
    const int fd = socket.exchange(-1);
    if (fd >= 0) {
        shutdown(fd, SHUT_RDWR);
        close(fd);
    }
}

// ---- TCP listen thread ----
// Accepts one Android client, reads the connectCode, fires callback.
// Mirrors Windows ListenThread().
static void* ListenThread(void* arg) {
    int port = (int)(intptr_t)arg;

    int fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    if (fd < 0) {
        SetCaptureError(1101);
        goto fail;
    }
    g_listenFd = fd;
    if (!g_bListening) goto fail;

    {
        int opt = 1;
        setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt));

        struct sockaddr_in addr = {};
        addr.sin_family      = AF_INET;
        addr.sin_port        = htons((uint16_t)port);
        addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);

        if (bind(fd, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
            SetCaptureError(1102);
            goto fail;
        }
        if (listen(fd, 1) < 0) {
            SetCaptureError(1103);
            goto fail;
        }
    }

    pthread_mutex_lock(&g_listenReadyMutex);
    g_listenReady = 1;
    pthread_cond_signal(&g_listenReadyCond);
    pthread_mutex_unlock(&g_listenReadyMutex);

    {
        struct sockaddr_in clientAddr = {};
        socklen_t addrLen = sizeof(clientAddr);
        int cfd = accept(fd, (struct sockaddr*)&clientAddr, &addrLen);
        if (cfd < 0) {
            if (g_bListening) {
                SetCaptureError(1106);
            }
            return NULL;
        }
        g_clientFd = cfd;
        // Stop closes the client again after joining this listener.
        if (!g_bListening) return NULL;

        int sndbuf = kSocketAudioBufferBytes;
        setsockopt(cfd, SOL_SOCKET, SO_SNDBUF, &sndbuf, sizeof(sndbuf));
        int noDelay = 1;
        setsockopt(cfd, IPPROTO_TCP, TCP_NODELAY, &noDelay, sizeof(noDelay));
        int noSigPipe = 1;
        setsockopt(cfd, SOL_SOCKET, SO_NOSIGPIPE, &noSigPipe, sizeof(noSigPipe));
        struct timeval timeout = {0, 500000};
        setsockopt(cfd, SOL_SOCKET, SO_SNDTIMEO, &timeout, sizeof(timeout));
        timeout.tv_sec = 2;
        timeout.tv_usec = 0;
        setsockopt(cfd, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout));

        char buf[256] = {};
        ssize_t n = 0;
        while (n < 255) {
            if (recv(cfd, buf + n, 1, 0) != 1) { n = -1; break; }
            if (buf[n] == '\n') break;
            ++n;
        }
        if (n > 0 && n < 255) {
            buf[n] = '\0';
            memcpy(g_connectCodeBuf, buf, (size_t)n + 1);
            g_bConnected = 1;
            if (g_connectCallback) g_connectCallback(g_connectCodeBuf);
        } else if (g_bListening) {
            SetCaptureError(1107);
        }
    }
    return NULL;

fail:
    CloseSocket(g_listenFd);
    pthread_mutex_lock(&g_listenReadyMutex);
    g_listenReady = -1;
    pthread_cond_signal(&g_listenReadyCond);
    pthread_mutex_unlock(&g_listenReadyMutex);
    return NULL;
}

// ---- ScreenCaptureKit audio delegate ----
// Capture callbacks only convert and enqueue; sending uses its own worker.
API_AVAILABLE(macos(13.0))
@interface AudioCaptureDelegate : NSObject <SCStreamDelegate, SCStreamOutput>
@property(nonatomic) uint64_t generation;
@end

@implementation AudioCaptureDelegate

- (void)stream:(SCStream*)stream
    didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
                   ofType:(SCStreamOutputType)type {
    if (type != SCStreamOutputTypeAudio) return;
    std::lock_guard<std::mutex> lock(g_streamMutex);
    if (self.generation != g_generation || !g_bRunning) return;
    int cfd = g_clientFd;
    if (cfd < 0) return;

    CMFormatDescriptionRef fmt = CMSampleBufferGetFormatDescription(sampleBuffer);
    const AudioStreamBasicDescription* asbd =
        CMAudioFormatDescriptionGetStreamBasicDescription(fmt);
    if (!asbd) return;

    int numFrames = (int)CMSampleBufferGetNumSamples(sampleBuffer);
    if (numFrames <= 0) return;

    // Get the AudioBufferList.
    size_t bufListSize = 0;
    CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
        sampleBuffer, &bufListSize, NULL, 0, NULL, NULL, 0, NULL);
    if (bufListSize == 0) return;

    AudioBufferList* abl = (AudioBufferList*)malloc(bufListSize);
    if (!abl) return;

    CMBlockBufferRef blockBuf = NULL;
    OSStatus st = CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
        sampleBuffer, NULL, abl, bufListSize, NULL, NULL,
        kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment, &blockBuf);

    if (st != noErr) {
        free(abl);
        if (blockBuf) CFRelease(blockBuf);
        return;
    }

    BOOL nonInterleaved = (asbd->mFormatFlags & kAudioFormatFlagIsNonInterleaved) != 0;
    if (!(asbd->mFormatFlags & kAudioFormatFlagIsFloat) || asbd->mBitsPerChannel != 32 ||
        asbd->mChannelsPerFrame < 1 || asbd->mChannelsPerFrame > 2) {
        SetCaptureError(1301);
        free(abl);
        if (blockBuf) CFRelease(blockBuf);
        return;
    }
    InputFormat inputFormat;
    inputFormat.channels = (int)asbd->mChannelsPerFrame;
    std::vector<float> interleaved((size_t)numFrames * inputFormat.channels);
    bool valid = abl->mNumberBuffers >= (nonInterleaved ? (UInt32)inputFormat.channels : 1u);
    for (int channel = 0; valid && channel < inputFormat.channels; ++channel) {
        const AudioBuffer& buffer = abl->mBuffers[nonInterleaved ? channel : 0];
        const size_t required = (size_t)numFrames * sizeof(float) *
            (nonInterleaved ? 1u : (size_t)inputFormat.channels);
        valid = buffer.mData && buffer.mDataByteSize >= required;
        if (valid) {
            const float* samples = (const float*)buffer.mData;
            for (int frame = 0; frame < numFrames; ++frame) {
                interleaved[(size_t)frame * inputFormat.channels + channel] =
                    samples[nonInterleaved ? frame : frame * inputFormat.channels + channel];
            }
        }
    }
    if (valid) {
        CaptureStats levels;
        auto packet = ConvertStereo((const uint8_t*)interleaved.data(),
            (uint32_t)numFrames, inputFormat, g_outputBits, &levels);
        g_pipeline.Push(std::move(packet), levels, false);
    } else {
        SetCaptureError(1301);
    }
    free(abl);
    if (blockBuf) CFRelease(blockBuf);
}

- (void)stream:(SCStream*)stream didStopWithError:(NSError*)error {
    std::lock_guard<std::mutex> lock(g_streamMutex);
    if (self.generation != g_generation) return;
    g_bRunning = 0;
    g_pipeline.Stop();
    SetNSErrorCaptureError(1205, error);
}

@end

// ============================================================
// Exported C API — identical symbols to audio_capture.dll
// ============================================================

extern "C" __attribute__((visibility("default")))
int AudioCapture_Initialize() {
    ClearCaptureError();
    // ScreenCaptureKit requires macOS 13.0.
    if (@available(macOS 13.0, *)) {
        return 1;
    }
    SetCaptureError(1001);
    return 0;
}

extern "C" __attribute__((visibility("default")))
int AudioCapture_Configure(const char* deviceId, int source, int queueMs, int bits) {
    std::lock_guard<std::mutex> lock(g_streamMutex);
    if (g_bRunning || g_starting || source != 0 || (deviceId && deviceId[0]) ||
        queueMs < 10 || queueMs > 500 || (bits != 16 && bits != 32)) return 0;
    g_queueMs = queueMs;
    g_outputBits = bits;
    return 1;
}

extern "C" __attribute__((visibility("default")))
int AudioCapture_GetStats(CaptureStats* stats) {
    if (!stats) return 0;
    *stats = g_pipeline.Snapshot();
    return 1;
}

extern "C" __attribute__((visibility("default")))
int AudioCapture_HasPermission() {
    if (@available(macOS 13.0, *)) {
        return CGPreflightScreenCaptureAccess() ? 1 : 0;
    }
    return 0;
}

extern "C" __attribute__((visibility("default")))
int AudioCapture_RequestPermission() {
    ClearCaptureError();
    if (@available(macOS 13.0, *)) {
        if (CGPreflightScreenCaptureAccess()) return 1;
        if (CGRequestScreenCaptureAccess()) return 1;
        // CoreGraphics may keep reporting false for an allowed ScreenCaptureKit
        // app on macOS 15+. Stream startup is the authoritative check there.
        if (@available(macOS 15.0, *)) return 1;
        SetCaptureError(1002);
        return 0;
    }
    SetCaptureError(1001);
    return 0;
}

extern "C" void AudioCapture_Stop();

extern "C" __attribute__((visibility("default")))
int AudioCapture_Listen(int port, ConnectCallback callback) {
    AudioCapture_Stop();
    ClearCaptureError();
    g_connectCallback = callback;
    g_bListening = 1;

    pthread_mutex_lock(&g_listenReadyMutex);
    g_listenReady = 0;
    pthread_mutex_unlock(&g_listenReadyMutex);

    int createResult = pthread_create(
        &g_listenThread, NULL, ListenThread, (void*)(intptr_t)port);
    if (createResult != 0) {
        g_bListening = 0;
        SetCaptureError(1104);
        return 0;
    }
    g_hasListenThread = true;

    // Wait up to 5 s for ListenThread to bind and listen.
    struct timespec ts;
    clock_gettime(CLOCK_REALTIME, &ts);
    ts.tv_sec += 5;

    pthread_mutex_lock(&g_listenReadyMutex);
    while (g_listenReady == 0) {
        if (pthread_cond_timedwait(&g_listenReadyCond, &g_listenReadyMutex, &ts) != 0) break;
    }
    int ready = g_listenReady;
    pthread_mutex_unlock(&g_listenReadyMutex);

    if (ready == 0) {
        SetCaptureError(1105);
    }
    if (ready != 1) AudioCapture_Stop();
    return (ready == 1) ? 1 : 0;
}

extern "C" __attribute__((visibility("default")))
int AudioCapture_Start() {
    ClearCaptureError();
    if (@available(macOS 13.0, *)) {
        if (@available(macOS 15.0, *)) {
            // ScreenCaptureKit below performs the authoritative permission check.
        } else if (!CGPreflightScreenCaptureAccess()) {
            SetCaptureError(1002);
            return 0;
        }
        uint64_t generation;
        {
            std::lock_guard<std::mutex> lock(g_streamMutex);
            if (!g_bConnected || g_clientFd < 0 || g_bRunning || g_starting) return 0;
            generation = ++g_generation;
            g_starting = true;
        }
        auto success = std::make_shared<std::atomic<int>>(0);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);

        [SCShareableContent
            getShareableContentExcludingDesktopWindows:NO
            onScreenWindowsOnly:NO
            completionHandler:^(SCShareableContent* content, NSError* error) {
                std::unique_lock<std::mutex> lock(g_streamMutex);
                if (generation != g_generation) {
                    dispatch_semaphore_signal(sema);
                    return;
                }
                if (error || !content || content.displays.count == 0) {
                    g_starting = false;
                    if (error) {
                        SetNSErrorCaptureError(
                            IsScreenCapturePermissionError(error) ? 1002 : 1201,
                            error);
                    } else {
                        SetCaptureError(1202);
                    }
                    dispatch_semaphore_signal(sema);
                    return;
                }

                // Content filter: entire primary display → captures all system audio.
                SCContentFilter* filter =
                    [[SCContentFilter alloc] initWithDisplay:content.displays[0]
                                          excludingWindows:@[]];

                SCStreamConfiguration* config = [[SCStreamConfiguration alloc] init];
                config.capturesAudio              = YES;
                config.excludesCurrentProcessAudio = NO;
                config.sampleRate                 = 48000;
                config.channelCount               = 2;
                // Minimise video overhead — we only care about audio samples.
                config.width                  = 2;
                config.height                 = 2;
                config.minimumFrameInterval   = CMTimeMake(1, 1);  // 1 fps

                AudioCaptureDelegate* del = [[AudioCaptureDelegate alloc] init];
                del.generation = generation;
                g_delegate = del;

                SCStream* stream = [[SCStream alloc] initWithFilter:filter
                                                      configuration:config
                                                           delegate:del];
                NSError* addErr = nil;
                dispatch_queue_t q =
                    dispatch_queue_create("com.ysbing.audioshare.audio", DISPATCH_QUEUE_SERIAL);
                [stream addStreamOutput:del
                                   type:SCStreamOutputTypeAudio
                     sampleHandlerQueue:q
                                  error:&addErr];
                if (addErr) {
                    g_starting = false;
                    SetNSErrorCaptureError(1203, addErr);
                    dispatch_semaphore_signal(sema);
                    return;
                }

                // Send 8-byte format header so Android creates the correct AudioTrack.
                // [uint32 sampleRate LE][uint16 channels LE][uint16 bitsPerSample LE]
                int cfd = g_clientFd;
                if (cfd >= 0) {
                    uint8_t hdr[8];
                    uint32_t sr   = 48000;
                    uint16_t ch   = 2;
                    uint16_t bits = (uint16_t)g_outputBits;
                    memcpy(hdr + 0, &sr,   4);
                    memcpy(hdr + 4, &ch,   2);
                    memcpy(hdr + 6, &bits, 2);
                    if (!SendAll(cfd, hdr, 8)) {
                        g_starting = false;
                        SetCaptureError(1303);
                        dispatch_semaphore_signal(sema);
                        return;
                    }
                } else {
                    g_starting = false;
                    SetCaptureError(1303);
                    dispatch_semaphore_signal(sema);
                    return;
                }

                g_pipeline.Reset(48000, (uint32_t)g_outputBits, (uint32_t)g_queueMs, 2, 32);
                g_sendThread = std::thread([cfd] {
                    AudioPacket packet;
                    while (g_pipeline.Pop(&packet)) {
                        const auto start = std::chrono::steady_clock::now();
                        if (!SendAll(cfd, packet.bytes.data(), packet.bytes.size())) {
                            g_bRunning = 0;
                            g_pipeline.Stop();
                            SetCaptureError(1303);
                            return;
                        }
                        g_pipeline.Sent(packet, std::chrono::duration<double, std::milli>(
                            std::chrono::steady_clock::now() - start).count());
                    }
                });
                g_stream   = stream;
                lock.unlock();

                [stream startCaptureWithCompletionHandler:^(NSError* startErr) {
                    std::unique_lock<std::mutex> startLock(g_streamMutex);
                    if (generation != g_generation) {
                        startLock.unlock();
                        [stream stopCaptureWithCompletionHandler:^(NSError*) {}];
                        dispatch_semaphore_signal(sema);
                        return;
                    }
                    g_starting = false;
                    if (startErr) {
                        g_bRunning = 0;
                        g_pipeline.Stop();
                        g_stream   = nil;
                        g_delegate = nil;
                        SetNSErrorCaptureError(
                            IsScreenCapturePermissionError(startErr) ? 1002 : 1204,
                            startErr);
                    } else {
                        g_bRunning = 1;
                        g_pipeline.SetRunning(true);
                        success->store(1);
                    }
                    dispatch_semaphore_signal(sema);
                }];
            }];

        long waitResult = dispatch_semaphore_wait(sema,
            dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC));
        if (waitResult != 0) {
            __strong SCStream* stream = nil;
            {
                std::lock_guard<std::mutex> lock(g_streamMutex);
                if (generation == g_generation) {
                    ++g_generation;
                    g_starting = false;
                    g_bRunning = 0;
                    g_pipeline.Stop();
                    stream = (SCStream*)g_stream;
                    g_stream = nil;
                    g_delegate = nil;
                }
            }
            if (stream) {
                [stream stopCaptureWithCompletionHandler:^(NSError*) {}];
            }
            SetCaptureError(1206);
            return 0;
        }
        return success->load();
    }
    SetCaptureError(1001);
    return 0;
}

extern "C" __attribute__((visibility("default")))
void AudioCapture_Stop() {
    __strong id stream = nil;
    {
        std::lock_guard<std::mutex> lock(g_streamMutex);
        ++g_generation;
        g_starting = false;
        g_bRunning = 0;
        g_bListening = 0;
        g_pipeline.Stop();
        stream = g_stream;
        g_stream = nil;
        g_delegate = nil;
    }
    CloseSocket(g_clientFd);
    CloseSocket(g_listenFd);
    if (g_hasListenThread) { pthread_join(g_listenThread, NULL); g_hasListenThread = false; }
    CloseSocket(g_clientFd);
    g_bConnected = 0;
    g_connectCodeBuf[0] = '\0';
    if (g_sendThread.joinable()) g_sendThread.join();

    if (@available(macOS 13.0, *)) {
        if (stream) {
            [(SCStream*)stream stopCaptureWithCompletionHandler:^(NSError*) {}];
        }
    }
}

extern "C" __attribute__((visibility("default")))
void AudioCapture_Cleanup() {
    AudioCapture_Stop();
    if (g_hasListenThread) { pthread_join(g_listenThread, NULL); g_hasListenThread = false; }
    g_connectCallback  = NULL;
    g_bConnected       = 0;
    g_connectCodeBuf[0] = '\0';
}

extern "C" __attribute__((visibility("default")))
int AudioCapture_GetLastErrorCode() {
    pthread_mutex_lock(&g_errorMutex);
    int code = g_lastErrorCode;
    pthread_mutex_unlock(&g_errorMutex);
    return code;
}

extern "C" __attribute__((visibility("default")))
const char* AudioCapture_GetLastErrorMessage() {
    pthread_mutex_lock(&g_errorMutex);
    snprintf(g_errorMessageSnapshot, sizeof(g_errorMessageSnapshot), "%s",
        g_lastErrorMessage);
    pthread_mutex_unlock(&g_errorMutex);
    return g_errorMessageSnapshot;
}

extern "C" __attribute__((visibility("default")))
void AudioCapture_ClearLastError() {
    ClearCaptureError();
}

extern "C" __attribute__((visibility("default")))
int AudioCapture_IsConnected(char* outBuf, int bufSize) {
    if (!g_bConnected) return 0;
    if (outBuf && bufSize > 0) {
        int len = (int)strlen(g_connectCodeBuf);
        if (len >= bufSize) len = bufSize - 1;
        memcpy(outBuf, g_connectCodeBuf, len);
        outBuf[len] = '\0';
    }
    return 1;
}
