@echo off

REM repair file or system image corruptions
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth

REM updates all softwares
winget upgrade --silent --accept-package-agreements --accept-source-agreements --all --include-unknown --uninstall-previous --force --disable-interactivity

REM opens disk cleaner
cleanmgr

REM deleting all temporary files
del /s /q "C:\Users\rasan\AppData\Local\Temp\*"
del /s /q "C:\Windows\Temp\*"
del /s /q "C:\Windows\Prefetch\*"

REM refreshing Wi-Fi
netsh winsock reset
ipconfig /release
ipconfig /renew

REM restarts the computer for fresh start
shutdown /r /t 30 /c "Your computer will restart in 30 seconds. Please save all your files in that time."
