package com.ysbing.audioshare;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.concurrent.FutureTask;
import java.util.concurrent.TimeUnit;

public final class PcmStreamTest {
    public static void main(String[] args) throws Exception {
        for (int frameBytes : new int[]{4, 8}) {
            for (int chunk : new int[]{1, 2, 3, 5, 7, 13, 32}) {
                byte[] source = new byte[frameBytes * 101];
                for (int i = 0; i < source.length; i++) source[i] = (byte) i;
                InputStream fragmented = new ByteArrayInputStream(source) {
                    @Override
                    public synchronized int read(byte[] bytes, int offset, int length) {
                        return super.read(bytes, offset, Math.min(length, chunk));
                    }
                };
                PcmStream.Reader reader = new PcmStream.Reader(fragmented, frameBytes);
                byte[] buffer = new byte[frameBytes * 9];
                ByteArrayOutputStream received = new ByteArrayOutputStream();
                int n;
                while ((n = reader.read(buffer, buffer.length)) != -1) {
                    final int size = frameBytes;
                    PcmStream.writeFully((bytes, offset, length) -> {
                        int written = Math.min(length, size);
                        received.write(bytes, offset, written);
                        return written;
                    }, buffer, n, frameBytes);
                }
                if (!Arrays.equals(source, received.toByteArray())) throw new AssertionError("PCM changed");
            }
        }
        expectFailure(() -> PcmStream.writeFully((b, o, n) -> 0, new byte[4], 4, 4));
        expectFailure(() -> PcmStream.writeFully((b, o, n) -> -6, new byte[4], 4, 4));
        expectFailure(() -> new PcmStream.Reader(new ByteArrayInputStream(new byte[3]), 4)
                .read(new byte[16], 16));
        for (int frameBytes : new int[]{4, 8}) testQueue(frameBytes);
        testBufferTuner();
        Options options = Options.parse("socketName=test", "connectCode=test", "bufferMs=40", "preRollMs=10");
        if (options.bufferMs != 40 || options.preRollMs != 10) throw new AssertionError("Options lost");
        try {
            Options.parse("socketName=test", "connectCode=test", "bufferMs=-1");
            throw new AssertionError("Invalid buffer accepted");
        } catch (IllegalArgumentException expected) {
            // Range validation must happen before attempting a connection.
        }
        System.out.println("PCM framing, writes, bounded receiver queue, adaptive buffers, EOF, and options passed.");
    }

    private static void testQueue(int frameBytes) throws Exception {
        PcmStream.Queue queue = new PcmStream.Queue(3, frameBytes);
        byte[] first = new byte[2 * frameBytes];
        byte[] latest = new byte[3 * frameBytes];
        for (int i = 0; i < latest.length; ++i) latest[i] = (byte) (i + 7);
        byte[] result = new byte[3 * frameBytes];
        queue.offer(first, first.length);
        if (queue.take(result, frameBytes) != frameBytes) throw new AssertionError("Queue read");
        queue.offer(latest, latest.length);
        if (queue.droppedFrames() != 1 || queue.queuedFrames() != 3) {
            throw new AssertionError("Queue must evict whole old frames");
        }
        queue.close(null);
        if (queue.take(result, result.length) != result.length || !Arrays.equals(result, latest)) {
            throw new AssertionError("Ring wrap changed retained PCM");
        }
        if (queue.take(result, result.length) != -1) throw new AssertionError("Queue EOF");

        queue = new PcmStream.Queue(3, frameBytes);
        byte[] oversized = new byte[5 * frameBytes];
        for (int i = 0; i < oversized.length; ++i) oversized[i] = (byte) i;
        queue.offer(oversized, oversized.length);
        queue.take(result, result.length);
        if (!Arrays.equals(result, Arrays.copyOfRange(oversized, 2 * frameBytes, oversized.length))
                || queue.droppedFrames() != 2) {
            throw new AssertionError("Oversized packet must retain newest frames");
        }
        queue.close(new IOException("test failure"));
        final PcmStream.Queue failed = queue;
        expectFailure(() -> failed.take(result, result.length));

        final PcmStream.Queue waiting = new PcmStream.Queue(3, frameBytes);
        FutureTask<Integer> read = new FutureTask<>(() -> waiting.take(result, result.length));
        Thread consumer = new Thread(read);
        consumer.start();
        waiting.close(null);
        try {
            if (read.get(1, TimeUnit.SECONDS) != -1) throw new AssertionError("Expected EOF");
        } finally {
            consumer.interrupt();
            consumer.join(1000);
        }
    }

    private static void testBufferTuner() {
        PcmStream.BufferTuner normal = new PcmStream.BufferTuner(48000, 960, 3078, 96, false, true);
        int initial = normal.frames();
        if (initial != 1536) throw new AssertionError("Normal mixer needs a turn plus a source packet");
        if (normal.observeUnderruns(0) != initial) throw new AssertionError("Stable buffer grew");
        int recovered = normal.observeUnderruns(1);
        if (recovered <= initial || normal.observeUnderruns(1) != recovered) {
            throw new AssertionError("Only new underruns should grow the buffer");
        }
        for (int count = 2; count < 100; count++) normal.observeUnderruns(count);
        if (normal.frames() != 3078) throw new AssertionError("Buffer exceeded capacity");
        PcmStream.BufferTuner fast = new PcmStream.BufferTuner(48000, 960, 3078, 96, true, true);
        if (fast.frames() != 960) throw new AssertionError("FAST buffer unnecessarily enlarged");
        PcmStream.BufferTuner fixed = new PcmStream.BufferTuner(48000, 960, 3078, 96, false, false);
        if (fixed.frames() != 960 || fixed.observeUnderruns(100) != 960) {
            throw new AssertionError("Manual buffer changed while adaptation disabled");
        }
    }

    private interface Operation { void run() throws Exception; }

    private static void expectFailure(Operation operation) throws Exception {
        try {
            operation.run();
            throw new AssertionError("Expected IOException");
        } catch (IOException expected) {
            // Expected.
        }
    }
}
