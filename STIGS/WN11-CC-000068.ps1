<#
.SYNOPSIS
    This PowerShell script ensures that Windows 11 is configured to enable Remote host allows delegation of non-exportable credentials.

.NOTES
    Author          : Kavan Singh
    LinkedIn        : linkedin.com/in/kvnsecurity
    GitHub          : github.com/KvnSecurity/KvnSecurity
    Date Created    : 02-14-2026
    Last Modified   : 02-14-2026
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-CC-000068

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN11-AU-000500).ps1 
    
    # WN11-CC-000068
# Set IP source routing protection to Highest protection (2)

$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$ValueName    = "DisableIPSourceRouting"
$RequiredValue = 2  # Highest protection

# Ensure running elevated
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Error "This script must be run as Administrator."
    exit 1
}

# Create path if needed (should already exist on Windows)
if (-not (Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}

# Check current value
$current = (Get-ItemProperty -Path $RegistryPath `
            -Name $ValueName -ErrorAction SilentlyContinue).$ValueName

if ($current -ne $RequiredValue) {
    New-ItemProperty -Path $RegistryPath `
                     -Name $ValueName `
                     -Value $RequiredValue `
                     -PropertyType DWord `
                     -Force | Out-Null

    Write-Host "WN11-CC-000068 applied: IP source routing protection set to Highest (2)."
}
else {
    Write-Host "System already compliant with WN11-CC-000068."
}
