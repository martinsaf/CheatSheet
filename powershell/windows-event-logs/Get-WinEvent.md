# Get-WinEvent - Command Cheat Sheet 🖥️

PowerShell cmdlet to retrieve events from event logs and ETL files on local/remote computers.

**Documentation:** [Microsoft Docs](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.diagnostics/get-winevent)

---

## General Help

| Task | Command |
| :--- | :--- |
| **Show full help** | `Get-Help Get-WinEvent -Full` |

---

## List Logs & Providers

| Task | Command |
| :--- | :--- |
| **List all logs** | `Get-WinEvent -ListLog *` |
| **List all providers** | `Get-WinEvent -ListProvider *` |
| **Find PowerShell providers** | `Get-WinEvent -ListProvider * 2>$null \| Where-Object { $_.Name -match 'PowerShell' }` |
| **Count provider events** | `(Get-WinEvent -ListProvider Microsoft-Windows-PowerShell).Events \| Measure-Object` |

---

## Basic Filtering

| Task | Command |
| :--- | :--- |
| **Filter by provider (Where-Object)** | `Get-WinEvent -LogName Application \| Where-Object { $_.ProviderName -Match 'WLMS' }` |
| **Filter by provider (Hashtable)** | `Get-WinEvent -FilterHashtable @{LogName='Application'; ProviderName='WLMS'}` |
| **Filter MsiInstaller events** | `Get-WinEvent -FilterHashtable @{LogName='Application'; ProviderName='MsiInstaller'}` |
| **Filter PowerShell ID 4104** | `Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-PowerShell/Operational'; ID=4104} \| Select-String 'SecureString'` |

---

## 💡 Tips

- **FilterHashtable** is more efficient than `Where-Object` for large logs
- Use `2>$null` to suppress errors when searching providers
- Combine with `Select-Object` to extract specific properties
