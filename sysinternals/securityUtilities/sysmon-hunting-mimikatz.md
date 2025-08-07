# 🛡️ Sysmon - Hunting Mimikatz

Mimikatz is a widely known tool dumping credentials from memory, commonly used in Windows post-exploitation. While AV often detects it, attackers canuse obfuscation or droppers to bypass basic detections.

This guide covers techniques to hunt Mimikatz activity using **Sysmon** and **PowerShell**, focusing on:

- File creation with "mimikatz" in the name
- Abnormal access to `lsass.exe` (Process Access)

---

## 🔍 Hunting File Creation (Basic)

Although basic, checking for files with "mimikatz" in their names can catch overlooked droppers or bypasses.

### ▶ Sysmon Rule

```xml
<RuleGroup name="" groupRelation="or">
  <FileCreate onmatch="include">
    <TargetFileName condition="contains">mimikatz</TargetFileName>
  </FileCreate>
</RuleGroup>
```

⚠️ This method is not used in the provided logs but can be effective in real-world scenarios.

---

## 🔍 Hunting Abnormal LSASS Access (Recommended)
### 🧠 Why?
- Legitimate access to lsass.exe should only come from trusted processes like svchost.exe.
- Any other process accessing it is highly syspicious (e.g. Mimikatz, PPL bypass tools, credential dumpers).

## ⚙️ Sysmon Rule (Target: lsass.exe)
```xml
<RuleGroup name="" groupRelation="or">
  <ProcessAccess onmatch="include">
    <TargetImage condition="image">lsass.exe</TargetImage>
  </ProcessAccess>
</RuleGroup>
```
## 🔇 Reduce Noise: Exclude svchost.exe
```xml
<RuleGroup name="" groupRelation="or">
  <ProcessAccess onmatch="exclude">
    <SourceImage condition="image">svchost.exe</SourceImage>
  </ProcessAccess>
  <ProcessAccess onmatch="include">
    <TargetImage condition="image">lsass.exe</TargetImage>
  </ProcessAccess>
</RuleGroup>
```
This dual rule reduces noise from legitimate access and highlights only anomalies.

---

## 🖥️ Viewing Logs (Hunting_LSASS.evtx)
Open this log in **Event ViewerL**:
```plaintext
C:\Users\THM-Analyst\Desktop\Scenarios\Practice\Hunting_LSASS.evtx
```

---

## PowerShell Detection
We can filter for Event ID 10 (ProcessAccess) targeting LSASS.
### ▶ PowerShell command:
```powershell
Get-WinEvent -Path ".\Hunting_Mimikatz.evtx" `
  -FilterXPath '*/System/EventID=10 and */EventData/Data[@Name="TargetImage"] and */EventData/Data="C:\Windows\system32\lsass.exe"'
```
### ▶ Output:
```arduino
ProviderName: Microsoft-Windows-Sysmon

TimeCreated                     Id  Message
-----------                     --  -------
1/5/2021 3:22:52 AM             10  Process accessed:...
```

---

## 🔎 Investigation Tips
- Check SourceImage: Which is accessing `lsass.exe`?
- Is the accessing process signed? Trusted?
- Correlate with file creation or execution events (Event ID 1 or 11).
- Use this method across multiple logs to detect credential dumping attempts.

---

## 📚 References
https://attack.mitre.org/techniques/T1055/
https://attack.mitre.org/software/S0002/
https://tryhackme.com/room/sysmon
