param(
    [Parameter(Mandatory = $true)][string]$FlutterSdk,
    [Parameter(Mandatory = $true)][string]$MinGWRoot,
    [switch]$SkipAssets
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$clientRoot = Join-Path $projectRoot 'client'
$previewRoot = Join-Path $clientRoot 'build\preview'
$bundleRoot = Join-Path $previewRoot 'windows'
$flutter = Join-Path $FlutterSdk 'bin\flutter.bat'
$compiler = Join-Path $MinGWRoot 'bin\g++.exe'
$resources = Join-Path $MinGWRoot 'bin\windres.exe'
$previousPath = $env:Path
$env:Path = "$(Join-Path $MinGWRoot 'bin');$env:Path"

function Assert-Command([string]$operation) {
    if ($LASTEXITCODE -ne 0) { throw "$operation failed ($LASTEXITCODE)" }
}

Push-Location $projectRoot
try {
    New-Item -ItemType Directory -Force -Path $bundleRoot | Out-Null
    if (-not $SkipAssets) {
        Push-Location $clientRoot
        try {
            & $flutter pub get
            Assert-Command 'Flutter dependencies'
            & $flutter assemble --no-version-check '--output=build/preview-assets' `
                '-dTargetPlatform=windows-x64' '-dTrackWidgetCreation=false' `
                '-dBuildMode=release' '-dTargetFile=lib/main.dart' `
                '-dTreeShakeIcons=true' '-dDartObfuscation=false' `
                release_bundle_windows-x64_assets
            Assert-Command 'Flutter AOT build'
        } finally {
            Pop-Location
        }
    }

    $nativeRoot = 'client/windows/flutter/ephemeral'
    $wrapperRoot = "$nativeRoot/cpp_client_wrapper"
    $windowPlugin = "$nativeRoot/.plugin_symlinks/window_manager/windows"
    $screenPlugin = "$nativeRoot/.plugin_symlinks/screen_retriever_windows/windows"
    $version = [regex]::Match(
        (Get-Content -LiteralPath 'client/pubspec.yaml' -Raw),
        '(?m)^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)'
    )
    if (-not $version.Success) { throw 'Could not read the application version' }
    $versionFlags = @(
        "-DFLUTTER_VERSION_MAJOR=$($version.Groups[1].Value)",
        "-DFLUTTER_VERSION_MINOR=$($version.Groups[2].Value)",
        "-DFLUTTER_VERSION_PATCH=$($version.Groups[3].Value)",
        "-DFLUTTER_VERSION_BUILD=$($version.Groups[4].Value)"
    )
    & $resources -I client/windows/runner @versionFlags `
        tools/windows_preview.rc -o "$previewRoot/runner.res.o"
    Assert-Command 'Windows resources'

    $runnerSources = @(
        'client/windows/runner/main.cpp',
        'client/windows/runner/flutter_window.cpp',
        'client/windows/runner/utils.cpp',
        'client/windows/runner/win32_window.cpp',
        'client/windows/flutter/generated_plugin_registrant.cc',
        "$wrapperRoot/core_implementations.cc",
        "$wrapperRoot/flutter_engine.cc",
        "$wrapperRoot/flutter_view_controller.cc",
        "$wrapperRoot/plugin_registrar.cc",
        "$wrapperRoot/standard_codec.cc",
        "$windowPlugin/window_manager_plugin.cpp",
        "$screenPlugin/screen_retriever_windows_plugin.cpp",
        "$screenPlugin/screen_retriever_windows_plugin_c_api.cpp"
    )
    $includeFlags = @(
        '-Iclient/windows', '-Itools/windows_preview_include',
        "-I$nativeRoot", "-I$wrapperRoot/include",
        "-I$windowPlugin/include", "-I$screenPlugin/include"
    )
    # The plugin sources assume MSVC's transitive includes and permissive syntax.
    & $compiler -std=c++17 -O2 -fpermissive -municode -mwindows `
        -DUNICODE -D_UNICODE -DNOMINMAX -DFLUTTER_PLUGIN_IMPL `
        -include tools/windows_preview_include/compat.h @includeFlags @runnerSources `
        "$previewRoot/runner.res.o" "$nativeRoot/flutter_windows.dll" `
        -o "$previewRoot/audioshare-new.exe" -static `
        -ldwmapi -luser32 -lshcore -lgdi32 -lole32 -lshell32 -luuid `
        2> "$previewRoot/runner-build.log"
    Assert-Command 'Windows runner and plugins'

    & $compiler -std=c++17 -O2 -Wall -Wextra -Werror -Wconversion -shared `
        client/native/audio_capture.cpp -o "$previewRoot/audio_capture-new.dll" `
        -lole32 -lws2_32 -lavrt -lwinmm -luuid -static
    Assert-Command 'WASAPI capture library'

    Copy-Item -LiteralPath "$previewRoot/audioshare-new.exe" -Destination "$bundleRoot/audioshare.exe"
    Copy-Item -LiteralPath "$previewRoot/audio_capture-new.dll" -Destination "$bundleRoot/audio_capture.dll"
    Copy-Item -LiteralPath "$nativeRoot/flutter_windows.dll" -Destination $bundleRoot
    foreach ($asset in @('adb.exe', 'AdbWinApi.dll', 'AdbWinUsbApi.dll', 'server')) {
        Copy-Item -LiteralPath "client/assets/$asset" -Destination $bundleRoot
    }
    $dataRoot = Join-Path $bundleRoot 'data'
    New-Item -ItemType Directory -Force -Path $dataRoot | Out-Null
    Copy-Item -LiteralPath "$nativeRoot/icudtl.dat" -Destination $dataRoot
    Copy-Item -LiteralPath 'client/build/preview-assets/windows/app.so' -Destination $dataRoot
    # Mirror only generated assets within this dedicated preview directory.
    $assetTarget = [IO.Path]::GetFullPath((Join-Path $dataRoot 'flutter_assets'))
    $allowedPrefix = [IO.Path]::GetFullPath($previewRoot) + [IO.Path]::DirectorySeparatorChar
    if (-not $assetTarget.StartsWith($allowedPrefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'The preview asset destination must stay inside the preview workspace'
    }
    & robocopy 'client/build/preview-assets/flutter_assets' $assetTarget /MIR /NFL /NDL /NJH /NJS /NP
    if ($LASTEXITCODE -ge 8) { throw "Copying Flutter assets failed ($LASTEXITCODE)" }
    Write-Output "Preview: $bundleRoot\audioshare.exe"
} finally {
    $env:Path = $previousPath
    Pop-Location
}
