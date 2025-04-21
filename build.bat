@echo off
setlocal enabledelayedexpansion

echo.
echo [32m[Welcome][0m to Greentea OS Builder!
echo.

cd /d %~dp0

:: --- Pre-checks ---
if not exist Greentea (
    echo [31m[Error][0m Missing "Greentea" folder. Please clone the repo or download it.
    goto somethingbad
)

if not exist Teapot (
    echo [31m[Error][0m Missing "Teapot" folder. Please clone the repo or download it.
    goto somethingbad
)

if not exist hexa.exe (
    echo [31m[Error][0m Missing "hexa.exe". Please download it from the official site.
    goto somethingbad
)

:: --- Build ---
echo [33m[Stage][0m Building HEXA configuration...
cmd /c hexa build\hexa.json
IF %ERRORLEVEL% NEQ 0 goto somethingbad

echo [33m[Stage][0m Building GreenTea OS via Node...
..\Teapot\node-v18.1.0-win-x64\node build.js init-or-clean asm efi dll engine ramdisk iso
IF %ERRORLEVEL% NEQ 0 goto somethingbad

:: --- Copy ISO Output ---
echo [33m[Stage][0m Moving final ISO to build/output...
mkdir build\output 2>nul
if exist greenteaos-uefi64.iso (
    move /Y greenteaos-uefi64.iso build\output\greenteaos-uefi64.iso >nul
    copy /Y build\output\greenteaos-uefi64.iso C:\Tea\greenteaos-uefi64.iso >nul 2>nul
    echo [32m[Success][0m ISO built and moved to build/output and C:\Tea
) else (
    echo [31m[Error][0m ISO file not found after build!
    goto somethingbad
)

:: Optional: Start VM or extra tools
:: VBoxManage storageattach etc...
:: tools\qemu-vfat.bat

goto done

:somethingbad
echo [37m[41m[Exiting on error][0m
exit /b 1

:done
set errorlevel=0
echo [32m[Build Complete][0m
exit /b 0
