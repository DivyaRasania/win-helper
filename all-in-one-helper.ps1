# Script created by Divya Rasania
# This script performs various system maintenance tasks and restarts the computer.

$currentPid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$principal = new-object System.Security.Principal.WindowsPrincipal($currentPid)
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

if ($principal.IsInRole($adminRole))
{
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Admin)"
    clear-host
}
else
{
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;
    $newProcess.Verb = "runas";
    [System.Diagnostics.Process]::Start($newProcess);
    break
}

# Output battery report to desktop
Write-Host "========== Outputing battery report =========="
powercfg /batteryreport /output "$env:userprofile\Desktop\battery-report.html"

# Open battery report
Write-Host "========== Opening battery report =========="
Start-Process -FilePath "msedge" -ArgumentList "$env:userprofile\Desktop\battery-report.html"

# Repair file or system image corruptions
Write-Host "========== Starting system repairs =========="
runas /user:administrator /savecred sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth

# Update all softwares
Write-Host "========== Starting software updates =========="
winget upgrade --all

# Open Disk Cleanup
Write-Host "========== Starting Disk Cleanup =========="
Start-Process -FilePath "cleanmgr.exe"

# Delete temporary files and battery report
Write-Host "========== Removing temp files =========="
# Automatically retrieve path to user's temporary files
$tempPath = "$env:userprofile\AppData\Local\Temp"

# Delete user's temp files
Remove-Item -Path $tempPath -Force -Recurse -Quiet

# Delete other temporary directories
Remove-Item -Path "C:\Windows\Temp\*" -Force -Recurse -Quiet
Remove-Item -Path "C:\Windows\Prefetch\*" -Force -Recurse -Quiet

# Delete battery report
Remove-Item -Path "$env:userprofile\Desktop\battery-report.html" -Force -Recurse -Quiet

# Refresh network settings
Write-Host "========== Refreshing networks =========="
netsh winsock reset
ipconfig /release
ipconfig /renew
ipconfig /flushdns

# Restart computer with message
Write-Host "========== Restarting your PC... =========="
$restartMessage = "Your PC is about to restart in 30 seconds. Please save your work."
Restart-Computer -ComputerName . -Force -Message $restartMessage