# Wevtutil.ps1
# Useful wevtutil.exe Command Cheat Sheet
# Source: TryHackMe - Windows Event Logs (Task 3)
# Description: Command-line tool for managing Windows event logs.

# -------------------------------
# General Help
# -------------------------------
# Official Documentation: https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/wevtutil
# Show help
wevtutil.exe /?

# Show detailed help for the 'query events' command
wevtutil qe /?

# -------------------------------
# Logs Management
# -------------------------------

# List all available logs
wevtutil el

# Get configuration details for a specific log (e.g., Security)
wevtutil gl "Security"

# Export a log to an EVTX file (e.g., Security log to C:\Temp\Security.evtx)
wevtutil epl Security "C:\Temp\Security.evtx"

# Clear a specific log (e.g., Security)
wevtutil cl Security

# Count all event log names
wevtutil el | Measure-Object | Select-Object -ExpandProperty Count

# -------------------------------
# Publishers Management
# -------------------------------

# List all event publishers
wevtutil ep

# Get details for a specific publisher (e.g., PowerShell)
wevtutil gp "Microsoft-Windows-PowerShell"

# -------------------------------
# Query Events
# -------------------------------

# Query last 10 events form the Security log in text format
wevtutil qe Security /c:10 /f:text

# Query events from a log file (e.g., from an EVTX file)
wevtutil qe /lf:true "C:\Path\To\YourLog.evtx"

# Query Security log for only level 2 (error) events using XPath filter
wevtutil qe Security /q:"*[System[(Level=2)]]" /f:text

# Query last 3 events from Application log, reverse order, in text format
wevtutil qe Application /c:3 /rd:true /f:text

