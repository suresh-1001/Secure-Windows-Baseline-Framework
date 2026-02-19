<#
.SYNOPSIS
  Enforces a controlled Windows Update policy (Notify before download/install).

.DESCRIPTION
  Applies Windows Update AUOptions policy to require user/admin approval before downloading.
  Also disables auto-restart with logged on users and enables targeting business update channels.

.NOTES
  - Intended for Windows 10/11 Pro/Enterprise.
  - In managed environments, Intune/GPO may override these settings.
#>

$ErrorActionPreference = "Stop"

function Set-RegDword {
    param(
        [Parameter(Mandatory)][string]$Path,
        [Parameter(Mandatory)][string]$Name,
        [Parameter(Mandatory)][int]$Value
    )
    if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
    New-ItemProperty -Path $Path -Name $Name -Value $Value -PropertyType DWord -Force | Out-Null
}

Write-Host "== Windows Update policy baseline =="

$WU  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$AU  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"

# Create base keys
if (-not (Test-Path $WU)) { New-Item -Path $WU -Force | Out-Null }
if (-not (Test-Path $AU)) { New-Item -Path $AU -Force | Out-Null }

# AUOptions:
# 2 = Notify for download and notify for install
# 3 = Auto download and notify for install
# 4 = Auto download and schedule install
Set-RegDword -Path $AU -Name "AUOptions" -Value 2

# Do not automatically restart with logged on users
Set-RegDword -Path $AU -Name "NoAutoRebootWithLoggedOnUsers" -Value 1

# Enable detection frequency (optional; still requires approval since AUOptions=2)
Set-RegDword -Path $AU -Name "DetectionFrequencyEnabled" -Value 1
Set-RegDword -Path $AU -Name "DetectionFrequency" -Value 8   # hours

# Defer feature updates (example: 30 days) and quality updates (example: 7 days)
Set-RegDword -Path $WU -Name "DeferFeatureUpdates" -Value 1
Set-RegDword -Path $WU -Name "DeferFeatureUpdatesPeriodInDays" -Value 30
Set-RegDword -Path $WU -Name "DeferQualityUpdates" -Value 1
Set-RegDword -Path $WU -Name "DeferQualityUpdatesPeriodInDays" -Value 7

Write-Host "Windows Update policies applied successfully."
Write-Host "Recommended: run 'gpupdate /force' and reboot to ensure full policy application."

