#include "audio_pipeline.h"

#include <cassert>
#include <iostream>
#include <limits>

int main() {
    CaptureStats levels;
    InputFormat format;
    format.type = SampleType::Pcm16;
    format.bytesPerSample = 2;
    std::vector<int16_t> samples;
    for (int sample = -32768; sample <= 32767; ++sample) {
        samples.push_back(static_cast<int16_t>(sample));
        samples.push_back(static_cast<int16_t>(sample));
    }
    auto converted = ConvertStereo(reinterpret_cast<const uint8_t*>(samples.data()),
        65536, format, 16, &levels);
    assert(converted.bytes.size() == samples.size() * sizeof(int16_t));
    assert(std::memcmp(converted.bytes.data(), samples.data(), converted.bytes.size()) == 0);

    format = {};
    format.channels = 1;
    format.channelMask = 4;
    const float mono[] = {-1, 0.125f, 1};
    converted = ConvertStereo(reinterpret_cast<const uint8_t*>(mono), 3, format, 32, &levels);
    float stereo[6];
    std::memcpy(stereo, converted.bytes.data(), sizeof(stereo));
    for (int frame = 0; frame < 3; ++frame) {
        assert(stereo[frame * 2] == mono[frame]);
        assert(stereo[frame * 2 + 1] == mono[frame]);
    }
    format.channels = 6;
    format.channelMask = 0x3f;
    const float center[] = {0, 0, 0.5f, 0, 0, 0};
    converted = ConvertStereo(reinterpret_cast<const uint8_t*>(center), 1, format, 32, &levels);
    std::memcpy(stereo, converted.bytes.data(), 8);
    assert(stereo[0] > 0.1f && stereo[0] == stereo[1]);
    const uint8_t pcm24[] = {0, 0, 0x80};
    assert(ReadSample(pcm24, SampleType::Pcm24) == -1.0f);
    assert(ToPcm16(std::numeric_limits<float>::quiet_NaN()) == 0);
    assert(ToPcm16(2.0f) == 32767);

    AudioPipeline pipeline;
    pipeline.Reset(1000, 16, 10, 2, 16);
    AudioPacket packet;
    packet.frames = 8;
    packet.bytes.resize(32);
    pipeline.Push(packet, levels, false);
    pipeline.Push(packet, levels, true);
    auto stats = pipeline.Snapshot();
    assert(stats.queuedFrames == 8 && stats.droppedFrames == 8);
    assert(stats.discontinuities == 1);
    packet.frames = 20;
    packet.bytes.resize(80);
    pipeline.Push(packet, levels, false);
    stats = pipeline.Snapshot();
    assert(stats.queuedFrames == 10 && stats.droppedFrames == 26);
    assert(pipeline.Pop(&packet) && packet.frames == 10 && packet.bytes.size() == 40);
    pipeline.Sent(packet, 1.5);
    assert(pipeline.Snapshot().sentBytes == 40);
    pipeline.Stop();
    assert(!pipeline.Pop(&packet));
    std::cout << "PCM precision, mono, downmix, bounds, and queue tests passed.\n";
}
