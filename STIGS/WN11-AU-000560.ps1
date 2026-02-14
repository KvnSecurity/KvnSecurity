<#
.SYNOPSIS
    This PowerShell script ensures the Security event log is configured to retain events until the log is full (Do not overwrite events).

.NOTES
    Author          : Kavan Singh
    LinkedIn        : linkedin.com/in/kvnsecurity
    GitHub          : github.com/KvnSecurity/KvnSecurity
    Date Created    : 02-14-2026
    Last Modified   : 02-14-2026
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN11-AU-000560

.USAGE
    Put any usage instructions here.
    Example syntax:
    PS C:\> .\__remediation_template(STIG-ID-WN10-AU-000500).ps1 

    # WN11-AU-000560
# Configure Security log to Do Not Overwrite (Retention enabled)

# Ensure running elevated
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {

    Write-Error "This script must be run as Administrator."
    exit 1
}

# Set Security log retention to true (Do not overwrite)
wevtutil sl Security /rt:true

Write-Host "WN11-AU-000560 applied: Security log set to Do Not Overwrite (retention enabled)."
