<#
.SYNOPSIS
    This PowerShell script ensures to Configure Windows Defender SmartScreen to block unrecognized apps and files from the Internet.

.NOTES
    Author          : Kavan Singh
    LinkedIn        : linkedin.com/in/kvnsecurity
    GitHub          : github.com/KvnSecurity/KvnSecurity
    Date Created    : 02-14-2026
    Last Modified   : 02-14-2026
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000315 

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN11-AU-000500).ps1 

# WN11-CC-000315
# Configure SmartScreen to Block (prevent bypass)

$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"

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

# Enable SmartScreen
New-ItemProperty -Path $RegistryPath `
                 -Name "EnableSmartScreen" `
                 -Value 1 `
                 -PropertyType DWord `
                 -Force | Out-Null

# Set SmartScreen level to Block
New-ItemProperty -Path $RegistryPath `
                 -Name "ShellSmartScreenLevel" `
                 -Value "Block" `
                 -PropertyType String `
                 -Force | Out-Null

Write-Host "WN11-CC-000315 applied: SmartScreen set to Block (prevent bypass)."
