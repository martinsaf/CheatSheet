# Sysmon - Event Log Analysis 📊

Useful commands for analyzing Sysmon event logs.

**Source:** TryHackMe - Sysmon Room

---

## Sysmon Event IDs Quick Reference

### Process Activity
| ID | Event |
| :---: | :--- |
| **1** | Process Create |
| **5** | Process Terminated |
| **7** | Image Loaded |
| **8** | CreateRemoteThread |
| **10** | ProcessAccess |

### Network & File
| ID | Event |
| :---: | :--- |
| **3** | Network Connection |
| **9** | RawAccessRead |
| **11** | File Create |
| **15** | File Create Stream Hash |
| **22** | DNS Event |

### Registry
| ID | Event |
| :---: | :--- |
| **12** | Registry Event (Create/Delete) |
| **13** | Registry Event (Value Set) |
| **14** | Registry Event (Key Rename) |

### Pipes & WMI
| ID | Event |
| :---: | :--- |
| **17** | Pipe Created |
| **18** | Pipe Connected |
| **19** | WMI Event (Consumption) |
| **20** | WMI Event (Subscription) |
| **21** | WMI Event (Filter) |

---

## Basic Sysmon Querying

| Task | Command |
| :--- | :--- |
| **Get all Sysmon events** | `Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational"` |
| **Filter by Event ID (e.g., ID 1)** | `Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" \| Where-Object { $_.Id -eq 1 }` |
| **Filter multiple Event IDs** | `Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" \| Where-Object { $_.Id -in @(1,3,5) }` |

---

## Advanced Filtering

| Task | Command |
| :--- | :--- |
| **Find specific process name** | `Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" \| Where-Object { $_.Message -like "*powershell*" }` |
| **Find network connection to IP** | `Get-WinEvent -LogName "Microsoft-Windows-Sysmon/Operational" \| Where-Object { $_.Message -like "*172.30.1.253*" }` |

---

## File-based Analysis (EVTX Files)

| Task | Command |
| :--- | :--- |
| **Analyze exported EVTX file** | `Get-WinEvent -Path ".\Investigation-1.evtx" \| Group-Object Id` |
| **Filter process creation (first 5)** | `Get-WinEvent -Path ".\Investigation-1.evtx" \| Where-Object { $_.Id -eq 1 } \| Select-Object -First 5 -ExpandProperty Message` |
| **Find registry modifications** | `Get-WinEvent -Path ".\Investigation-3.evtx" \| Where-Object { $_.Id -in @(12,13,14) } \| Format-List Message` |

---

## 💡 Tips

- Sysmon logs are stored in `Microsoft-Windows-Sysmon/Operational`
- Use `Group-Object Id` to get an overview of event distribution
- Event ID **1** (Process Create) and **3** (Network Connection) are most commonly analyzed
