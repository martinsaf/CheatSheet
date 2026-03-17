# Wevtutil.exe - Command Cheat Sheet 🛠️

Command-line tool for managing Windows event logs.

**Documentation:** [Microsoft Docs](https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/wevtutil)

---

## General Help

| Task | Command |
| :--- | :--- |
| **Show general help** | `wevtutil.exe /?` |
| **Show query events help** | `wevtutil qe /?` |

---

## Logs Management

| Task | Command |
| :--- | :--- |
| **List all logs** | `wevtutil el` |
| **Get log configuration** | `wevtutil gl "Security"` |
| **Export log to EVTX** | `wevtutil epl Security "C:\Temp\Security.evtx"` |
| **Clear a log** | `wevtutil cl Security` |
| **Count all logs** | `wevtutil el \| Measure-Object` |

---

## Publishers Management

| Task | Command |
| :--- | :--- |
| **List all publishers** | `wevtutil ep` |
| **Get publisher details** | `wevtutil gp "Microsoft-Windows-PowerShell"` |

---

## Query Events

| Task | Command |
| :--- | :--- |
| **Last 10 Security events (text)** | `wevtutil qe Security /c:10 /f:text` |
| **Query from EVTX file** | `wevtutil qe /lf:true "C:\Path\To\YourLog.evtx"` |
| **Filter Level 2 (Error) events** | `wevtutil qe Security /q:"*[System[(Level=2)]]" /f:text` |
| **Last 3 Application events (reverse)** | `wevtutil qe Application /c:3 /rd:true /f:text` |

---

## 💡 Tips

- `/c:` = Count (number of events)
- `/f:text` = Output format (text, xml, renderxml)
- `/rd:true` = Reverse direction (newest first)
- `/q:` = XPath query filter
