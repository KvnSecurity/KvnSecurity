<#
.SYNOPSIS
    This PowerShell script is to prevent users from changing installation options.

.NOTES
    Author          : Kavan Singh
    LinkedIn        : linkedin.com/in/kvnsecurity
    GitHub          : github.com/KvnSecurity/KvnSecurity
    Date Created    : 02-14-2026
    Last Modified   : 02-14-2026
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000280

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 

# WN11-CC-000280
# Prohibit User Installs via Windows Installer

$RegistryPath  = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
$ValueName     = "DisableUserInstalls"
$RequiredValue = 1  # 1 = Prohibit user installs

# Ensure running elevated
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Error "This script must be run as Administrator."
    exit 1
}

# Create registry path if it does not exist
if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Set required value
New-ItemProperty -Path $RegistryPath `
                 -Name $ValueName `
                 -Value $RequiredValue `
                 -PropertyType DWord `
                 -Force | Out-Null

Write-Host "WN11-CC-000280 applied: User installs are prohibited."
