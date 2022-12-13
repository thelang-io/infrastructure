Set-StrictMode -Version latest
$ErrorActionPreference = 'Stop'
$InitialProgressPreference = $ProgressPreference

function Choco-Download ([string] $URL) {
  Set-ExecutionPolicy Bypass -Scope Process -Force
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
  (New-Object System.Net.WebClient).DownloadString($URL) | iex
}

function Get-SystemEnv ([string] $Name) {
  [Environment]::GetEnvironmentVariable($Name, [EnvironmentVariableTarget]::Machine)
}

function Refresh-Env () {
  $ChocoInstallPath = (Get-Command choco).Path
  $env:ChocolateyInstall = Convert-Path "$ChocoInstallPath/../.."
  Import-Module "$env:ChocolateyInstall/helpers/chocolateyProfile.psm1"
  refreshenv
}

function Set-SystemEnv ([string] $Name, [string] $Value) {
  [System.Environment]::SetEnvironmentVariable($Name, $Value, [System.EnvironmentVariableTarget]::Machine)
}

function ThePackages-Download ([string] $URL) {
  $ProgressPreference = 'SilentlyContinue'
  Invoke-WebRequest -URI $URL -OutFile C:/Users/Administrator/Desktop/packages.tar.gz
  $ProgressPreference = $InitialProgressPreference
  New-Item -ItemType Directory -Force -Path C:/Users/Administrator/Desktop/packages
  tar -xzf C:/Users/Administrator/Desktop/packages.tar.gz --directory C:/Users/Administrator/Desktop/packages --strip-components=2 the/windows

  Set-SystemEnv -Name PACKAGES_DIR -Value C:/Users/Administrator/Desktop/packages
}

function VisualStudio-Download ([string] $URL) {
  Invoke-WebRequest -URI $URL -OutFile C:/Users/Administrator/Desktop/vs_community.exe

  C:/Users/Administrator/Desktop/vs_community.exe `
    --add Microsoft.VisualStudio.Workload.NativeDesktop `
    --add Microsoft.VisualStudio.Component.VC.CMake.Project `
    --add Microsoft.VisualStudio.Component.Windows11SDK.22000 `
    --add Microsoft.VisualStudio.Component.VC.Llvm.Clang `
    --add Microsoft.VisualStudio.Component.VC.Llvm.ClangToolset `
    --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Llvm.Clang `
    --norestart --quiet --wait

  $Path = Get-SystemEnv -Name PATH
  $Path += ';C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.34.31933\bin\HostX64\\x64'
  $Path += ';C:\Program Files (x86)\Windows Kits\10\bin\10.0.22000.0\\x64'
  $Path += ';C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE'
  $Path += ';C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools'
  $Path += ';C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin'
  $Path += ';C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\Ninja'
  $Path += ';C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\Llvm\\x64\bin'

  Set-SystemEnv -Name PATH -Value $Path
}

function main () {
  VisualStudio-Download -URL https://aka.ms/vs/17/release/vs_community.exe
  Choco-Download -URL https://community.chocolatey.org/install.ps1
  choco install --no-progress -y git
  ThePackages-Download -URL https://cdn.thelang.io/packages.tar.gz
  Refresh-Env
  git clone --depth=1 https://github.com/thelang-io/the.git C:/Users/Administrator/Desktop/the
  cmake C:/Users/Administrator/Desktop/the -B C:/Users/Administrator/Desktop/the/build -G 'Visual Studio 17 2022' -D BUILD_TESTS=ON
  cmake --build C:/Users/Administrator/Desktop/the/build
}

main
