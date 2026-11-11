# AudioShare

[English](../README.md) | [简体中文](README.zh-CN.md)

AudioShare 通过 ADB 将 Windows 或 macOS 的系统音频传输到 Android 设备。它支持 USB 和 ADB over Wi-Fi，无需额外硬件，可通过手机扬声器或耳机播放电脑声音。

## 功能

- Windows 使用事件驱动 WASAPI 采集，可选择系统输出回环或录音输入设备。
- macOS 使用 ScreenCaptureKit 捕获系统音频，需要 macOS 13 或更高版本。
- 使用 ADB reverse tunnel 传输，支持 USB 与 ADB over Wi-Fi。
- 可自动连接上一次使用的设备。
- 客户端内置 ADB 和 Android 服务端，无需单独安装手机应用。
- 支持未压缩双声道 PCM16 和 Float32 传输。Windows 使用采集端点的混音采样率，macOS 使用 48 kHz；系统混音、声道转换和播放仍可能改变采样，不保证端到端逐位一致。
- 提供低延迟、均衡和稳定缓冲档位，可手动调整播放缓冲、启动预填充、接收块和采集队列。
- 实时声道电平、最近 60 秒的速率与队列图表，以及 Android 实际缓冲、欠载、输出模式和播放设备反馈。
- 可缩放桌面窗口，分别提供设备、音频设置和实时监控页面。

音频设置会保存，在下次连接时生效；修改前需要断开连接。Windows 可以直接采集物理或虚拟端点，不需要额外安装虚拟声卡；macOS 当前只采集系统音频。

采集队列溢出时按完整帧丢弃旧音频，并在监控中累计计数。队列估计不包含 ADB、硬件输出和声学延迟；低延迟输出也只是请求，以 Android 实际返回的模式为准。

新增音频控件提供英文、简体中文和繁体中文，其他已有语言的新文案暂时使用英文。档位、指标含义、排障和本机验证见[音频设置与监控指南](audio-controls.zh-CN.md)。

## 快速开始

1. 从 [Releases](https://github.com/ysbing/AudioShare/releases) 下载对应平台的安装包或压缩包并解压。
2. 在 Android 设备上开启 USB 调试，再通过 USB 连接电脑，或完成 ADB over Wi-Fi 配对。
3. 启动 AudioShare；设备出现后点击“连接”。

macOS 首次使用时，请在系统提示中允许“屏幕与系统音频录制”。如需稍后授权，可前往“系统设置 > 隐私与安全性 > 屏幕与系统音频录制”，授权后退出并重新打开 AudioShare，再重新连接。

## 运行要求

| 平台 | 运行要求 | 构建要求 |
| --- | --- | --- |
| Windows | Windows 10/11 x64、可用的 ADB 驱动 | Flutter 3.x、Visual Studio 2022+（Desktop C++ 工作负载） |
| macOS | macOS 13+ | Flutter 3.x、Xcode 14+ |
| Android 设备 | Android 6.0+（API 23），已开启 USB 调试或已配置 ADB over Wi-Fi | Android SDK 和 JDK 21（仅构建服务端时需要） |

可使用右上角语言菜单切换界面语言。第一项"跟随系统"会使用操作系统所报告的语言。应用提供英语、简体中文、繁体中文、西班牙语、葡萄牙语、俄语、日语、韩语、德语、法语、意大利语、印地语、阿拉伯语、土耳其语、越南语、印尼语、波兰语、泰语、荷兰语、瑞典语、捷克语、希伯来语、乌克兰语、罗马尼亚语、希腊语、匈牙利语、丹麦语和芬兰语翻译。勾选窗口底部选项后，应用会在后续启动时自动连接上次使用的设备。

## 从源码构建

先从仓库根目录构建 Android 服务端，任务会把产物复制到 `client/assets/server`，再构建桌面客户端，保证客户端、原生库和 Android 协议匹配：

```bash
./gradlew :server:assembleRelease
```

Windows 使用 `.\gradlew.bat :server:assembleRelease`。CI 使用 Flutter 3.47.6、JDK 21 和 Android SDK platform 36。随后准备并检查 Flutter 客户端：

```bash
cd client
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
```

从仓库根目录构建 Windows 客户端：

```powershell
cd client
flutter build windows --release
```

产物：`client/build/windows/x64/runner/Release/audioshare.exe`。需要发布整个 `Release` 目录，包括 Flutter 引擎、`data`、`audio_capture.dll`、`adb.exe`、`AdbWinApi.dll`、`AdbWinUsbApi.dll` 和 `server`。缺失文件可能导致无法启动或连接。重新构建前先退出正在运行的应用。

回到仓库根目录，使用 `./tools/package_windows.ps1 [-Version <版本号>]` 打包，脚本会校验上述文件并生成 `dist/audioshare-<版本号>-win.7z`：

```powershell
./tools/package_windows.ps1
```

从仓库根目录构建 macOS 客户端：

```bash
cd client
flutter build macos --release
```

产物：`client/build/macos/Build/Products/Release/AudioShare.app`

回到仓库根目录，使用 `./tools/package_macos.sh [--version <版本号>]` 打包，脚本会校验运行所需文件、对应用进行 ad-hoc 签名，并生成 `dist/audioshare-<版本号>-macos.zip`：

```bash
./tools/package_macos.sh
```

MinGW 预览构建和可选的真机验证步骤见[本机预览指南](audio-controls.zh-CN.md#windows-本机预览)。

## 持续集成

[`.github/workflows/build.yml`](../.github/workflows/build.yml) 在推送到 `main`、推送 `v*` 标签、拉取请求和手动触发时运行。任务先构建 Android 服务端，运行 Java PCM、原生音频管线和 Flutter 检查，再构建两个桌面客户端。成功后上传 `audioshare-<版本号>-win.7z` 和 `audioshare-<版本号>-macos.zip`；`v*` 标签构建还会将两者附加到 GitHub Release。

macOS 任务没有 Apple 开发者证书，只对应用做 ad-hoc 签名，因此产物未经公证。

## 项目结构

```text
AudioShare/
├── client/                  Flutter 桌面客户端
│   ├── lib/                 界面、设备状态、ADB 与 FFI 绑定
│   ├── native/              Windows 与 macOS 音频捕获实现
│   ├── assets/              内置 ADB 二进制与 Android 服务端
│   ├── windows/             Windows runner 与 CMake 配置
│   └── macos/               macOS runner 与 Xcode 配置
├── server/                  Android 音频播放服务端
└── tools/                   仓库工具与品牌资源
```

## 许可证

本项目采用 [LGPL-3.0-or-later](../LICENSE) 许可证。
