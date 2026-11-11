package com.ysbing.audioshare;

import android.media.AudioAttributes;
import android.media.AudioDeviceInfo;
import android.media.AudioFormat;
import android.media.AudioTimestamp;
import android.media.AudioTrack;
import android.net.LocalSocket;
import android.net.LocalSocketAddress;
import android.os.Build;
import android.os.SystemClock;

import org.json.JSONObject;

import java.io.EOFException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.charset.StandardCharsets;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.AtomicInteger;

public class Main {
    public static void main(String[] args) {
        try {
            Options options = Options.parse(args);
            try (LocalSocket socket = new LocalSocket()) {
                socket.connect(new LocalSocketAddress(options.socketName));
                socket.setReceiveBufferSize(8192);
                socket.getOutputStream().write((options.connectCode + "\n").getBytes(StandardCharsets.UTF_8));
                socket.getOutputStream().flush();
                byte[] header = new byte[8];
                int offset = 0;
                while (offset < header.length) {
                    int n = socket.getInputStream().read(header, offset, header.length - offset);
                    if (n <= 0) throw new EOFException("FORMAT_HEADER_INCOMPLETE");
                    offset += n;
                }
                ByteBuffer format = ByteBuffer.wrap(header).order(ByteOrder.LITTLE_ENDIAN);
                int sampleRate = format.getInt();
                int channels = format.getShort() & 0xffff;
                int bits = format.getShort() & 0xffff;
                if (sampleRate < 8000 || sampleRate > 192000 ||
                        (channels != 1 && channels != 2) || (bits != 16 && bits != 32)) {
                    throw new IOException("UNSUPPORTED_AUDIO_FORMAT");
                }
                play(socket.getInputStream(), socket.getOutputStream(),
                        sampleRate, channels, bits, options);
            }
        } catch (Exception error) {
            System.err.println("AUDIO_ERROR: " + error);
            error.printStackTrace();
            System.exit(1);
        }
        // app_process starts Binder threads; returning from main alone can
        // leave the shell session alive after the socket and AudioTrack close.
        System.exit(0);
    }

