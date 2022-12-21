function Get-SystemEnv ([string] $Name) {
  [Environment]::GetEnvironmentVariable($Name, [EnvironmentVariableTarget]::Machine)
}

function Set-SystemEnv ([string] $Name, [string] $Value) {
  [System.Environment]::SetEnvironmentVariable($Name, $Value, [System.EnvironmentVariableTarget]::Machine)
}

function VisualStudio-Download ([string] $URL) {
  $InstallerPath = "$HOME/vs_community.exe"
  $InstallerComponents = @(
    '--add Microsoft.VisualStudio.Workload.NativeDesktop',
    '--add Microsoft.VisualStudio.Component.VC.CMake.Project',
    '--add Microsoft.VisualStudio.Component.Windows11SDK.22000',
    '--add Microsoft.VisualStudio.Component.VC.Llvm.Clang',
    '--add Microsoft.VisualStudio.Component.VC.Llvm.ClangToolset',
    '--add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Llvm.Clang'
  )

  Invoke-WebRequest -URI $URL -OutFile $InstallerPath
  Start-Process -FilePath $InstallerPath -ArgumentList ($InstallerComponents -join ' '), '--quiet', '--wait' -Wait -PassThru

  $Path = Get-SystemEnv -Name PATH
  $Path += ';C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\MSVC\14.34.31933\bin\HostX64\x64'
  $Path += ';C:\Program Files (x86)\Windows Kits\10\bin\10.0.22000.0\x64'
  $Path += ';C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE'
  $Path += ';C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools'
  $Path += ';C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\CommonExtensions\Microsoft\CMake\CMake\bin'
  $Path += ';C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Tools\Llvm\x64\bin'

  Set-SystemEnv -Name PATH -Value $Path
  Remove-Item $InstallerPath
}

function NotepadPlusPlus-Download ([string] $URL) {
  $InstallerPath = "$HOME/npp-installer.exe"

  Invoke-WebRequest -URI $URL -OutFile $InstallerPath
  Start-Process -FilePath $InstallerPath -ArgumentList /S -Verb RunAs -Wait
  Remove-Item $InstallerPath
}

function Choco-Download ([string] $URL) {
  Set-ExecutionPolicy Bypass -Scope Process -Force
  [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
  (New-Object System.Net.WebClient).DownloadString($URL) | iex
}

function ThePackages-Download ([string] $URL) {
  $ArchivePath = "$HOME/packages.tar.gz"
  $InstallPath = "$HOME/Desktop/packages"

  Invoke-WebRequest -URI $URL -OutFile $ArchivePath
  New-Item -ItemType Directory -Force -Path $InstallPath
  tar -xzf $ArchivePath --directory $InstallPath --strip-components=3 the/native/windows
  Set-SystemEnv -Name PACKAGES_DIR -Value $InstallPath
  Remove-Item $ArchivePath
}

function Refresh-Env () {
  $ChocolateyPath = (Get-Command choco).Path
  $env:ChocolateyInstall = Convert-Path "$ChocolateyPath/../.."

  Import-Module "$env:ChocolateyInstall/helpers/chocolateyProfile.psm1"
  refreshenv
}

function TheSource-Download ([string] $URL) {
  $InstallPath = "$HOME/Desktop/the"
  $BuildPath = "$InstallPath/build"

  git clone --depth=1 $URL $InstallPath 2>&1
  cmake $InstallPath -B $BuildPath -G 'Visual Studio 17 2022' -D BUILD_TESTS=ON
  cmake --build $BuildPath
}

function main () {
  Write-Output "User data started at $(Get-Date)"

  try {
    VisualStudio-Download -URL https://aka.ms/vs/17/release/vs_community.exe
    NotepadPlusPlus-Download -URL https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.4.7/npp.8.4.7.Installer.x64.exe
    Choco-Download -URL https://community.chocolatey.org/install.ps1
    choco install --no-progress -y git
    ThePackages-Download -URL https://cdn.thelang.io/packages.tar.gz
    Refresh-Env
    TheSource-Download -URL https://github.com/thelang-io/the.git
  } catch {
    $ErrorMessage = $_.Exception.Message
    Write-Error "Error: $ErrorMessage"
  }

  Write-Output "User data finised at $(Get-Date)"
}

main
