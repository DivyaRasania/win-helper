@echo off

REM creates a battery report on desktop
powercfg /batteryreport /output "%userprofile%\Desktop\battery-report.html"

REM opens battery report
%userprofile%\Desktop\battery-report.html

REM repair file or system image corruptions
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth

REM updates all softwares
winget upgrade --include-unknown --all --accept-package-agreements --accept-source-agreements --force --silent --disable-interactivity

REM opens disk cleaner
cleanmgr

REM deleting all temporary files
del /s /q "C:\Users\rasan\AppData\Local\Temp\*"
del /s /q "C:\Windows\Temp\*"
del /s /q "C:\Windows\Prefetch\*"
del %userprofile%\Desktop\battery-report.html

REM refreshing Wi-Fi
netsh winsock reset
ipconfig /release "Wi-Fi"
ipconfig /renew
ipconfig /flushdns

REM restarts the computer for fresh start
shutdown /r /t 30 /c "Your computer will restart in 30 seconds. Please save all your files in that time."
