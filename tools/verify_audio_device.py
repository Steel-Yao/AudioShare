"""Exercise the native capture ABI and Android playback with an attached device."""

import argparse
import ctypes
import faulthandler
import json
from pathlib import Path
import socket
import struct
import subprocess
import threading
import time


class Stats(ctypes.Structure):
    _fields_ = [
        *[(name, ctypes.c_uint64) for name in (
            "capturedFrames", "sentFrames", "sentBytes", "droppedFrames",
            "discontinuities", "packets")],
        *[(name, ctypes.c_uint32) for name in (
            "sampleRate", "channels", "bits", "queuedFrames", "capacityFrames",
            "running", "inputChannels", "inputBits")],
        *[(name, ctypes.c_float) for name in ("peakLeft", "peakRight", "rmsLeft", "rmsRight")],
        ("captureIntervalMs", ctypes.c_double), ("sendTimeMs", ctypes.c_double),
    ]


def verify_native(dll_path):
    native = ctypes.CDLL(str(Path(dll_path).resolve()))
    native.AudioCapture_Configure.argtypes = [ctypes.c_char_p, ctypes.c_int, ctypes.c_int, ctypes.c_int]
    native.AudioCapture_GetStats.argtypes = [ctypes.POINTER(Stats)]
    native.AudioCapture_GetDeviceName.restype = ctypes.c_char_p
    native.AudioCapture_GetDeviceId.restype = ctypes.c_char_p
    native.AudioCapture_GetLastErrorMessage.restype = ctypes.c_char_p
    assert native.AudioCapture_Initialize() == 1
    try:
        for source in (0, 1):
            count = native.AudioCapture_EnumerateDevices(source)
            print(json.dumps({"source": source, "devices": [
                {"name": native.AudioCapture_GetDeviceName(i).decode(),
                 "default": bool(native.AudioCapture_GetDeviceIsDefault(i))}
                for i in range(count)
            ]}, ensure_ascii=False))
        # Record silent/system samples for a short interval; never forward them.
        for bits in (16, 32):
            assert native.AudioCapture_Configure(b"", 0, 60, bits) == 1
            with socket.socket() as reserve:
                reserve.bind(("127.0.0.1", 0))
                port = reserve.getsockname()[1]
            assert native.AudioCapture_Listen(port, None) == 1
            with socket.create_connection(("127.0.0.1", port), timeout=30) as client:
                client.sendall(b"native-test\n")
                for _ in range(100):
                    if native.AudioCapture_IsConnected(None, 0):
                        break
                    time.sleep(0.01)
                assert native.AudioCapture_Start() == 1
                header = b""
                while len(header) < 8:
                    try:
                        received = client.recv(8 - len(header))
                    except TimeoutError:
                        print("Native timeout:", native.AudioCapture_GetLastErrorCode(),
                              native.AudioCapture_GetLastErrorMessage(), flush=True)
                        raise
                    if not received:
                        raise RuntimeError(native.AudioCapture_GetLastErrorMessage())
                    header += received
                rate, channels, actual_bits = struct.unpack("<IHH", header)
                assert rate >= 8000 and channels == 2 and actual_bits == bits
                client.sendall(b"READY\n")
                time.sleep(0.3)
                stats = Stats()
                native.AudioCapture_GetStats(ctypes.byref(stats))
                assert stats.running == 1, native.AudioCapture_GetLastErrorMessage()
                print(json.dumps({"nativeBits": bits, "rate": rate,
                    "capturedFrames": stats.capturedFrames, "packets": stats.packets,
                    "meanPacketMs": stats.capturedFrames * 1000 / rate / max(1, stats.packets),
                    "captureIntervalMs": stats.captureIntervalMs, "statsSize": ctypes.sizeof(stats)}))
            native.AudioCapture_Stop()
        # Missing endpoints must produce an actionable asynchronous error.
        assert native.AudioCapture_Configure(b"missing-device", 0, 60, 16) == 1
        with socket.socket() as reserve:
            reserve.bind(("127.0.0.1", 0))
            port = reserve.getsockname()[1]
        assert native.AudioCapture_Listen(port, None) == 1
        with socket.create_connection(("127.0.0.1", port), timeout=3) as client:
            client.sendall(b"error-test\n")
            time.sleep(0.05)
            assert native.AudioCapture_Start() == 1
            time.sleep(0.3)
            assert native.AudioCapture_GetLastErrorCode() == 1301
        native.AudioCapture_Stop()
        verify_shutdown(native)
    finally:
        native.AudioCapture_Cleanup()


