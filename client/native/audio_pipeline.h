#pragma once

#include <algorithm>
#include <chrono>
#include <cmath>
#include <condition_variable>
#include <cstdint>
#include <cstring>
#include <deque>
#include <mutex>
#include <vector>

struct CaptureStats {
    uint64_t capturedFrames = 0;
    uint64_t sentFrames = 0;
    uint64_t sentBytes = 0;
    uint64_t droppedFrames = 0;
    uint64_t discontinuities = 0;
    uint64_t packets = 0;
    uint32_t sampleRate = 0;
    uint32_t channels = 2;
    uint32_t bits = 16;
    uint32_t queuedFrames = 0;
    uint32_t capacityFrames = 0;
    uint32_t running = 0;
    uint32_t inputChannels = 0;
    uint32_t inputBits = 0;
    float peakLeft = 0;
    float peakRight = 0;
    float rmsLeft = 0;
    float rmsRight = 0;
    double captureIntervalMs = 0;
    double sendTimeMs = 0;
};

enum class SampleType { Pcm8, Pcm16, Pcm24, Pcm32, Float32, Float64 };

struct InputFormat {
    SampleType type = SampleType::Float32;
    int channels = 2;
    int bytesPerSample = 4;
    uint32_t channelMask = 3;
};

inline float ReadSample(const uint8_t* src, SampleType type) {
    switch (type) {
    case SampleType::Pcm8:
        return static_cast<float>(static_cast<int>(*src) - 128) / 128.0f;
    case SampleType::Pcm16: {
        int16_t value;
        std::memcpy(&value, src, sizeof(value));
        return static_cast<float>(value) / 32768.0f;
    }
    case SampleType::Pcm24: {
        int32_t value = src[0] | (src[1] << 8) | (src[2] << 16);
        if (value & 0x800000) value -= 0x1000000;
        return static_cast<float>(value) / 8388608.0f;
    }
    case SampleType::Pcm32: {
        int32_t value;
        std::memcpy(&value, src, sizeof(value));
        return static_cast<float>(value / 2147483648.0);
    }
    case SampleType::Float64: {
        double value;
        std::memcpy(&value, src, sizeof(value));
        return static_cast<float>(value);
    }
    case SampleType::Float32: {
        float value;
        std::memcpy(&value, src, sizeof(value));
        return value;
    }
    }
    return 0;
}

inline float FiniteSample(float value) {
    return std::isfinite(value) ? value : 0.0f;
}

inline int16_t ToPcm16(float value) {
    value = std::clamp(FiniteSample(value), -1.0f, 1.0f);
    const int rounded = static_cast<int>(std::lround(value * 32768.0f));
    return static_cast<int16_t>(std::clamp(rounded, -32768, 32767));
}

struct AudioPacket {
    std::vector<uint8_t> bytes;
    uint32_t frames = 0;
};

// Channel-mask order follows WAVEFORMATEXTENSIBLE. Normalize the stereo
// matrix for headroom; LFE is excluded from the full-range stereo downmix.
inline AudioPacket ConvertStereo(const uint8_t* input, uint32_t frames,
    const InputFormat& format, int outputBits, CaptureStats* levels) {
    AudioPacket packet;
    packet.frames = frames;
    const int outputBytes = outputBits / 8;
    packet.bytes.resize(static_cast<size_t>(frames) * 2 * outputBytes);
    std::vector<float> weightsLeft(static_cast<size_t>(format.channels), 0);
    std::vector<float> weightsRight(static_cast<size_t>(format.channels), 0);
    uint32_t mask = format.channelMask;
    if (!mask && format.channels > 2) {
        mask = format.channels == 6 ? 0x3f :
            format.channels == 8 ? 0x63f :
            format.channels == 4 ? 0x33 : 0;
    }
    if (format.channels == 1) {
        weightsLeft[0] = weightsRight[0] = 1;
    } else if (format.channels == 2) {
        weightsLeft[0] = weightsRight[1] = 1;
    } else {
        int channel = 0;
        for (uint32_t speaker = 1; speaker && channel < format.channels; speaker <<= 1) {
            if (!(mask & speaker)) continue;
            if (speaker == 1) weightsLeft[channel] = 1;
            else if (speaker == 2) weightsRight[channel] = 1;
            else if (speaker == 4 || speaker == 256) {
                weightsLeft[channel] = weightsRight[channel] = 0.70710678f;
            } else if (speaker == 16 || speaker == 64 || speaker == 512) {
                weightsLeft[channel] = 0.70710678f;
            } else if (speaker == 32 || speaker == 128 || speaker == 1024) {
                weightsRight[channel] = 0.70710678f;
            }
            ++channel;
        }
        if (!mask) weightsLeft[0] = weightsRight[1] = 1;
        float sumLeft = 0, sumRight = 0;
        for (int c = 0; c < format.channels; ++c) {
            sumLeft += weightsLeft[c];
            sumRight += weightsRight[c];
        }
        const float scale = 1.0f / std::max(1.0f, std::max(sumLeft, sumRight));
        for (int c = 0; c < format.channels; ++c) {
            weightsLeft[c] *= scale;
            weightsRight[c] *= scale;
        }
    }
    double squaresLeft = 0, squaresRight = 0;
    levels->peakLeft = levels->peakRight = 0;
    for (uint32_t frame = 0; frame < frames; ++frame) {
        float left = 0, right = 0;
        if (input) {
            for (int channel = 0; channel < format.channels; ++channel) {
                const size_t index = (static_cast<size_t>(frame) * format.channels + channel)
                    * format.bytesPerSample;
                const float sample = FiniteSample(ReadSample(input + index, format.type));
                left += sample * weightsLeft[channel];
                right += sample * weightsRight[channel];
            }
        }
        levels->peakLeft = std::max(levels->peakLeft, std::abs(left));
        levels->peakRight = std::max(levels->peakRight, std::abs(right));
        squaresLeft += static_cast<double>(left) * left;
        squaresRight += static_cast<double>(right) * right;
        if (outputBits == 32) {
            std::memcpy(packet.bytes.data() + static_cast<size_t>(frame) * 8, &left, 4);
            std::memcpy(packet.bytes.data() + static_cast<size_t>(frame) * 8 + 4, &right, 4);
        } else {
            const int16_t pcm[] = {ToPcm16(left), ToPcm16(right)};
            std::memcpy(packet.bytes.data() + static_cast<size_t>(frame) * 4, pcm, 4);
        }
    }
    levels->rmsLeft = frames ? static_cast<float>(std::sqrt(squaresLeft / frames)) : 0;
    levels->rmsRight = frames ? static_cast<float>(std::sqrt(squaresRight / frames)) : 0;
    return packet;
}

