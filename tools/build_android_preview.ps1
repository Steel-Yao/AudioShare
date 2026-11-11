param(
    [Parameter(Mandatory = $true)][string]$JavaHome,
    [Parameter(Mandatory = $true)][string]$AndroidJar,
    [Parameter(Mandatory = $true)][string]$D8Jar
)

$ErrorActionPreference = 'Stop'
$projectRoot = Split-Path $PSScriptRoot -Parent
$buildRoot = Join-Path $projectRoot "client\build\android-preview\$([Guid]::NewGuid().ToString('N'))"
$classesRoot = Join-Path $buildRoot 'classes'
$dexRoot = Join-Path $buildRoot 'dex'
$bundle = Join-Path $buildRoot 'server'

function Assert-Command([string]$operation) {
    if ($LASTEXITCODE -ne 0) { throw "$operation failed ($LASTEXITCODE)" }
}

New-Item -ItemType Directory -Force -Path $classesRoot, $dexRoot | Out-Null
$sources = @(Get-ChildItem -LiteralPath (Join-Path $projectRoot 'server\src\main\java') `
    -Filter '*.java' -Recurse | ForEach-Object FullName)
& (Join-Path $JavaHome 'bin\javac.exe') -source 8 -target 8 -Xlint:-options `
    -classpath $AndroidJar -d $classesRoot @sources
Assert-Command 'Android Java compilation'
$classes = @(Get-ChildItem -LiteralPath $classesRoot -Filter '*.class' -Recurse |
    ForEach-Object FullName)
& (Join-Path $JavaHome 'bin\java.exe') -cp $D8Jar com.android.tools.r8.D8 `
    --release --lib $AndroidJar --min-api 23 --output $dexRoot @classes
Assert-Command 'Android DEX compilation'
& (Join-Path $JavaHome 'bin\jar.exe') --create --file $bundle -C $dexRoot classes.dex
Assert-Command 'Android DEX bundle'
Copy-Item -LiteralPath $bundle -Destination (Join-Path $projectRoot 'client\assets\server')
Write-Output "Bundle: $bundle"