def verify_shutdown(native):
    """Cancel accept, partial handshakes, READY waits and blocked sends."""
    timings = {}
    assert native.AudioCapture_Configure(b"", 0, 20, 16) == 1
    for mode, cycles in (("listener", 5), ("accept-race", 100),
                         ("partial-handshake", 5), ("ready-wait", 3),
                         ("blocked-send", 3)):
        durations = []
        for _ in range(cycles):
            with socket.socket() as reserve:
                reserve.bind(("127.0.0.1", 0))
                port = reserve.getsockname()[1]
            assert native.AudioCapture_Listen(port, None) == 1
            client = None
            try:
                if mode != "listener":
                    client = socket.create_connection(("127.0.0.1", port), timeout=15)
                    client.sendall(b"partial" if mode in ("accept-race", "partial-handshake")
                                   else b"shutdown-test\n")
                if mode == "partial-handshake":
                    time.sleep(0.02)
                if mode in ("ready-wait", "blocked-send"):
                    deadline = time.monotonic() + 2
                    while not native.AudioCapture_IsConnected(None, 0):
                        assert time.monotonic() < deadline, "Handshake did not finish"
                        time.sleep(0.005)
                    assert native.AudioCapture_Start() == 1
                    header = b""
                    while len(header) < 8:
                        chunk = client.recv(8 - len(header))
                        assert chunk, "Capture format missing"
                        header += chunk
                    if mode == "blocked-send":
                        client.sendall(b"READY\n")
                        time.sleep(0.4)
                started = time.perf_counter()
                native.AudioCapture_Stop()
                elapsed = time.perf_counter() - started
                durations.append(elapsed * 1000)
                assert elapsed < 1, f"{mode} stop took {elapsed:.3f}s"
                assert native.AudioCapture_IsConnected(None, 0) == 0
            finally:
                if client is not None:
                    client.close()
                native.AudioCapture_Stop()
        timings[mode] = {"cycles": cycles, "maxStopMs": round(max(durations), 2)}
    print(json.dumps({"shutdown": timings}), flush=True)


