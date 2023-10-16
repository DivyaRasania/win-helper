@echo off

REM created by Divya Rasania

REM creates a battery report on desktop
echo "==========Outputing battery report=========="
powercfg /batteryreport /output "%userprofile%\Desktop\battery-report.html"

REM opens battery report
echo "==========Opening battery report=========="
start msedge "%userprofile%\Desktop\battery-report.html"

REM repair file or system image corruptions
echo "==========Starting system repairs=========="
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth

REM updates all softwares
echo "==========Starting software updates=========="
winget upgrade --include-unknown --all --accept-package-agreements --accept-source-agreements --force --silent --disable-interactivity

REM opens disk cleaner
echo "==========Starting disk cleaner=========="
cleanmgr

REM deleting all temporary files & battery-report
echo "==========Removing temp files=========="
del /s /q "C:\Users\rasan\AppData\Local\Temp\*"
del /s /q "C:\Windows\Temp\*"
del /s /q "C:\Windows\Prefetch\*"
del %userprofile%\Desktop\battery-report.html

REM refreshing networks
echo "==========Refreshing networks=========="
netsh winsock reset
ipconfig /release
ipconfig /renew
ipconfig /flushdns

REM shutsdown the computer for fresh start
echo "==========Shutting down your pc=========="
SlideToShutdown
