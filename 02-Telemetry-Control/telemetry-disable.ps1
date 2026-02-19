<#
.SYNOPSIS
  Applies a baseline set of Windows telemetry/privacy controls.

.DESCRIPTION
  Sets policy-based registry keys to reduce telemetry and "consumer experience" features.
  Designed for Windows 10/11. Requires Administrator privileges.

.NOTES
  - Some settings may require reboot/sign-out to fully apply.
  - In managed orgs, GPO/MDM may override local changes.
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

Write-Host "== Telemetry / Privacy baseline =="

# Telemetry level (0=Security, 1=Basic, 2=Enhanced, 3=Full). Many editions enforce minimum of 1.
Set-RegDword -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0

# Disable Windows Feedback notifications
Set-RegDword -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Value 1

# Disable Consumer Experience / content suggestions
Set-RegDword -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Value 1

# Disable tailored experiences (diagnostic data used for personalization)
Set-RegDword -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableTailoredExperiencesWithDiagnosticData" -Value 1

# Disable Advertising ID
Set-RegDword -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" -Name "DisabledByGroupPolicy" -Value 1

# Disable "Let apps access my advertising ID" (older path; harmless if not used)
Set-RegDword -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0

# Disable "Tips, tricks, and suggestions"
Set-RegDword -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableSoftLanding" -Value 1
Set-RegDword -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableThirdPartySuggestions" -Value 1

# Optional: Disable "Find my device"
Set-RegDword -Path "HKLM:\SOFTWARE\Policies\Microsoft\FindMyDevice" -Name "AllowFindMyDevice" -Value 0

Write-Host "Telemetry/privacy policies applied successfully."
Write-Host "Recommended: reboot or sign out/in for full effect."

