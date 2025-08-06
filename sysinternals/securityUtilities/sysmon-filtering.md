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

# Pratical example (THM solution) in current folder file:
Get-winEvent -Path ".\Filtering_1610225088511.evtx" -FilterXPath '*[System[EventID=3]]' | Measure-Object | Select-Object -Expand Count
```

---

## 📚 References
- https://tryhackme.com/room/windowseventlogs
- https://tryhackme.com/room/sysmon






