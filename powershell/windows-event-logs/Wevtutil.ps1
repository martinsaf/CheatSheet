# Wevtutil.ps1
# Useful wevtutil.exe Command Cheat Sheet
# Source: TryHackMe - Windows Event Logs (Task 3)
# Description: Command-line tool for managing Windows event logs.

# Show general help
wevtutil.exe /?

# List all available logs
wevtutil el

# Get configuration for a specific log
wevtutil gl "Security"

# List all publishers
wevtutil ep

# Get details for a specific publisher
wevtutil gp "Microsoft-Windows-PowerShell"

# Query events from a log (e.g., last 10 Security events)
wevtutil qe Security /c:10 /f:text

# Export a log to an EVTX file
wevtutil epl Security "C:\Temp\Security.evtx"

# Clear a log (e.g., Security)
wevtutil cl

# Count all event log names
wevtutil el | Measure-Object | Select-Object -ExpandProperty Count
