# AudioShare

Stream Windows and macOS system audio to Android over ADB.

[English](README.md) | [简体中文](docs/README.zh-CN.md)

AudioShare sends Windows or macOS system audio to an Android device through ADB. It works over USB and ADB over Wi-Fi, requires no extra hardware, and plays computer audio through the phone's speaker or headphones.

## Features

- Event-driven WASAPI capture on Windows, with output-loopback and recording-input device selection.
- ScreenCaptureKit system-audio capture on macOS 13 or later.
- USB and ADB over Wi-Fi connections through an ADB reverse tunnel.
- Automatic reconnection to the last used device.
- Bundled ADB and Android server, with no separate Android app to install.
- Uncompressed stereo PCM16 or Float32 transport. Windows retains the capture
  endpoint's mix sample rate; macOS captures at 48 kHz. System mixing, channel
  conversion and playback can still alter samples; this is not a bit-perfect guarantee.
- Low latency, balanced and stable buffer profiles, plus playback-buffer,
  startup-prefill, receive-block and capture-queue controls.
- Live channel meters and 60-second transfer/queue charts, with Android playback
  buffer, underrun, output-route and actual performance-mode feedback.
- Resizable desktop window with separate device, audio and monitor tabs.

Audio settings are saved and apply when connecting. Disconnect before changing
the capture source or buffer settings. Windows can capture physical or virtual
endpoints; no virtual audio driver is required. macOS currently captures system
audio through ScreenCaptureKit and does not expose recording-device selection.

The bounded capture queue drops old complete frames on overflow to keep playback
current; dropped frames are counted in Monitor. Queue estimates exclude ADB and
hardware/acoustic latency. The low-latency output option is a request; Monitor
shows the mode Android actually grants.

New audio controls are localized in English, Simplified Chinese and Traditional
Chinese. Other existing languages currently use English for these new strings.

## Quick Start

1. Download the package for your platform from [Releases](https://github.com/ysbing/AudioShare/releases) and extract it.
2. Enable USB debugging on the Android device, then connect it by USB or pair it with ADB over Wi-Fi.
3. Start AudioShare and select **Connect** when the device appears.

On first use on macOS, allow **Screen & System Audio Recording** when prompted. To grant it later, open **System Settings > Privacy & Security > Screen & System Audio Recording**, then quit and reopen AudioShare before reconnecting.

## Requirements

| Platform | Runtime requirements | Build requirements |
| --- | --- | --- |
| Windows | Windows 10/11 x64 and working ADB drivers | Flutter 3.x and Visual Studio 2022+ with the Desktop C++ workload |
| macOS | macOS 13+ | Flutter 3.x and Xcode 14+ |
| Android device | USB debugging enabled, or paired ADB over Wi-Fi | Android Studio or JDK, only when building the server |

Use the language menu in the upper-right corner to change the language of the interface. The first entry follows the language the operating system reports. The app ships translations for English, Simplified Chinese, Traditional Chinese, Spanish, Portuguese, Russian, Japanese, Korean, German, French, Italian, Hindi, Arabic, Turkish, Vietnamese, Indonesian, Polish, Thai, Dutch, Swedish, Czech, Hebrew, Ukrainian, Romanian, Greek, Hungarian, Danish and Finnish. Enable the option at the bottom of the window to reconnect automatically on future launches.

## Build from Source

```bash
cd client
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
```

Build the Windows client:

```powershell
cd client
flutter build windows --release
```

Output: `client/build/windows/x64/runner/Release/audioshare.exe`. AudioShare loads `adb.exe`, `AdbWinApi.dll`, `AdbWinUsbApi.dll`, `audio_capture.dll`, and the `server` asset from that directory at runtime, so the whole `Release` directory has to be shipped; a package that only contains `audioshare.exe` stays stuck on "Connecting".

Package the build output with `./tools/package_windows.ps1 [-Version <version>]`, which validates those files and writes `dist/audioshare-<version>-win.7z`:

```powershell
./tools/package_windows.ps1
```

Build the macOS client:

```bash
cd client
flutter build macos --release
```

Output: `client/build/macos/Build/Products/Release/AudioShare.app`

Package the build output with `./tools/package_macos.sh [--version <version>]`, which validates those files, ad-hoc signs the bundle, and writes `dist/audioshare-<version>-macos.zip`:

```bash
./tools/package_macos.sh
```

Build the Android server. The output is copied to `client/assets/server`:

```bash
./gradlew :server:assembleRelease
```

## Continuous Integration

[`.github/workflows/build.yml`](.github/workflows/build.yml) builds the Android server and both desktop clients on every push and pull request. Each run uploads `audioshare-<version>-win.7z` and `audioshare-<version>-macos.zip` as artifacts; pushing a `v*` tag also attaches both packages to the GitHub release.

The macOS job runs without an Apple Developer certificate and ad-hoc signs the bundle, so its packages are not notarized.

## Project Structure

```text
AudioShare/
├── client/                  Flutter desktop client
│   ├── lib/                 UI, device state, ADB, and FFI bindings
│   ├── native/              Windows and macOS audio-capture implementations
│   ├── assets/              Bundled ADB binaries and Android server
│   ├── windows/             Windows runner and CMake configuration
│   └── macos/               macOS runner and Xcode configuration
├── server/                  Android audio playback server
└── tools/                   Repository tooling and branding assets
```

## License

Licensed under [LGPL-3.0-or-later](LICENSE).
