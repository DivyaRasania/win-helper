@echo off

REM updates all softwares
winget upgrade -u -r -h --include-unknown --accept-package-agreements --force --disable-interactivity

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

