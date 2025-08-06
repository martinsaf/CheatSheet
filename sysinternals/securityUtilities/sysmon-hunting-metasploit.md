# 🕵️ Sysmon - Hunting Metasploit

Metasploit is a widely used exploit framework for penetration testing and red team operations. In this task, we focus on hunting the **Meterpreter shell** and its network activities using **Sysmon logs** and **PowerShell filtering**.

---

## 🎯 Objective

- Detect suspicious network activity (e.g. Meterpreter shell)
- Hunt based on **Sysmon Event ID 3** (network connections)
- Filter by destination ports (default Metasploit: 4444, 5555)

---

## ⚙️ Sysmon Rule Example (Port Filtering)
To detect network connections created by Metasploit, we use a rule that targets specific destination ports:

```xml
<RuleGroup name="" groupRelation="or">
  <NetworkConnect onmatch="include">
    <DestinationPort condition="is">4444</DestinationPort>
    <DestinationPort condition="is">5555</DestinationPort>
  </NetworkConnect>
</RuleGroup>
```

This rule will trigger Event ID 3 when outbound connections are made to ports commonly used by C2 frameworks.

## 🔍 PowerShell Hunting
We can use PowerShell and XPath filtering to detect matching events in .evtx logs.

## ▶ Basic command to filter port 4444:

```bash
Get-WinEvent -Path ".\Hunting_Metasploit.evtx" `
  -FilterXPath '*/System/EventID=3 and */EventData/Data[@Name="DestinationPort"] and */EventData/Data=4444'
```

## ▶ Explanation:
- EventID=3: Network connection
- Data[@Name="DestinationPort"]: Looks for port information
- Data=4444: Only match if destination port is 4444

## 🧪 Practical Use Case

This command filters logs for connections that may indicate a Meterpreter session:

```bash
Get-WinEvent -Path ".\Hunting_Metasploit.evtx" `
  -FilterXPath '*/System/EventID=3 and */EventData/Data[@Name="DestinationPort"] and */EventData/Data=4444' |
  Format-Table TimeCreated, Id, Message -Wrap
```
Result example:
```dif
TimeCreated         Id  Message
------------        --  -------
1/5/2021 2:21:32 AM  3  Network connection detected:...
```

## 📌 Tips
- Always validate if the detected IP is internal or external.
- Investigate the **Image** and **ProcessID** fields for the responsible process.
- Use this method to hunt other RATs or C2 frameworks by modifying the destination port.

## 📚 References
- https://tryhackme.com/room/sysmon
- https://tryhackme.com/room/windowseventlogs
