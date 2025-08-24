# Symon-Commands.ps1
# Useful Sysmon Event Log Analysis Commands
# Source: TryHackMe - Sysmon Room

# --------------------------------#
# Sysmon Event IDs Quick Reference#
# --------------------------------#
# ID 1: Process Create
# ID 3: Network Connection
# ID 5: Process Terminated
# ID 7: Image Loaded
# ID 8: CreateRemoteThreat
# ID 9: RawAccessRead
# ID 10: ProcessAcess
# ID 11: FileCreate
# ID 12: RegistryEvent (Create/Delete)
# ID 13: RegistryEvent (Value Set)
# ID 14: RegistryEvent (Key Rename)
# ID 15: FileCreateStreamHash
# ID 17: PipeCreated
# ID 18: PipeConnected
# ID 19: WmiEvent (Consumption)
# ID 20: WmiEvent (Subscription)
# ID 21: WmiEvent (Filter)
# ID 22: DNSEvent

# -------------------------------
# Basic Sysmon Querying
# -------------------------------

# Get all Sysmon events
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational"

# Filter by specific Event ID (e.g., Process Create - ID 1)
Get-WinEvent -LogName "Micrsoft-Windows-Sysmon/Operational" | Where-Object { $_.Id -eq 1 }

# Filter by multiple Event IDs (e.g., Network and Process events)
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" | Where-Object { $_.Id -in @(1,3,5) }

# -------------------------------
# Advanced Filtering
# -------------------------------

# Find events with specific process name
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" | Where-Object { $_.Message -like "*powershell*" }

# Find network connections to specific IP
Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" | Where-Object { $_.Message -like "*172.30.1.253*" }

# -------------------------------
# File-based Analysis (for files .evtx)
# -------------------------------

# Analyze exported Sysmon EVTX file
Get-WinEvent -Path ".\Investigation-1.evtx" | Group-Object Id

# Filter process creation events from file
Get-WinEvent -Path ".\Investigation-1.evtx" | Where-Object { $_.Id -eq 1 } | Select-Object -First 5 -ExpandProperty Message

# Find suspicious registry modifications
Get-WinEvent -Path ".\Investigation-3.1evtx" | Where-Object { $_.Id -in @(12,13,14) } | Format-List Message
