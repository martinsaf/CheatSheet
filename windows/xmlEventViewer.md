1. Basic XML Filter Structure
```xml
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">
      *[System[(EventID=4624) and TimeCreated[timediff(@Systemtime) <= 3600000]]]
    </Select>
  </Query>
</QueryList>
```

2. Filter by EventID
```xml
<!-- Multiple EventIDs -->
*[System[(EventID=4624 or EventID=4625 or EventID=4634)]]

<!-- Range of EventIDs -->
*[System[(EventID >= 4624 and EventID <= 4634)]]
```

3. Filter by Time
```xml
<!-- Last 24 Hours -->
*[System[TimeCreated[timediff(@SystemTime) <= 86400000]]]

<!-- Specific Date -->
*[System[TimeCreated[@SystemTime >= '2024-01-01T00:00:00']]]
```

4. Filter by Level (Severity)
```xml
<!-- Only Errors and Critical -->
*[System[(Level=1 or Level=2)]]

<!-- Level 2=Critical, 3=Error -->
*[System[(Level=2)]]
```

5. Filter by Event Data
```xml
<!-- by username -->
*[EventData[Data[@Name='TargetUserName']='Administrator']]

<!-- by IP Address -->
*[EventData[Data[@Name='IpAddress']='192.168.1.100']]

<!-- Multiple conditions -->
*[System[(EentID=4624)] and EventData[Data[@Name='LogonType']='2']]
```

6. Pratical Example - Successful Logins
```xml
<QueryList>
  <Query Id="0" Path="Security">
    <Select Path="Security">
       *[System[(EventID=4624) and 
        (EventData[Data[@Name='LogonType']='2' or 
         Data[@Name='LogonType']='10']) and
        TimeCreated[timediff(@SystemTime) <= 3600000]]]
    </Select>
  </Query>
</QueryList>  
```

7. Using in PowerShell
```powershell
# Create XML filter
$xmlFilter = @"
<QueryList>
  <Query Id="0" Path="System">
    <Select Path="System">
      *[System[(Level=1 or Level=2) and TimeCreated[timediff(@SystemTime) <= 3600000]]]
    </Select>
  </Query>
</QueryList>
"@

# Execute query
Get-WinEvent -FilterXml $xmlFilter
```

8. Convert GUI Filter to XML
```powershell
# Save GUI filter as XML and read
$events = Get-WinEvent -FilterHashtable @{LogName='System'; Level=2} 
# Then use FilterXml for more complex queries.
```
