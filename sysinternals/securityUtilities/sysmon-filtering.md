# Sysmon - Filtering and Threat Hunting
Advanced techniques to filter Sysmon logs and detect malicious activity.

---

## 🔍 Malicious Activity Detection
Focus areas when monitoring with Sysmon:
- Ransomware patterns
- Persistence mechanisms
- Mimikatz activity
- Metasploit artifacts
- C2 beaconing

---

## 🏆 Sysmon Best Practices

### Exclusion Over Inclusion
```bash
<!-- Example exclusion rule -->
<RuleGroup>
  <ProcessCreate onmatch="exclude">
    <Image condition="is">C:\Windows\explorer.exe</Image>
  </ProcessCreate>
</RuleGroup>
```

### CLI Power Features
```bash
# Filter network connections to port 4444
Get-WinEvent -Path Hunting_Metasploit.evtx - FilterXPath '*/System/EventID=3 and */EventData/Data=4444'
```

### Environment Awareness
- Baseline normal activity before creating rules
- Test configurations in staging environment

---

## 🛠️ Filtering Techniques

### Event Viewer
- Limited filtering capabilities
- Primary filters: EventID and keywords
- XML filtering available but cumbersome

### PowerShell (Recommended)
```bash
# Basic filter structure
Get-WinEvent -Path log.evtx -FilteringXPath '*/System/EventID=<ID>'

# THM questions and solutions:

# How many event ID 3 events are in C:\Users\THM-Analyst\Desktop\Scenarios\Practice\Filtering.evtx?
Get-winEvent -Path ".\Filtering_1610225088511.evtx" -FilterXPath '*[System[EventID=3]]' | Measure-Object | Select-Object -Expand Count

# What is the UTC time of the first network event in the same logfile? Note that UTC time is shown only in the "Details" tab.
Get-WinEvent -Path ".\Filtering_1610225088511.evtx" -FilterXPath "*[System[EventID=3]]" -MaxEvents 1 -Oldest |
Select-Object -Property *
```

---

## 📚 References
- https://tryhackme.com/room/windowseventlogs
- https://tryhackme.com/room/sysmon






