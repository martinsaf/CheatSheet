# XPath Filtering - Event Logs 🔎

Filter Windows event logs using XPath queries. Supported by both `Get-WinEvent` and `wevtutil.exe`.

**Documentation:** [Microsoft XPath Reference](https://learn.microsoft.com/en-us/previous-versions/dotnet/netframework-4.0/ms256115(v=vs.100))

---

## Basic Filters

| Task | Command |
| :--- | :--- |
| **Filter by EventID (100)** | `Get-WinEvent -LogName Application -FilterXPath '*/System/EventID=100'` |
| **Filter by Provider** | `Get-WinEvent -LogName Application -FilterXPath '*/System/Provider[@Name="WLMS"]'` |
| **Filter by Provider + EventID** | `Get-WinEvent -LogName Application -FilterXPath '*/System/EventID=101 and */System/Provider[@Name="WLMS"]'` |

---

## Security Log Filters

| Task | Command |
| :--- | :--- |
| **TargetUserName = "System"** | `Get-WinEvent -LogName Security -FilterXPath '*/EventData/Data[@Name="TargetUserName"]="System"' -MaxEvents 1` |
| **User Creation (4720) for "Sam"** | `Get-WinEvent -LogName Security -FilterXPath '*/EventData/Data[@Name="TargetUserName"]="Sam" and */System/EventID=4720'` |

---

## Advanced Filters

| Task | Command |
| :--- | :--- |
| **Filter by timestamp** | `Get-WinEvent -LogName Application -FilterXPath '*/System/Provider[@Name="WLMS"] and */System/TimeCreated[@SystemTime="2020-12-15T01:09:08.940277500Z"]'` |
| **wevtutil equivalent (EventID 100)** | `wevtutil.exe qe Application /q:*/System[EventID=100] /f:text /c:1` |

---

## 💡 Tips

- XPath is case-sensitive
- Use `and` / `or` for multiple conditions
- `@Name=` is used for attribute matching
- `*/System/` refers to the System element in the event XML
