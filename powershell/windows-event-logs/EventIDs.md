# Windows Event IDs - Quick Reference 🔍

Common Event IDs for security monitoring and threat hunting.

**Note:** Some events require enabling additional auditing (e.g., Process Creation, PowerShell Logging).

## 📚 Resources

| Resource | Link |
| :--- | :--- |
| Windows Logging Cheat Sheet | [PDF](https://static1.squarespace.com/static/552092d5e4b0661088167e5c/t/580595db9f745688bc7477f6/1476761074992/Windows+Logging+Cheat+Sheet_ver_Oct_2016.pdf) |
| NSA - Spotting the Adversary | [Archive](https://web.archive.org/web/20190115215749/https://apps.nsa.gov/iaarchive/customcf/openAttachment.cfm) |
| MITRE ATT&CK | [attack.mitre.org](https://attack.mitre.org/) |
| MS Server - Events to Monitor | [Microsoft Docs](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/plan/appendix-l--events-to-monitor) |

---

## Account Management

| Event ID | Description | Query |
| :---: | :--- | :--- |
| **4720** | User account created | `Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=4720'` |
| **4722** | User account enabled | `Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=4722'` |
| **4724** | Password reset attempt | `Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=4724'` |
| **4725** | User account disabled | `Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=4725'` |
| **4726** | User account deleted | `Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=4726'` |

---

## Process Creation

| Event ID | Description | Query |
| :---: | :--- | :--- |
| **4688** | New process created *(requires Audit Process Creation)* | `Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=4688'` |

---

## Service Installation

| Event ID | Description | Query |
| :---: | :--- | :--- |
| **7045** | Service installed *(System Log)* | `Get-WinEvent -LogName System -FilterXPath '*/System/EventID=7045'` |

---

## Firewall Changes

| Event ID | Description | Query |
| :---: | :--- | :--- |
| **2004** | Firewall rule added | `Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=2004'` |
| **2005** | Firewall rule modified | `Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=2005'` |
| **2006/2033** | Firewall rule deleted | `Get-WinEvent -LogName Security -FilterXPath '*/System/EventID=2006 or */System/EventID=2033'` |

---

## PowerShell Logging

| Event ID | Description | Log Name |
| :---: | :--- | :--- |
| **4103** | Module logging | `Microsoft-Windows-PowerShell/Operational` |
| **4104** | Script block logging | `Microsoft-Windows-PowerShell/Operational` |