    private static void play(InputStream input, OutputStream readyOutput,
            int rate, int channels, int bits, Options options)
            throws Exception {
        android.os.Process.setThreadPriority(android.os.Process.THREAD_PRIORITY_AUDIO);
        final int frameBytes = channels * bits / 8;
        final int encoding = bits == 32 ? AudioFormat.ENCODING_PCM_FLOAT : AudioFormat.ENCODING_PCM_16BIT;
        final int channelMask = channels == 1 ? AudioFormat.CHANNEL_OUT_MONO : AudioFormat.CHANNEL_OUT_STEREO;
        final int minBytes = AudioTrack.getMinBufferSize(rate, channelMask, encoding);
        if (minBytes <= 0) throw new IOException("AUDIO_FORMAT_NOT_SUPPORTED: " + minBytes);
        final int requestedFrames = Math.max(1, rate * options.bufferMs / 1000);
        final int capacityBytes = Math.max(minBytes, requestedFrames * frameBytes);
        AudioTrack.Builder builder = new AudioTrack.Builder()
                .setAudioAttributes(new AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_MEDIA)
                        .setContentType(AudioAttributes.CONTENT_TYPE_MUSIC).build())
                .setAudioFormat(new AudioFormat.Builder().setEncoding(encoding)
                        .setSampleRate(rate).setChannelMask(channelMask).build())
                .setBufferSizeInBytes(capacityBytes)
                .setTransferMode(AudioTrack.MODE_STREAM);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && options.lowLatency) {
            builder.setPerformanceMode(AudioTrack.PERFORMANCE_MODE_LOW_LATENCY);
        }
        final AudioTrack track = builder.build();
        final AtomicLong writtenFrames = new AtomicLong();
        final AtomicInteger bufferAdjustments = new AtomicInteger();
        final AtomicBoolean reporting = new AtomicBoolean(false);
        final int chunkFrames = Math.max(1, rate * options.readChunkMs / 1000);
        final boolean fast = Build.VERSION.SDK_INT >= 26
                && track.getPerformanceMode() == AudioTrack.PERFORMANCE_MODE_LOW_LATENCY;
        final PcmStream.Queue queue = new PcmStream.Queue(
                Math.max(rate * (fast ? 12 : 40) / 1000, chunkFrames * 2), frameBytes);
        Thread reporter = null;
        Thread receiver = null;
        try {
            if (track.getState() != AudioTrack.STATE_INITIALIZED) {
                throw new IOException("AUDIO_TRACK_NOT_INITIALIZED");
            }
            final PcmStream.BufferTuner tuner = new PcmStream.BufferTuner(rate, requestedFrames,
                    Build.VERSION.SDK_INT >= 24 ? track.getBufferCapacityInFrames()
                            : track.getBufferSizeInFrames(),
                    chunkFrames, fast, options.lowLatency && Build.VERSION.SDK_INT >= 24);
            if (Build.VERSION.SDK_INT >= 24) {
                int result = track.setBufferSizeInFrames(tuner.frames());
                if (result <= 0) throw new IOException("AUDIO_BUFFER_CONFIG_FAILED: " + result);
            }
            int requestedPreRoll = rate * options.preRollMs / 1000;
            if (options.lowLatency && !fast) {
                requestedPreRoll = Math.max(requestedPreRoll,
                        rate * PcmStream.BufferTuner.MIN_STANDARD_MS / 1000);
            }
            int preRollFrames = Math.min(track.getBufferSizeInFrames(), requestedPreRoll);
            int startThreshold = -1;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                startThreshold = track.setStartThresholdInFrames(Math.max(1, preRollFrames));
            }
            final int effectiveThreshold = startThreshold;
            final byte[] bytes = new byte[chunkFrames * frameBytes];
            final ByteBuffer direct = ByteBuffer.allocateDirect(bytes.length).order(ByteOrder.LITTLE_ENDIAN);
            PcmStream.Sink sink = (data, offset, length) -> {
                direct.clear();
                direct.put(data, offset, length);
                direct.flip();
                int written = track.write(direct, length, AudioTrack.WRITE_BLOCKING);
                if (written > 0) writtenFrames.addAndGet(written / frameBytes);
                return written;
            };
            readyOutput.write("READY\n".getBytes(StandardCharsets.US_ASCII));
            readyOutput.flush();
            receiver = new Thread(() -> {
                android.os.Process.setThreadPriority(android.os.Process.THREAD_PRIORITY_AUDIO);
                byte[] incoming = new byte[bytes.length];
                PcmStream.Reader reader = new PcmStream.Reader(input, frameBytes);
                try {
                    int count;
                    while ((count = reader.read(incoming, incoming.length)) != -1) {
                        queue.offer(incoming, count);
                    }
                    queue.close(null);
                } catch (IOException error) {
                    queue.close(error);
                }
            }, "AudioShareReceiver");
            receiver.setDaemon(true);
            receiver.start();
            while (writtenFrames.get() < preRollFrames) {
                int remaining = preRollFrames - (int) writtenFrames.get();
                int n = queue.take(bytes, Math.min(chunkFrames, remaining) * frameBytes);
                if (n == -1) return;
                PcmStream.writeFully(sink, bytes, n, frameBytes);
            }
            track.play();
            reporting.set(true);
            reporter = new Thread(() -> report(track, reporting, writtenFrames, rate,
                    channels, bits, effectiveThreshold, queue, bufferAdjustments), "AudioShareStats");
            reporter.setDaemon(true);
            reporter.start();
            int n;
            long nextTune = SystemClock.elapsedRealtime() + 250;
            while ((n = queue.take(bytes, bytes.length)) != -1) {
                PcmStream.writeFully(sink, bytes, n, frameBytes);
                if (Build.VERSION.SDK_INT >= 24 && SystemClock.elapsedRealtime() >= nextTune) {
                    int target = tuner.observeUnderruns(track.getUnderrunCount());
                    if (target > track.getBufferSizeInFrames()) {
                        int result = track.setBufferSizeInFrames(target);
                        if (result <= 0) throw new IOException("AUDIO_BUFFER_CONFIG_FAILED: " + result);
                        // A larger capacity alone adds no queued audio. Refill
                        // once after an underrun so the new headroom is usable.
                        track.pause();
                        while (true) {
                            // Both counters describe the same stream; modulo
                            // subtraction also handles playback-head wrap.
                            long queued = (writtenFrames.get()
                                    - (track.getPlaybackHeadPosition() & 0xffffffffL)) & 0xffffffffL;
                            if (queued >= result) break;
                            int needed = (int) Math.min(chunkFrames, result - queued);
                            int count = queue.take(bytes, needed * frameBytes);
                            if (count == -1) return;
                            PcmStream.writeFully(sink, bytes, count, frameBytes);
                        }
                        track.play();
                    }
                    bufferAdjustments.set(tuner.adjustments());
                    nextTune = SystemClock.elapsedRealtime() + 250;
                }
            }
        } finally {
            reporting.set(false);
            queue.close(null);
            try { input.close(); } catch (IOException ignored) { }
            if (reporter != null) {
                reporter.interrupt();
                try { reporter.join(1000); } catch (InterruptedException interrupted) {
                    Thread.currentThread().interrupt();
                }
            }
            if (receiver != null) {
                try { receiver.join(1000); } catch (InterruptedException interrupted) {
                    Thread.currentThread().interrupt();
                }
            }
            // stop() can drain pending audio; pause/flush keeps disconnect bounded.
            if (track.getPlayState() == AudioTrack.PLAYSTATE_PLAYING) track.pause();
            track.flush();
            track.release();
        }
    }

    private static void report(AudioTrack track, AtomicBoolean active, AtomicLong written,
            int rate, int channels, int bits, int startThreshold, PcmStream.Queue queue,
            AtomicInteger bufferAdjustments) {
        long previousHead = 0;
        long wraps = 0;
        AudioTimestamp timestamp = new AudioTimestamp();
        while (active.get()) {
            try {
                long head = track.getPlaybackHeadPosition() & 0xffffffffL;
                if (head < previousHead) wraps += 1L << 32;
                previousHead = head;
                long played = head + wraps;
                long queued = Math.max(0, written.get() - played);
                AudioDeviceInfo route = track.getRoutedDevice();
                JSONObject stats = new JSONObject();
                stats.put("version", 1);
                stats.put("sampleRate", rate);
                stats.put("channels", channels);
                stats.put("bits", bits);
                stats.put("writtenFrames", written.get());
                stats.put("playedFrames", played);
                stats.put("queuedFrames", queued);
                stats.put("bufferFrames", track.getBufferSizeInFrames());
                stats.put("capacityFrames", Build.VERSION.SDK_INT >= 24
                        ? track.getBufferCapacityInFrames() : track.getBufferSizeInFrames());
                stats.put("startThresholdFrames", startThreshold);
                stats.put("underruns", Build.VERSION.SDK_INT >= 24 ? track.getUnderrunCount() : -1);
                stats.put("receiverQueuedFrames", queue.queuedFrames());
                stats.put("receiverDroppedFrames", queue.droppedFrames());
                stats.put("bufferAdjustments", bufferAdjustments.get());
                if (track.getTimestamp(timestamp)) {
                    long presented = timestamp.framePosition + Math.max(0,
                            System.nanoTime() - timestamp.nanoTime) * rate / 1_000_000_000L;
                    stats.put("outputPendingFrames", Math.max(0, written.get() - presented));
                }
                stats.put("performanceMode", Build.VERSION.SDK_INT >= 26 ? track.getPerformanceMode() : -1);
                stats.put("route", route == null ? "" : route.getProductName().toString());
                stats.put("deviceTimeMs", SystemClock.elapsedRealtime());
                System.out.println("AUDIO_STATS " + stats);
                System.out.flush();
                Thread.sleep(500);
            } catch (InterruptedException interrupted) {
                Thread.currentThread().interrupt();
                return;
            } catch (Exception error) {
                System.err.println("AUDIO_STATS_ERROR: " + error);
                return;
            }
        }
    }
}
