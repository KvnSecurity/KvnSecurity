<#
.SYNOPSIS
    This PowerShell script disables the Windows Installer “Always install with elevated privileges” setting.

.NOTES
    Author          : Kavan Singh
    LinkedIn        : linkedin.com/in/kvnsecurity
    GitHub          : github.com/KvnSecurity/KvnSecurity
    Date Created    : 02-14-2026
    Last Modified   : 02-14-2026
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000290

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 

# WN11-CC-000290
# Ensure "Always install with elevated privileges" is Disabled

$MachinePath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
$UserPath    = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Installer"
$ValueName   = "AlwaysInstallElevated"
$RequiredValue = 0  # 0 = Disabled (STIG compliant)

# Ensure running elevated
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Error "This script must be run as Administrator."
    exit 1
}

# Function to enforce registry value
function Set-RegistryValue {
    param ($Path)

    if (-not (Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }

    New-ItemProperty -Path $Path `
                     -Name $ValueName `
                     -Value $RequiredValue `
                     -PropertyType DWord `
                     -Force | Out-Null
}

# Apply to machine and current user
Set-RegistryValue -Path $MachinePath
Set-RegistryValue -Path $UserPath

Write-Host "WN11-CC-000290 applied: AlwaysInstallElevated disabled at machine and user scope."