class AudioPipeline {
public:
    void Reset(uint32_t rate, uint32_t bits, uint32_t queueMs,
        uint32_t inputChannels, uint32_t inputBits) {
        std::lock_guard<std::mutex> lock(mutex_);
        queue_.clear();
        stats_ = {};
        stats_.sampleRate = rate;
        stats_.bits = bits;
        stats_.capacityFrames = std::max(1u, rate * queueMs / 1000);
        stats_.inputChannels = inputChannels;
        stats_.inputBits = inputBits;
        stopped_ = false;
        previousCapture_ = {};
    }

    void Push(AudioPacket packet, const CaptureStats& levels, bool discontinuity) {
        std::lock_guard<std::mutex> lock(mutex_);
        if (stopped_) return;
        const auto now = std::chrono::steady_clock::now();
        if (previousCapture_.time_since_epoch().count()) {
            stats_.captureIntervalMs =
                std::chrono::duration<double, std::milli>(now - previousCapture_).count();
        }
        previousCapture_ = now;
        stats_.capturedFrames += packet.frames;
        ++stats_.packets;
        if (discontinuity) ++stats_.discontinuities;
        stats_.peakLeft = levels.peakLeft;
        stats_.peakRight = levels.peakRight;
        stats_.rmsLeft = levels.rmsLeft;
        stats_.rmsRight = levels.rmsRight;
        const uint32_t frameBytes = 2 * stats_.bits / 8;
        if (packet.frames > stats_.capacityFrames) {
            const uint32_t excess = packet.frames - stats_.capacityFrames;
            packet.bytes.erase(packet.bytes.begin(), packet.bytes.begin() +
                static_cast<ptrdiff_t>(excess) * frameBytes);
            packet.frames -= excess;
            stats_.droppedFrames += excess;
        }
        while (!queue_.empty() && stats_.queuedFrames + packet.frames > stats_.capacityFrames) {
            stats_.queuedFrames -= queue_.front().frames;
            stats_.droppedFrames += queue_.front().frames;
            queue_.pop_front();
        }
        stats_.queuedFrames += packet.frames;
        queue_.push_back(std::move(packet));
        ready_.notify_one();
    }

    bool Pop(AudioPacket* packet) {
        std::unique_lock<std::mutex> lock(mutex_);
        ready_.wait(lock, [&] { return stopped_ || !queue_.empty(); });
        if (stopped_) return false;
        *packet = std::move(queue_.front());
        queue_.pop_front();
        stats_.queuedFrames -= packet->frames;
        return true;
    }

    void Sent(const AudioPacket& packet, double elapsedMs) {
        std::lock_guard<std::mutex> lock(mutex_);
        stats_.sentFrames += packet.frames;
        stats_.sentBytes += packet.bytes.size();
        stats_.sendTimeMs = elapsedMs;
    }

    void SetRunning(bool running) {
        std::lock_guard<std::mutex> lock(mutex_);
        stats_.running = running ? 1u : 0u;
    }

    void Stop() {
        std::lock_guard<std::mutex> lock(mutex_);
        stopped_ = true;
        stats_.running = 0;
        stats_.queuedFrames = 0;
        queue_.clear();
        ready_.notify_all();
    }

    CaptureStats Snapshot() {
        std::lock_guard<std::mutex> lock(mutex_);
        CaptureStats snapshot = stats_;
        if (stopped_ || (previousCapture_.time_since_epoch().count() &&
            std::chrono::steady_clock::now() - previousCapture_ > std::chrono::milliseconds(500))) {
            snapshot.peakLeft = snapshot.peakRight = 0;
            snapshot.rmsLeft = snapshot.rmsRight = 0;
        }
        return snapshot;
    }

private:
    std::mutex mutex_;
    std::condition_variable ready_;
    std::deque<AudioPacket> queue_;
    CaptureStats stats_;
    bool stopped_ = true;
    std::chrono::steady_clock::time_point previousCapture_;
};
