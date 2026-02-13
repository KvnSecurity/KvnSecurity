<#
.SYNOPSIS
    This PowerShell script ensures that Windows 11 STIG requirement to configure the Application event log maximum size to 32,768 KB (32 MB) or greater.

.NOTES
    Author          : Kavan Singh
    LinkedIn        : linkedin.com/in/kvnsecurity
    GitHub          : github.com/KvnSecurity/KvnSecurity
    Date Created    : 02-12-2026
    Last Modified   : 02-12-2026
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000050

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN11-AU-000500).ps1 

    # WN11-AU-000050
# Ensure Application Event Log maximum size is at least 32 MB (32768 KB)

$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
$ValueName    = "MaxSize"
$RequiredSize = 32768  # 32 MB in KB

# Ensure running elevated
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Error "This script must be run as Administrator."
    exit 1
}

# Create registry key if missing
if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Check current value
$current = (Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction SilentlyContinue).$ValueName

if ($current -lt $RequiredSize) {
    New-ItemProperty -Path $RegistryPath `
                     -Name $ValueName `
                     -Value $RequiredSize `
                     -PropertyType DWord `
                     -Force | Out-Null

    Write-Host "Updated Application log size to 32768 KB (32 MB) - STIG compliant."
}
else {
    Write-Host "Application log size already compliant ($current KB)."
}
