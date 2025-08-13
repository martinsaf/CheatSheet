# -------------------------------
# Windows Event IDs - Quick Reference
# -------------------------------
# Description: Common Event IDs for monitoring & hunting
# Note: Some events require enabling additional auditing (e.g., Process Creation, PowerShell Logging)
# Few resources to help in this task:
# Windows Logging Cheat Sheet (Win 7 thru Win 2012): https://static1.squarespace.com/static/552092d5e4b0661088167e5c/t/580595db9f745688bc7477f6/1476761074992/Windows+Logging+Cheat+Sheet_ver_Oct_2016.pdf
# NSA - Spotting the Adversary with Windows Event Log Monitoring: https://web.archive.org/web/20190115215749/https://apps.nsa.gov/iaarchive/customcf/openAttachment.cfm?FilePath=/iad/library/ia-guidance/security-configuration/applications/assets/public/upload/Spotting-the-Adversary-with-Windows-Event-Log-Monitoring.pdf&WpKes=aF6woL7fQp3dJiqyJL2LenrLxuHC7ztGtVNK3x
# Where can we get a list of event IDs to monitor/hunt for? https://attack.mitre.org/
# MS Server - Appendix L: Events to monitor: https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/plan/appendix-l--events-to-monitor
# PowerShell - about_Logging_Windows: https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_logging_windows?view=powershell-7.5&viewFallbackFrom=powershell-7.1
# Threat Intelligence - Greater Visibility Through PowerShell Logging: https://cloud.google.com/blog/topics/threat-intelligence/greater-visibility/
# Configure PowerShell logging to see PowerShell anomalies in Splunk UBA: https://docs.splunk.com/Documentation/UBA/5.0.4/GetDataIn/AddPowerShell
# Command line process auditing: https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/manage/component-updates/command-line-process-auditing#try-this-explore-command-line-process-auditing
# -------------------------------
# Account Management
# -------------------------------

# 4720 - User account created
Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=4720'

# 4722 - User account enabled
Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=4722'

# 4724 - Attempt to reset an account's password
Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=4724'

# 4725 - User account disabled
Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=4725'

# 4726 - User account deleted
Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=4726'

# -------------------------------
# Process Creation
# -------------------------------

# 4688 - New process created (requires Audit Process Creation enabled)
Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=4688'

# -------------------------------
# Service Installation
# -------------------------------

# 7045 - A service was installed in the system (System Log)
Get-WinEvent -LogName System -FilterXPath '*/System/EventID=7045'

# -------------------------------
# Firewall Changes
# -------------------------------

# 2004 - Windows Firewall rule added
Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=2004'

# 2005 - Windows Firewall rule modified
Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=2005'

# 2006 / 2033 - Windows Firewall rule deleted
Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=2006 or */System/EventID=2033'

# -------------------------------
# PowerShell Logging
# -------------------------------

# 4103 - Module logging
Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" -FilterXPath '*/System/EventID=4103'

# 4104 - Script block logging
Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" -FilterXPath '*/System/EventID=4104'
