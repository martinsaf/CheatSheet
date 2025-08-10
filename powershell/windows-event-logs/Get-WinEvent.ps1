# Get-WinEvent.ps1
# Useful Get-WinEvent Command Cheat Sheet
# Source: TryHackMe - Windows Event Logs (Task 4)
# Description: PowerShell cmdlet to get events from event logs and ETL files on local/remote computers.

# -------------------------------
# General Help
# -------------------------------
# Show help for the Get-WinEvent cmdlet
Get-Help Get-WinEvent -Full

# -------------------------------
# List Logs
# -------------------------------
# Get all logs from the computer (classic logs first, then new event logs)
Get-WinEvent -ListLog *


# -------------------------------
# List Providers
# -------------------------------
# Get event log providers and their associated logs
Get-WinEvent -ListProvider *

# -------------------------------
# Basic Filtering
# -------------------------------
# Filter events in Application log by provider name using Where-Object
Get-WinEvent -LogName Application | Where-Object { $_.ProviderName -Match 'WLMS' }

# -------------------------------
# Filtering with Hashtable
# -------------------------------
# Same result as above but using FilterHashtable (more efficient for large logs)
Get-WinEvent -FilterHashtable @{
  Logame='Application'
  ProviderName='WLMS'
}

# Filter Application logs for events from MsiInstaller
Get-WinEvent -FilterHashtable @{
  LogName='Application'
  ProviderName='MsiInstaller'
}

# Filter PowerShell/Operational log for events with ID 4104 containing 'SecureString'
Get-WinEvent -FilterHashtable @{
  LogName='Microsoft-Windows-PowerShell/Operational'
  ID=4104
} | Select-Object -Property Message | Select-String -Pattern 'SecureString'

# -------------------------------
# Search Providers
# -------------------------------
# Search for all event log providers with "PowerShell" in the name (suppress errors)
Get-WinEvent -ListProvider * 2>$null |
    Where-Object { $_.Name -match 'PowerShell' } |
    Select-Object -ExpandProperty Name
