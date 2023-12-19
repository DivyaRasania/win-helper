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
$paths = @("$env:localappdata\Temp", "C:\Windows\Temp", "C:\Windows\Prefetch")
foreach ($path in $paths) {
    if (Test-Path $path) {
        Get-ChildItem -Path $path -Recurse | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    }
}

# Refresh network settings
Write-Host "========== Refreshing networks =========="
netsh winsock reset
ipconfig /release
ipconfig /renew
ipconfig /flushdns

# Restart computer with message
Write-Host "========== Restarting your PC... =========="
shutdown -r -t 30 -c "Your PC is about to restart in 30 seconds. Please save your work."
