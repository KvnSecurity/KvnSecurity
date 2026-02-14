<#
.SYNOPSIS
    This PowerShell script ensures to configure Microsoft Defender Antivirus to scan removable drives during a full scan.

.NOTES
    Author          : Kavan Singh
    LinkedIn        : linkedin.com/in/kvnsecurity
    GitHub          : github.com/KvnSecurity/KvnSecurity
    Date Created    : 02-14-2026
    Last Modified   : 02-14-2026
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-EP-000310


.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 

# WN11-EP-000310
# Ensure Defender scans removable drives during full scan

$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Scan"
$ValueName    = "DisableRemovableDriveScanning"
$RequiredValue = 0  # 0 = Enabled (scan removable drives)

# Ensure running elevated
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Error "This script must be run as Administrator."
    exit 1
}

# Create registry path if needed
if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set required value
New-ItemProperty -Path $RegistryPath `
                 -Name $ValueName `
                 -Value $RequiredValue `
                 -PropertyType DWord `
                 -Force | Out-Null

Write-Host "WN11-EP-000310 applied: Defender will scan removable drives during full scan."
