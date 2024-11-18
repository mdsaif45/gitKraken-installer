@echo off
setlocal enabledelayedexpansion

:: Check administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Please run this script as Administrator
    pause
    exit /b 1
)

:: Function to check if a tool is installed
:check_tool
where %1 >nul 2>&1
exit /b %errorlevel%

:: Download and Install GitKraken
echo Downloading GitKraken...
powershell -Command "Invoke-WebRequest https://release.gitkraken.com/windows64/GitKrakenSetup.exe -OutFile GitKrakenInstaller.exe"

echo Installing GitKraken...
start /wait GitKrakenInstaller.exe /SILENT
del GitKrakenInstaller.exe

:: Check and install Git
call :check_tool git
if %errorlevel% neq 0 (
    echo Git is not installed. Installing Git...
    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    refreshenv
    choco install git -y
)

:: Check and install Node.js
call :check_tool node
if %errorlevel% neq 0 (
    echo Node.js is not installed. Downloading and installing...
    powershell -Command "Invoke-WebRequest https://nodejs.org/dist/v23.2.0/node-v23.2.0-x64.msi -OutFile nodejs_installer.msi"
    start /wait msiexec /i nodejs_installer.msi /qn
    del nodejs_installer.msi
)

:: Check and install Yarn
call :check_tool yarn
if %errorlevel% neq 0 (
    echo Installing Yarn...
    call npm install -g yarn
)

:: Clone GitCracken repo with error handling
echo Cloning GitCracken repository...
if exist "GitCracken-crack-code" (
    rmdir /s /q "GitCracken-crack-code"
)
git clone https://github.com/zyclove/GitCracken-crack-code.git
if %errorlevel% neq 0 (
    echo Failed to clone repository. Check your internet connection.
    pause
    exit /b 1
)

cd GitCracken-crack-code

:: Install dependencies and build with comprehensive error checking
echo Installing dependencies...
call yarn install
if %errorlevel% neq 0 (
    echo Dependency installation failed.
    pause
    exit /b 1
)

call yarn build
if %errorlevel% neq 0 (
    echo Build process failed.
    pause
    exit /b 1
)

call yarn gitcracken patcher
if %errorlevel% equ 0 (
    :: Modify hosts file only if GitCracken patcher succeeds
    echo Adding GitKraken domain block to hosts file...
    findstr /C:"0.0.0.0 release.gitkraken.com" C:\Windows\System32\drivers\etc\hosts >nul 2>&1
    if %errorlevel% neq 0 (
        echo 0.0.0.0 release.gitkraken.com >> C:\Windows\System32\drivers\etc\hosts
    )

    echo.
    echo ========================================
    echo Development Tools Installation Successful!
    echo GitKraken Domain Blocked in Hosts File
    echo ========================================
) else (
    echo.
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    echo GitCracken Patcher Failed.
    echo Please check the log and ensure all prerequisites are met.
    echo !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    pause
    exit /b 1
)

pause