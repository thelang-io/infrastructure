Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
(New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1') | iex
choco install -y git
refreshenv

iwr -URI https://aka.ms/vs/17/release/vs_community.exe -Out C:/Users/Administrator/Desktop/vs_community.exe
C:/Users/Administrator/Desktop/vs_community.exe --passive --wait `
  --add Microsoft.VisualStudio.Workload.NativeDesktop `
  --add Microsoft.VisualStudio.Component.VC.ASAN `
  --add Microsoft.VisualStudio.Component.VC.CMake.Project `
  --add Microsoft.VisualStudio.Component.VC.DiagnosticTools `
  --add Microsoft.VisualStudio.Component.VC.Tools.ARM64 `
  --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
  --add Microsoft.VisualStudio.Component.Windows11SDK.22000 `
  --add Microsoft.VisualStudio.Component.VC.CLI.Support `
  --add Microsoft.VisualStudio.Component.VC.Llvm.Clang `
  --add Microsoft.VisualStudio.Component.VC.Llvm.ClangToolset `
  --add Microsoft.VisualStudio.ComponentGroup.NativeDesktop.Llvm.Clang

git clone --depth=1 https://github.com/thelang-io/the.git C:/Users/Administrator/Desktop/the
iwr -URI https://cdn.thelang.io/packages.tar.gz -Out C:/Users/Administrator/Desktop/packages.tar.gz
mkdir C:/Users/Administrator/Desktop/packages
tar -xzf packages.tar.gz --directory C:/Users/Administrator/Desktop/packages --strip-components=2 the/windows

$path = [System.Environment]::GetEnvironmentVariable('PATH', [System.EnvironmentVariableTarget]::Machine)
$path += ';C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/MSVC/14.34.31933/bin/HostX64/x64'
$path += ';C:/Program Files (x86)/Windows Kits/10/bin/10.0.22000.0/x64'
$path += ';C:/Program Files/Microsoft Visual Studio/2022/Community/Common7/IDE'
$path += ';C:/Program Files/Microsoft Visual Studio/2022/Community/Common7/Tools'
$path += ';C:/Program Files/Microsoft Visual Studio/2022/Community/Common7/IDE/CommonExtensions/Microsoft/CMake/CMake/bin'
$path += ';C:/Program Files/Microsoft Visual Studio/2022/Community/Common7/IDE/CommonExtensions/Microsoft/CMake/Ninja'
$path += ';C:/Program Files/Microsoft Visual Studio/2022/Community/VC/Tools/Llvm/x64/bin'

[System.Environment]::SetEnvironmentVariable('PACKAGES_DIR', 'C:/Users/Administrator/Desktop/packages', [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('PATH', $path, [System.EnvironmentVariableTarget]::Machine)
