package com.ysbing.audioshare;

import java.io.IOException;
import java.io.InputStream;

/** Frame alignment and bounded write progress, independent of Android APIs. */
final class PcmStream {
    interface Sink {
        int write(byte[] bytes, int offset, int length) throws IOException;
    }

    /** Drain transport independently of AudioTrack backpressure; keep newest frames. */
    static final class Queue {
        private final byte[] data;
        private final int frameBytes;
        private int head;
        private int size;
        private long droppedFrames;
        private boolean closed;
        private IOException failure;

        Queue(int capacityFrames, int frameBytes) {
            if (capacityFrames <= 0 || frameBytes <= 0
                    || capacityFrames > Integer.MAX_VALUE / frameBytes) {
                throw new IllegalArgumentException("INVALID_PCM_QUEUE");
            }
            this.frameBytes = frameBytes;
            data = new byte[capacityFrames * frameBytes];
        }

        synchronized void offer(byte[] bytes, int length) {
            if (length < 0 || length > bytes.length || length % frameBytes != 0) {
                throw new IllegalArgumentException("UNALIGNED_PCM_QUEUE");
            }
            if (closed) return;
            int offset = Math.max(0, length - data.length);
            droppedFrames += offset / frameBytes;
            int retained = length - offset;
            int discard = Math.max(0, size + retained - data.length);
            head = (head + discard) % data.length;
            size -= discard;
            droppedFrames += discard / frameBytes;
            int tail = (head + size) % data.length;
            int first = Math.min(retained, data.length - tail);
            System.arraycopy(bytes, offset, data, tail, first);
            System.arraycopy(bytes, offset + first, data, 0, retained - first);
            size += retained;
            notifyAll();
        }

        synchronized int take(byte[] bytes, int maxBytes) throws IOException {
            if (maxBytes <= 0 || maxBytes > bytes.length || maxBytes % frameBytes != 0) {
                throw new IllegalArgumentException("UNALIGNED_PCM_QUEUE");
            }
            while (size == 0 && !closed) {
                try {
                    wait();
                } catch (InterruptedException interrupted) {
                    Thread.currentThread().interrupt();
                    throw new IOException("PLAYBACK_CANCELLED", interrupted);
                }
            }
            if (size == 0) {
                if (failure != null) throw failure;
                return -1;
            }
            int count = Math.min(size, maxBytes);
            int first = Math.min(count, data.length - head);
            System.arraycopy(data, head, bytes, 0, first);
            System.arraycopy(data, 0, bytes, first, count - first);
            head = (head + count) % data.length;
            size -= count;
            return count;
        }

        synchronized void close(IOException error) {
            closed = true;
            failure = error;
            notifyAll();
        }

        synchronized int queuedFrames() { return size / frameBytes; }
        synchronized long droppedFrames() { return droppedFrames; }
    }

    /** Grow only when actual underruns occur; never shrink repeatedly and oscillate. */
    static final class BufferTuner {
        static final int MIN_STANDARD_MS = 32;
        private final int capacity;
        private final int step;
        private final boolean adaptive;
        private int frames;
        private int previousUnderruns;
        private int adjustments;

        BufferTuner(int rate, int requested, int capacity, int chunkFrames,
                boolean fast, boolean adaptive) {
            this.capacity = capacity;
            this.adaptive = adaptive;
            step = Math.max(chunkFrames, rate * 2 / 1000);
            // Cover a >20 ms standard mixer turn plus a 10 ms source packet.
            // Devices granting FAST keep the requested size.
            frames = Math.min(capacity, adaptive && !fast
                    ? Math.max(requested, rate * MIN_STANDARD_MS / 1000) : requested);
        }

        int observeUnderruns(int underruns) {
            if (adaptive && underruns > previousUnderruns && frames < capacity) {
                frames = Math.min(capacity, frames + step);
                adjustments++;
            }
            previousUnderruns = underruns;
            return frames;
        }

        int frames() { return frames; }
        int adjustments() { return adjustments; }
    }

    static final class Reader {
        private final InputStream input;
        private final int frameBytes;
        private final byte[] tail;
        private int tailLength;

        Reader(InputStream input, int frameBytes) {
            this.input = input;
            this.frameBytes = frameBytes;
            this.tail = new byte[frameBytes];
        }

        int read(byte[] buffer, int maxBytes) throws IOException {
            if (maxBytes < frameBytes || maxBytes > buffer.length || maxBytes % frameBytes != 0) {
                throw new IllegalArgumentException("READ_SIZE_NOT_FRAME_ALIGNED");
            }
            int total = tailLength;
            System.arraycopy(tail, 0, buffer, 0, total);
            tailLength = 0;
            int zeroReads = 0;
            while (true) {
                int read = input.read(buffer, total, maxBytes - total);
                if (read == -1) {
                    if (total != 0) throw new IOException("TRUNCATED_PCM_FRAME");
                    return -1;
                }
                if (read == 0) {
                    if (++zeroReads >= 8) throw new IOException("INPUT_NO_PROGRESS");
                    continue;
                }
                total += read;
                int complete = total - total % frameBytes;
                if (complete > 0) {
                    tailLength = total - complete;
                    System.arraycopy(buffer, complete, tail, 0, tailLength);
                    return complete;
                }
            }
        }
    }

    static void writeFully(Sink sink, byte[] bytes, int length, int frameBytes)
            throws IOException {
        if (length % frameBytes != 0) throw new IOException("UNALIGNED_PCM_WRITE");
        int offset = 0;
        int zeroWrites = 0;
        while (offset < length) {
            if (Thread.currentThread().isInterrupted()) throw new IOException("PLAYBACK_CANCELLED");
            int written = sink.write(bytes, offset, length - offset);
            if (written < 0) throw new IOException("AUDIO_TRACK_WRITE_FAILED: " + written);
            if (written > length - offset || written % frameBytes != 0) {
                throw new IOException("INVALID_AUDIO_TRACK_WRITE");
            }
            if (written == 0) {
                if (++zeroWrites >= 8) throw new IOException("AUDIO_TRACK_NO_PROGRESS");
                try {
                    Thread.sleep(2);
                } catch (InterruptedException interrupted) {
                    Thread.currentThread().interrupt();
                    throw new IOException("PLAYBACK_CANCELLED", interrupted);
                }
            } else {
                zeroWrites = 0;
                offset += written;
            }
        }
    }
}
