# -------------------------------
# XPath Filtering
# -------------------------------
# Description: Filtering event logs using XPath queries.
# XPath (XML Path Language) allows selecting events based on XML element values in the event log structure.
# Microsoft XPath Reference: https://learn.microsoft.com/en-us/previous-versions/dotnet/netframework-4.0/ms256115(v=vs.100)
# Note: Both Get-WinEvent and wevtutil.exe support XPath filtering

# Filter events with EventID 100 in Application log
Get-WinEvent -LogName Application -FilterXPath '*/System/EventID=100'

# Filter events from provider WLMS
Get-WinEvent -LogName Application -FilterXPath '*/System/Provider[@Name="WLMS"]'

# Filter events from provider with EventID 101
Get-WinEvent -LogName Application -FilterXPath '*/System/EventID=101 and */System/Provider[@Name="WLMS"]'

# Filter Security events where TargetUserName equals "System"
Get-WinEvent -LogName Security -FilterXPath '*/EventData/Data[@Name="TargetUserName"]="System"' -MaxEvents 1

# Equivalent example using wevtutil.exe (EventID=100 from Application log)
wevtutil.exe qe Application /q:*/System[EventID=100] /f:text /c:1

# Filter events from provider WLMS at a specific timestamp
Get-WinEvent -LogName Application -FilterXPath '*/System/Provider[@Name="WLMS"] and */System/TimeCreated[@SystemTime="2020-12-15T01:09:08.940277500Z"]'