def verify_bridge(dll_path, adb_path, server_path, serial, *, duration, buffer_ms,
                  pre_roll_ms, read_chunk_ms, queue_ms, formats, keepalive=True):
    """Exercise the production WASAPI -> ADB -> AudioTrack path."""
    faulthandler.dump_traceback_later(45)
    native = ctypes.CDLL(str(Path(dll_path).resolve()))
    native.AudioCapture_Configure.argtypes = [ctypes.c_char_p, ctypes.c_int, ctypes.c_int, ctypes.c_int]
    native.AudioCapture_GetStats.argtypes = [ctypes.POINTER(Stats)]
    native.AudioCapture_GetLastErrorMessage.restype = ctypes.c_char_p
    prefix = [adb_path] + (["-s", serial] if serial else [])
    remote = "/data/local/tmp/audioshare_bridge_verify"
    # Keep the Windows mixer active without a test tone or volume changes.
    pcm = bytes(48000 * 2 * 2)
    wave = ctypes.create_string_buffer(
        b"RIFF" + struct.pack("<I", 36 + len(pcm)) + b"WAVEfmt "
        + struct.pack("<IHHIIHH", 16, 1, 2, 48000, 192000, 4, 16)
        + b"data" + struct.pack("<I", len(pcm)) + pcm)
    winmm = ctypes.WinDLL("winmm")
    winmm.PlaySoundW.argtypes = [ctypes.c_void_p, ctypes.c_void_p, ctypes.c_uint]
    assert native.AudioCapture_Initialize() == 1
    try:
        subprocess.run(prefix + ["push", server_path, remote], check=True, capture_output=True)
        if keepalive:
            assert winmm.PlaySoundW(wave, None, 0x0D), "Could not start silent Windows output"
        for bits in formats:
            assert native.AudioCapture_Configure(b"", 0, queue_ms, bits) == 1
            with socket.socket() as reserve:
                reserve.bind(("127.0.0.1", 0))
                port = reserve.getsockname()[1]
            assert native.AudioCapture_Listen(port, None) == 1
            name = f"audioshare_bridge_{port}"
            subprocess.run(prefix + ["reverse", f"localabstract:{name}", f"tcp:{port}"],
                           check=True, capture_output=True)
            process = subprocess.Popen(prefix + ["shell", "app_process",
                f"-Djava.class.path={remote}", "/data/local/tmp", "com.ysbing.audioshare.Main",
                f"socketName={name}", "connectCode=bridge", f"bufferMs={buffer_ms}",
                f"preRollMs={pre_roll_ms}", f"readChunkMs={read_chunk_ms}", "lowLatency=true"],
                stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, encoding="utf-8",
                errors="replace")
            reports, errors = [], []

            def read_reports():
                for line in process.stdout:
                    if line.startswith("AUDIO_STATS "):
                        capture = Stats()
                        native.AudioCapture_GetStats(ctypes.byref(capture))
                        reports.append((json.loads(line[12:]), capture))

            def read_errors():
                errors.extend(process.stderr)

            readers = [threading.Thread(target=read_reports, daemon=True),
                       threading.Thread(target=read_errors, daemon=True)]
            for reader in readers:
                reader.start()
            try:
                deadline = time.monotonic() + 5
                while not native.AudioCapture_IsConnected(None, 0):
                    if process.poll() is not None or time.monotonic() >= deadline:
                        raise RuntimeError("Native connection failed: " + "".join(errors))
                    time.sleep(0.01)
                assert native.AudioCapture_Start() == 1
                print(json.dumps({"bridgeStage": "started", "bits": bits}), flush=True)
                startup_started = time.monotonic()
                startup_deadline = startup_started + 30
                while not reports:
                    if native.AudioCapture_GetLastErrorCode():
                        raise RuntimeError(native.AudioCapture_GetLastErrorMessage().decode())
                    if process.poll() is not None or time.monotonic() >= startup_deadline:
                        raise RuntimeError("Playback startup failed: " + "".join(errors))
                    time.sleep(0.05)
                startup_seconds = time.monotonic() - startup_started
                faulthandler.dump_traceback_later(duration + 20)
                deadline = time.monotonic() + duration
                while time.monotonic() < deadline:
                    if native.AudioCapture_GetLastErrorCode():
                        raise RuntimeError(native.AudioCapture_GetLastErrorMessage().decode())
                    if process.poll() is not None:
                        raise RuntimeError("Android exited during playback: " + "".join(errors))
                    time.sleep(0.1)
                stop_started = time.perf_counter()
                native.AudioCapture_Stop()
                native_stop_ms = (time.perf_counter() - stop_started) * 1000
                print(json.dumps({"bridgeStage": "stopped", "bits": bits,
                                  "nativeStopMs": round(native_stop_ms, 2)}), flush=True)
                process.wait(timeout=8)
                shutdown_ms = (time.perf_counter() - stop_started) * 1000
                for reader in readers:
                    reader.join(2)
                assert process.returncode == 0, "".join(errors)
                assert len(reports) >= 2, "No playback telemetry; check the default Windows output"
                steady = [(s, c) for s, c in reports
                          if s["deviceTimeMs"] >= reports[0][0]["deviceTimeMs"] + 2000]
                assert steady, "Use a duration longer than the startup exclusion"
                tail = [(s, c) for s, c in steady
                        if s["deviceTimeMs"] >= steady[-1][0]["deviceTimeMs"] - 5000]
                rate = steady[-1][0]["sampleRate"]
                lead = [(c.capturedFrames - c.droppedFrames
                         - s.get("receiverDroppedFrames", 0) - s["playedFrames"])
                        * 1000 / rate for s, c in steady]
                print(json.dumps({
                    "bridgeBits": bits, "durationSeconds": duration, "reports": len(reports),
                    "startupSeconds": round(startup_seconds, 2),
                    "shutdownMs": round(shutdown_ms, 2),
                    "silentKeepalive": keepalive,
                    "steadyUnderruns": steady[-1][0]["underruns"] - steady[0][0]["underruns"],
                    "lastFiveSecondsUnderruns": tail[-1][0]["underruns"] - tail[0][0]["underruns"],
                    "steadyReceiverDroppedFrames": steady[-1][0].get("receiverDroppedFrames", 0)
                        - steady[0][0].get("receiverDroppedFrames", 0),
                    "steadyCaptureDroppedFrames": steady[-1][1].droppedFrames
                        - steady[0][1].droppedFrames,
                    "meanCaptureLeadMs": round(sum(lead) / len(lead), 2),
                    "meanTrackQueueMs": round(sum(s["queuedFrames"] for s, _ in steady)
                        * 1000 / rate / len(steady), 2),
                    "meanReceiverQueueMs": round(sum(s.get("receiverQueuedFrames", 0)
                        for s, _ in steady) * 1000 / rate / len(steady), 2),
                    "lastCapturedFrames": reports[-1][1].capturedFrames,
                    "lastSentFrames": reports[-1][1].sentFrames,
                    "last": reports[-1][0],
                }, ensure_ascii=False), flush=True)
                faulthandler.dump_traceback_later(duration + 20)
            finally:
                native.AudioCapture_Stop()
                if process.poll() is None:
                    process.kill()
                    process.wait()
                for reader in readers:
                    reader.join(2)
                subprocess.run(prefix + ["reverse", "--remove", f"localabstract:{name}"],
                               capture_output=True)
    finally:
        winmm.PlaySoundW(None, None, 0)
        native.AudioCapture_Cleanup()
        subprocess.run(prefix + ["shell", "rm", remote], capture_output=True)
        faulthandler.cancel_dump_traceback_later()


