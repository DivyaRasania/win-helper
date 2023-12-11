@echo off

REM Script created by Divya Rasania
REM This script performs various system maintenance tasks and restarts the computer.

REM Check if already running as administrator
if "%username%"=="administrator" goto start

REM Elevate script with runas
runas /user:administrator /savecred %0

goto end

:start

REM Output battery report to desktop
echo "========== Outputing battery report =========="
powercfg /batteryreport /output "%userprofile%\Desktop\battery-report.html"

REM Open battery report
echo "========== Opening battery report =========="
start msedge "%userprofile%\Desktop\battery-report.html"

REM Repair file or system image corruptions
echo "========== Starting system repairs =========="
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth

REM Update all softwares
echo "========== Starting software updates =========="
winget upgrade --all

REM Open Disk Cleanup
echo "========== Starting Disk Cleanup =========="
cleanmgr

REM Delete temporary files and battery report
echo "========== Removing temp files =========="
del /s /q "%localappdata%\Temp\*"
del /s /q "C:\Windows\Temp\*"
del /s /q "C:\Windows\Prefetch\*"
del %userprofile%\Desktop\battery-report.html

REM Refresh network settings
echo "========== Refreshing networks =========="
netsh winsock reset
ipconfig /release
ipconfig /renew
ipconfig /flushdns

REM Restart computer with message
echo "========== Restarting your PC... =========="
shutdown -r -t 30 -c "Your PC is about to restart in 30 seconds. Please save your work."

:end
