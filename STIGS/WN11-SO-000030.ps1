<#
.SYNOPSIS
    This PowerShell script ensures the system is configured to prevent the use of the LAN Manager (LM) hash for password storage.

.NOTES
    Author          : Kavan Singh
    LinkedIn        : linkedin.com/in/kvnsecurity
    GitHub          : github.com/KvnSecurity/KvnSecurity
    Date Created    : 02-14-2026
    Last Modified   : 02-14-2026
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-SO-000030

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 

# WN11-SO-000030
# Prevent storage of LAN Manager (LM) hash

$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$ValueName    = "NoLMHash"
$RequiredValue = 1  # 1 = Do not store LM hash (Enabled)

# Ensure running elevated
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Error "This script must be run as Administrator."
    exit 1
}

# Ensure registry path exists
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

    Write-Host "WN11-SO-000030 applied: LM hash storage disabled."
}
else {
    Write-Host "System already compliant with WN11-SO-000030."
}