def verify_android(adb_path, server_path, serial, *, duration=8, buffer_ms=40,
                   pre_roll_ms=10, read_chunk_ms=5, packet_ms=10,
                   stall_ms=0, stall_every=2, formats=(16, 32), legacy_start=False):
    prefix = [adb_path] + (["-s", serial] if serial else [])
    remote = "/data/local/tmp/audioshare_pipeline_verify"
    subprocess.run(prefix + ["push", server_path, remote], check=True, capture_output=True)
    try:
        for bits in formats:
            with socket.socket() as listener:
                listener.bind(("127.0.0.1", 0))
                listener.listen(1)
                listener.settimeout(8)
                name = f"audioshare_verify_{listener.getsockname()[1]}"
                subprocess.run(prefix + ["reverse", f"localabstract:{name}",
                    f"tcp:{listener.getsockname()[1]}"], check=True, capture_output=True)
                process = subprocess.Popen(prefix + ["shell", "app_process",
                    f"-Djava.class.path={remote}", "/data/local/tmp", "com.ysbing.audioshare.Main",
                    f"socketName={name}", "connectCode=verify", f"bufferMs={buffer_ms}",
                    f"preRollMs={pre_roll_ms}", f"readChunkMs={read_chunk_ms}", "lowLatency=true"],
                    stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, encoding="utf-8",
                    errors="replace")
                output_lines, error_lines = [], []
                report_times = []
                def drain(stream, lines, arrivals=None):
                    for line in stream:
                        lines.append(line)
                        if arrivals is not None and line.startswith("AUDIO_STATS "):
                            arrivals.append(time.monotonic())
                readers = [
                    threading.Thread(target=drain, args=(process.stdout, output_lines, report_times), daemon=True),
                    threading.Thread(target=drain, args=(process.stderr, error_lines), daemon=True),
                ]
                for reader in readers:
                    reader.start()
                try:
                    client, _ = listener.accept()
                    with client:
                        client.settimeout(5)
                        code = b""
                        while not code.endswith(b"\n"):
                            received = client.recv(1)
                            if not received:
                                raise EOFError("Android closed before the handshake")
                            code += received
                        assert code == b"verify\n"
                        client.sendall(struct.pack("<IHH", 48000, 2, bits))
                        if not legacy_start:
                            ready = b""
                            while len(ready) < 6:
                                received = client.recv(6 - len(ready))
                                if not received:
                                    raise EOFError("Android closed before playback readiness")
                                ready += received
                            assert ready == b"READY\n", ready
                        # Silence avoids changing volume or playing test tones.
                        frames = max(1, 48000 * packet_ms // 1000)
                        block = bytes(frames * 2 * bits // 8)
                        started = time.monotonic()
                        next_stall = started + stall_every
                        sent_frames = 0
                        while sent_frames < duration * 48000:
                            deadline = started + sent_frames / 48000
                            remaining = deadline - time.monotonic()
                            if remaining > 0:
                                time.sleep(remaining)
                            if stall_ms and time.monotonic() >= next_stall:
                                time.sleep(stall_ms / 1000)
                                next_stall += stall_every
                            client.sendall(block)
                            sent_frames += frames
                    try:
                        process.wait(timeout=8)
                    except subprocess.TimeoutExpired as error:
                        process.kill()
                        process.wait()
                        for reader in readers:
                            reader.join(2)
                        raise RuntimeError(
                            "Android did not exit after EOF:\n"
                            + "".join(output_lines)[-4096:]
                            + "".join(error_lines)[-4096:]) from error
                    for reader in readers:
                        reader.join(2)
                    stdout, stderr = "".join(output_lines), "".join(error_lines)
                    stats = [json.loads(line[12:]) for line in stdout.splitlines()
                        if line.startswith("AUDIO_STATS ")]
                    assert process.returncode == 0, stderr
                    assert len(stats) >= 2, (stdout, stderr)
                    assert stats[-1]["playedFrames"] > 0
                    assert stats[-1]["bits"] == bits
                    steady = [s for s in stats if
                              s["deviceTimeMs"] >= stats[0]["deviceTimeMs"] + 2000] or stats
                    tail = [s for s in steady if
                            s["deviceTimeMs"] >= steady[-1]["deviceTimeMs"] - 5000]
                    def mean_ms(field):
                        samples = [s[field] * 1000 / s["sampleRate"] for s in steady if field in s]
                        return round(sum(samples) / len(samples), 2) if samples else None
                    # Dropped frames advance the source timeline without being played.
                    # Excluding them would misreport deliberate backlog removal as latency.
                    source_lead = [(arrived - started) * 1000
                                   - (s["playedFrames"] + s.get("receiverDroppedFrames", 0))
                                   * 1000 / 48000
                                   for s, arrived in zip(stats, report_times)
                                   if s["deviceTimeMs"] >= steady[0]["deviceTimeMs"]]
                    print(json.dumps({"androidBits": bits, "reports": len(stats),
                        "durationSeconds": duration, "packetMs": packet_ms, "stallMs": stall_ms,
                        "requestedBufferMs": buffer_ms,
                        "steadyUnderruns": steady[-1]["underruns"] - steady[0]["underruns"],
                        "lastFiveSecondsUnderruns": tail[-1]["underruns"] - tail[0]["underruns"],
                        "steadyReceiverDroppedFrames": (
                            steady[-1].get("receiverDroppedFrames", 0)
                            - steady[0].get("receiverDroppedFrames", 0)),
                        "meanSourceLeadMs": round(sum(source_lead) / len(source_lead), 2),
                        "meanTrackQueueMs": mean_ms("queuedFrames"),
                        "meanReceiverQueueMs": mean_ms("receiverQueuedFrames"),
                        "meanOutputPendingMs": mean_ms("outputPendingFrames"),
                        "last": stats[-1]}, ensure_ascii=False), flush=True)
                finally:
                    if process.poll() is None:
                        process.kill()
                        process.wait()
                    for reader in readers:
                        reader.join(2)
                    subprocess.run(prefix + ["reverse", "--remove", f"localabstract:{name}"],
                        capture_output=True)
    finally:
        subprocess.run(prefix + ["shell", "rm", remote], capture_output=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--native")
    parser.add_argument("--bridge", action="store_true",
                        help="Test the real Windows native capture path through Android")
    parser.add_argument("--no-keepalive", action="store_true",
                        help="Leave the Windows mixer idle during the bridge test")
    parser.add_argument("--adb")
    parser.add_argument("--server")
    parser.add_argument("--serial")
    parser.add_argument("--duration", type=float, default=8)
    parser.add_argument("--buffer-ms", type=int, default=40)
    parser.add_argument("--pre-roll-ms", type=int, default=10)
    parser.add_argument("--read-chunk-ms", type=int, default=5)
    parser.add_argument("--queue-ms", type=int, default=20)
    parser.add_argument("--packet-ms", type=int, default=10)
    parser.add_argument("--stall-ms", type=int, default=0)
    parser.add_argument("--stall-every", type=float, default=2)
    parser.add_argument("--bits", type=int, choices=[16, 32], nargs="+", default=[16, 32])
    parser.add_argument("--legacy-start", action="store_true",
                        help="Benchmark an older server that does not send READY")
    args = parser.parse_args()
    if args.duration <= 0 or args.packet_ms <= 0 or args.stall_every <= 0 or args.stall_ms < 0:
        parser.error("duration, packet-ms and stall-every must be positive; stall-ms must be nonnegative")
    if args.bridge:
        if not (args.native and args.adb and args.server):
            parser.error("--bridge requires --native, --adb and --server")
        if args.duration <= 3 or args.legacy_start:
            parser.error("--bridge requires duration > 3 and a server with READY")
        verify_bridge(args.native, args.adb, args.server, args.serial, duration=args.duration,
                      buffer_ms=args.buffer_ms, pre_roll_ms=args.pre_roll_ms,
                      read_chunk_ms=args.read_chunk_ms, queue_ms=args.queue_ms, formats=args.bits,
                      keepalive=not args.no_keepalive)
    elif args.native:
        verify_native(args.native)
    if not args.bridge and args.adb and args.server:
        verify_android(args.adb, args.server, args.serial, duration=args.duration,
                       buffer_ms=args.buffer_ms, pre_roll_ms=args.pre_roll_ms,
                       read_chunk_ms=args.read_chunk_ms, packet_ms=args.packet_ms,
                       stall_ms=args.stall_ms, stall_every=args.stall_every,
                       formats=args.bits, legacy_start=args.legacy_start)
