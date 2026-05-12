# Author: Divya Rasania
# This script performs various system maintenance tasks and restarts the computer.

# Self elevation if the script isn't running as administrator
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

# Battery Report using powercfg
$Confirmation = Read-Host "Do you want to export battery report? (Y/n)"
if ($Confirmation -eq 'y' -or $Confirmation -eq "yes" -or $Confirmation -eq '') {
    if ((Get-Computerinfo).CsPCSystemType -eq "Mobile") {
        # Output battery report to desktop
        Write-Host "========== Outputing battery report =========="
        powercfg /batteryreport /output "$env:userprofile\Desktop\battery-report.html"
        Write-Host "Done!"

        # Open battery report
        Write-Host "========== Opening battery report =========="
        Start-Process -FilePath "$env:userprofile\Desktop\battery-report.html"

        $Confirmation = Read-Host "Do you want to delete the battery report? (Y/n)"
        if ($Confirmation -eq 'y' -or $Confirmation -eq "yes" -or $Confirmation -eq '') {
            Remove-Item "$env:userprofile\Desktop\battery-report.html" -Recurse -Force -ErrorAction SilentlyContinue
        } else {
            Write-Host "Battery report kept on Desktop."
        }
    } else {
        Write-Host "Only laptops have this feature."
    }
} else {
    Write-Host "Action skipped."
}

# Repair file or system image corruptions using sfc and DISM
$Confirmation = Read-Host "Do you want to run system image corruption fixes? (Y/n)"
if ($Confirmation -eq 'y' -or $Confirmation -eq "yes" -or $Confirmation -eq '') {
    Write-Host "========== Starting system repairs =========="
    sfc /scannow
    DISM /Online /Cleanup-Image /RestoreHealth
} else {
    Write-Host "Action skipped."
}

# Update all softwares using winget
$Confirmation = Read-Host "Do you want to update your apps? (Y/n)"
if ($Confirmation -eq 'y' -or $Confirmation -eq "yes" -or $Confirmation -eq '') {
    Write-Host "========== Starting software updates =========="
    winget upgrade --all --silent --accept-package-agreements --accept-source-agreements
} else {
    Write-Host "Action skipped."
}

# Delete temporary files and battery report
$Confirmation = Read-Host "Do you want to cleanup all temporary files? (Y/n)"
if ($Confirmation -eq 'y' -or $Confirmation -eq "yes" -or $Confirmation -eq '') {
    Write-Host "========== Removing temp files =========="
    Remove-Item "$env:localappdata\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "C:\Windows\Prefetch*\" -Recurse -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "Action skipped."
}

# Open Disk Cleanup
$Confirmation = Read-Host "Do you want to open disk cleanup for any additional cleaning? (Y/n)"
if ($Confirmation -eq 'y' -or $Confirmation -eq "yes" -or $Confirmation -eq '') {
    Write-Host "========== Starting Disk Cleanup =========="
    Start-Process -FilePath "cleanmgr.exe" -Wait
} else {
    Write-Host "Action skipped."
}

# Refresh network settings
$Confirmation = Read-Host "Do you want to refresh your networks? (Y/n)"
if ($Confirmation -eq 'y' -or $Confirmation -eq "yes" -or $Confirmation -eq '') {
    Write-Host "========== Refreshing networks =========="
    netsh winsock reset
    ipconfig /release
    ipconfig /renew
    ipconfig /flushdns
} else {
    Write-Host "Action skipped."
}

# Restaring PC
$Confirmation = Read-Host "Do you want to restart your PC? It is required to restart your computer if you ran network refreshes. (Y/n)"
if ($Confirmation -eq 'y' -or $Confirmation -eq "yes" -or $Confirmation -eq '') {
    Write-Host "========== Restarting your PC... =========="
    shutdown -r -t 60 -c "Your PC will restart in 1 minute. Please save your work."
} else {
    Write-Host "Action skipped."
}

Write-Host "Thank you for using this tool and have a nice day!"
