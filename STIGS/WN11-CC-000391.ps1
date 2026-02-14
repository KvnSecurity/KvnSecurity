<#
.SYNOPSIS
    This PowerShell script ensures that Internet Explorer to be disabled for Windows 11.

.NOTES
    Author          : Kavan Singh
    LinkedIn        : linkedin.com/in/kvnsecurity
    GitHub          : github.com/KvnSecurity/KvnSecurity
    Date Created    : 02-12-2026
    Last Modified   : 02-12-2026
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000391


.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 
    
    # STIG: WN11-CC-000391
# Disable Internet Explorer 11 as a standalone browser

$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main"
$ValueName    = "DisableIE"
$ValueData    = 1   # 1 = Disable IE11 as standalone browser

# Ensure script is running elevated
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

# Set policy value
New-ItemProperty -Path $RegistryPath `
                 -Name $ValueName `
                 -Value $ValueData `
                 -PropertyType DWord `
                 -Force | Out-Null

Write-Host "IE11 has been disabled as a standalone browser per STIG WN11-CC-000391."
