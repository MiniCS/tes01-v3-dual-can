@echo off
REM ============================================================
REM  FLASH_ESP32.bat  -  program the XIAO ESP32-S3 test firmware
REM  over USB-C. No Arduino IDE needed. Just the .bin next to this file.
REM
REM  Usage:  double-click, or:  FLASH_ESP32.bat COM7
REM ============================================================
setlocal EnableDelayedExpansion
cd /d "%~dp0"

set "BIN=TES01_V3_TESTER.bin"
if not exist "%BIN%" ( echo [ERROR] %BIN% not found next to this script. & goto :end )

REM --- locate esptool (standalone exe, or via Python) ---
set "ESPTOOL="
if exist "esptool.exe" set "ESPTOOL=esptool.exe"
if not defined ESPTOOL ( where esptool.exe >nul 2>nul && set "ESPTOOL=esptool.exe" )
if not defined ESPTOOL ( where esptool >nul 2>nul && set "ESPTOOL=esptool" )
if not defined ESPTOOL ( python -c "import esptool" >nul 2>nul && set "ESPTOOL=python -m esptool" )
if not defined ESPTOOL ( py -c "import esptool" >nul 2>nul && set "ESPTOOL=py -m esptool" )
if not defined ESPTOOL (
  echo [INFO] esptool not found on this PC.
  echo        EASIEST OPTION - no install: open Google Chrome or Edge and go to
  echo            https://espressif.github.io/esptool-js/
  echo        Connect, add file %BIN% at offset 0x0, click Program.
  echo.
  echo        Or install esptool once:   pip install esptool
  goto :end
)

REM --- COM port ---
set "PORT=%~1"
if "%PORT%"=="" (
  echo [INFO] No COM port given. Plug in the XIAO and pass its port, e.g.:
  echo            FLASH_ESP32.bat COM7
  echo.
  echo [INFO] Detected serial ports:
  %ESPTOOL% --help >nul 2>nul
  wmic path Win32_SerialPort get DeviceID,Name 2>nul
  goto :end
)

echo === Flashing %BIN% to %PORT% (ESP32-S3) ===
%ESPTOOL% --chip esp32s3 --port %PORT% --baud 921600 write_flash -z 0x0 "%BIN%"
if errorlevel 1 (
  echo.
  echo [ERROR] Flash failed. Put the board in download mode:
  echo         hold BOOT, tap RESET, release BOOT, then run again.
  goto :end
)
echo.
echo [OK] Done. The XIAO reboots and opens Wi-Fi AP 'TES01-V3-TEST'
echo      password 12345678  -  browse to  http://192.168.4.1
:end
echo.
pause
