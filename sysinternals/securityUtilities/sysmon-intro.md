# Sysmon

System Montiro (Sysmon) is a Windows system service and device driver that logs system activity to the Windows event log.

It helps detect suspicious behavior such as process creation anomalies, network connections, registry changes, and more.

---

## 🧠 Purpose
Track process creation, network connections, and changes to file creation time to identify malicious or anomalous behavior.

---

## ⚙️ Install / Run
```bash
sysmon -accepteula -i sysmonconfig.xml
```
Or use without installation via Sysinternals Live:
```bash
\\live.sysinternals.com\tools\sysmon.exe
```
Unintstall:
```bash
sysmon -u
```

##📍Log Location
Event logs are stored in:
```bash
Applications and Services Logs → Microsoft → Windows → Sysmon → Operational
```

---

# Configuration Files
- Required for installation
- Controls which events to log and how
- Most use exclude rules to filter out noise
- Example
  - SwitftOnSecurity
  - ION-Storm fork

## Key Event IDs

| Event ID |            Purpose           |
|----------|------------------------------|
|    1     | Process creation             |
|----------|------------------------------|
|    3     | Network connections          |
|----------|------------------------------|
|    7     | Image loaded (DLL injection) |
|----------|------------------------------|
|    8     | CreateRemoteThread           |
|----------|------------------------------|
|    11    | CreateRemoteThread           |
|----------|------------------------------|
|    12    | File created                 |
|----------|------------------------------|
|  12-14   | Registry events              |
|----------|------------------------------|
|    15    | FileCreateStreamHash (ADS)   |
|----------|------------------------------|
|    22    | DNS queries                  |
|----------|------------------------------|


###Example Rules
- Event ID 1 - Process Creation
```bash
<RuleGroup name="" groupRelation="or">
	<ProcessCreate onmatch="exclude">
	 	<CommandLine condition="is">C:\Windows\system32\svchost.exe -k appmodel -p -s camsvc</CommandLine>
	</ProcessCreate>
</RuleGroup>
```

- Event ID 2 - Network Connection
```bash
<RuleGroup name="" groupRelation="or">
	<NetworkConnect onmatch="include">
	 	<Image condition="image">nmap.exe</Image>
	 	<DestinationPort name="Alert,Metasploit" condition="is">4444</DestinationPort>
	</NetworkConnect>
</RuleGroup>
```

- Event ID 7 - Image Loaded
```bash
<RuleGroup name="" groupRelation="or">
	<ImageLoad onmatch="include">
	 	<ImageLoaded condition="contains">\Temp\</ImageLoaded>
	</ImageLoad>
</RuleGroup>
```

- Event ID 8 - CreateRemoteThread
```bash
<RuleGroup name="" groupRelation="or">
	<CreateRemoteThread onmatch="include">
	 	<StartAddress name="Alert,Cobalt Strike" condition="end with">0B80</StartAddress>
	 	<SourceImage condition="contains">\</SourceImage>
	</CreateRemoteThread>
</RuleGroup>
```

- Event ID 11 - File Created
```bash
<RuleGroup name="" groupRelation="or">
	<FileCreate onmatch="include">
	 	<TargetFilename name="Alert,Ransomware" condition="contains">HELP_TO_SAVE_FILES</TargetFilename>
	</FileCreate>
</RuleGroup>
```

- Event ID 12 / 13 / 14 - Registry Event
```bash
<RuleGroup name="" groupRelation="or">
	<RegistryEvent onmatch="include">
	 	<TargetObject name="T1484" condition="contains">Windows\System\Scripts</TargetObject>
	</RegistryEvent>
</RuleGroup>
```

- Event ID 15 - FileCreateStreamHash
```bash
<RuleGroup name="" groupRelation="or">
	<FileCreateStreamHash onmatch="include">
	 	<TargetFilename condition="end with">.hta</TargetFilename>
	</FileCreateStreamHash>
</RuleGroup>
```

- Event ID 22 - DNS Event
```bash
<RuleGroup name="" groupRelation="or">
	<DnsQuery onmatch="exclude">
	 	<QueryName condition="end with">.microsoft.com</QueryName>
	</DnsQuery>
</RuleGroup>
```

## Notes
- Use exclude rules to reduce noise (default approach)
- Be flexible: each environment may require config tuning
- Avoid enabling all 29 Event IDs blindly - some are resource-heavy
- Always test your config before deployment

## References
- https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon
- https://github.com/SwiftOnSecurity/sysmon-config
- https://tryhackme.com/room/sysmon
