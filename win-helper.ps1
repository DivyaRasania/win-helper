# Script created by Divya Rasania
# This script performs various system maintenance tasks and restarts the computer.

$currentPid = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$principal = new-object System.Security.Principal.WindowsPrincipal($currentPid)
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator

if ($principal.IsInRole($adminRole)) {
    $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Admin)"
    clear-host
} else {
    $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
    $newProcess.Arguments = $myInvocation.MyCommand.Definition;
    $newProcess.Verb = "runas";
    [System.Diagnostics.Process]::Start($newProcess);
    break
}

if ((Get-Computerinfo).CsPCSystemType -eq "Mobile") {
    # Output battery report to desktop
    Write-Host "========== Outputing battery report =========="
    powercfg /batteryreport /output "$env:userprofile\Desktop\battery-report.html"

    # Open battery report
    Write-Host "========== Opening battery report =========="
    Start-Process -FilePath "$env:userprofile\Desktop\battery-report.html"
}

# Repair file or system image corruptions
Write-Host "========== Starting system repairs =========="
sfc /scannow
DISM /Online /Cleanup-Image /RestoreHealth

# Update all softwares
Write-Host "========== Starting software updates =========="
winget upgrade --all --include-unknown

# Open Disk Cleanup
Write-Host "========== Starting Disk Cleanup =========="
Start-Process -FilePath "cleanmgr.exe" -Wait

# Delete temporary files and battery report
Write-Host "========== Removing temp files =========="
try {
    Remove-Item -Force -Recurse -Confirm:$false "$env:localappdata\Temp"
    Remove-Item -Force -Recurse -Confirm:$false "C:\Windows\Temp"
    Remove-Item -Force -Recurse -Confirm:$false "C:\Windows\Prefetch"
    Remove-Item "$env:userprofile\Desktop\battery-report.html"
} catch {
    Write-Host "Some files and folders are left untouched as those cannot be deleted"
}

# Refresh network settings
Write-Host "========== Refreshing networks =========="
netsh winsock reset
ipconfig /release
ipconfig /renew
ipconfig /flushdns

# Message to restart the computer
Write-Host "========== Restarting your PC... =========="
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show("Please restart your computer to apply changes.", "Restart Required", "OK", "Information")
# shutdown -r -t 60 -c "Your PC is about to restart in 1 minute. Please save your work."
