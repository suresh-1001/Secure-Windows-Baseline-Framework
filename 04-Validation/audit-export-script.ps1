<#
.SYNOPSIS
  Exports a baseline security/compliance snapshot for review.

.DESCRIPTION
  Collects common system info and exports it into a timestamped folder:
  - GPO Result report (HTML)
  - Local users
  - Local admin group membership
  - Firewall profile status
  - Installed hotfixes
  - Windows Update policy registry keys
  - Defender status (if available)

.NOTES
  Run as Administrator for best results.
#>

$ErrorActionPreference = "Stop"

$Base = Join-Path $env:SystemDrive "SecurityAudit"
$Stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$Out = Join-Path $Base $Stamp

New-Item -ItemType Directory -Force -Path $Out | Out-Null

Write-Host "Exporting audit snapshot to: $Out"

# System info
Get-ComputerInfo | Out-File (Join-Path $Out "computer-info.txt")

# Local users
Get-LocalUser | Select-Object Name, Enabled, LastLogon, PasswordRequired, PasswordExpires |
    Format-Table -AutoSize | Out-String | Out-File (Join-Path $Out "local-users.txt")

# Local Administrators group members
try {
    Get-LocalGroupMember -Group "Administrators" |
        Select-Object Name, ObjectClass, PrincipalSource |
        Format-Table -AutoSize | Out-String | Out-File (Join-Path $Out "local-admins.txt")
} catch {
    "Unable to query local Administrators group: $($_.Exception.Message)" | Out-File (Join-Path $Out "local-admins.txt")
}

# Firewall profiles
Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction |
    Format-Table -AutoSize | Out-String | Out-File (Join-Path $Out "firewall-profiles.txt")

# Installed hotfixes
Get-HotFix | Sort-Object InstalledOn -Descending |
    Select-Object HotFixID, InstalledOn, Description |
    Format-Table -AutoSize | Out-String | Out-File (Join-Path $Out "hotfixes.txt")

# Windows Update policy snapshot (registry)
$WUPaths = @(
  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate",
  "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
)

foreach ($p in $WUPaths) {
    $safe = ($p -replace "[:\\]", "_")
    if (Test-Path $p) {
        Get-ItemProperty -Path $p | Out-File (Join-Path $Out "$safe.txt")
    } else {
        "Path not found: $p" | Out-File (Join-Path $Out "$safe.txt")
    }
}

# Defender status (best effort)
try {
    $def = Get-MpComputerStatus
    $def | Format-List * | Out-File (Join-Path $Out "defender-status.txt")
} catch {
    "Defender status not available: $($_.Exception.Message)" | Out-File (Join-Path $Out "defender-status.txt")
}

# GPO Result report
try {
    gpresult /h (Join-Path $Out "gpo-report.html") /f | Out-Null
} catch {
    "gpresult failed: $($_.Exception.Message)" | Out-File (Join-Path $Out "gpo-report-error.txt")
}

Write-Host "Audit export complete."
Write-Host "Files saved under: $Out"

