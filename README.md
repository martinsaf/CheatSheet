# 📚 CheatSheet - Security & Networking Reference

A comprehensive collection of hands-on labs, command references, and practical guides for Security Operations, Threat Hunting, and Network Administration.

## 📋 About

Practical knowledge form the tranches: from DNS zone delegation to threat hunting with Sysmon. Each guide includes working examples, troubleshooting tips, and MITRE ATT&CK mapping where applicable.

## 🗺️ Repository Structure

```
CheatSheet/
│
├── 📁 hashcat/ # Password cracking
│ ├── commands.md # Hashcat commands
│ └── modes.md # Hash types reference
│
├── 📁 linux/ # Linux administration
│ ├── linux-basic.md # Essential commands
│ └── virtualization.md # VM Guest Additions
│
├── 📁 mitre-attack/ # MITRE ATT&CK framework
│ └── t1055-process-injection.md # Process injection techniques
│
├── 📁 networking/ # Network services
│ │ README.md # Networking labs overview
│ │ OSI-Model.md # OSI layers reference
│ │ protocols.md # Network protocols guide
│ │
│ ├── 📁 dns/ # DNS server labs
│ │ ├── bind9-lab.md # BIND9 configuration guide
│ │ ├── docker-setup.md # Docker environment setup
│ │ ├── troubleshooting.md # DNS issues & solutions
│ │ └── bind9-configs/ # Working config examples
│ │
│ ├── 📁 http/ # Apache web server
│ │ ├── http-server.md # Apache configuration lab
│ │ ├── troubleshooting.md # Web server issues
│ │ └── apache-configs/ # Virtual host configs
│ │
│ └── 📁 http-caching/ # HTTP caching mechanisms
│ ├── http-caching.md # Cache control lab
│ └── apache/ # Apache cache configs
│
├── 📁 powershell/ # PowerShell scripts
│ └── windows-event-logs/ # Event log analysis
│ ├── EventIDs.ps1 # Common event IDs
│ ├── Get-WinEvent.ps1 # Get-WinEvent cheatsheet
│ ├── Sysmon-Commands.ps1 # Sysmon analysis
│ ├── Wevtutil.ps1 # wevtutil commands
│ └── XPath-Filtering.ps1 # XML filtering
│
├── 📁 sysinternals/ # Sysinternals tools
│ ├── sysmon-intro.md # Sysmon overview
│ ├── sysmon-filtering.md # Advanced filtering
│ ├── sysmon-hunting-mimikatz.md # Hunting Mimikatz
│ └── sysmon-hunting-metasploit.md # Hunting Metasploit
│
├── 📁 tshark/ # TShark CLI analysis
│ ├── fundamentals.md # Basic commands
│ ├── captureFilters.md # Capture filters
│ └── displayFilters.md # Display filters
│
├── 📁 wireshark/ # Wireshark GUI
│ ├── capture_filters.md # BPF syntax
│ ├── display_filters.md # Filter expressions
│ └── examples.md # Practical examples
│
└── 📁 windows/ # Windows-specific
└── xmlEventViewer.md # XML filtering in Event Viewer
```

## Featured Labs & Guides

### 🔐 Security Analysis

- **[Sysmon Threat Hunting](sysinternals/)** - Complete guide to hunting malware with Sysmon
  - Mimikatz detection via LSASS access
  - Metasploit C2 traffic identification
  - Advanced filtering techniques

- **[Windows Event Logs](powershell/windows-event-logs/)** - Master Windows logging
  - PowerShell scripts for log analysis
  - XPath filtering examples
  - Common event ID reference

### 🌐 Network Services

- **[DNS Server Lab](networking/dns/bind9-lab.md)** - Build a complete DNS infrastructure
  - Primary, secondary, and subdomain servers
  - Zone delegation and transfers
  - Docker-based environment

- **[Apache Web Server](networking/http/http-server.md)** - Configure production-ready web servers
  - Virtual hosts with name-based routing
  - HTTP authentication (Basic Auth)
  - IPv6 configuration

- **[HTTP Caching](networking/http-caching/http-caching.md)** - Understand browser caching
  - Cache-Control headers
  - ETag and Last-Modified
  - Conditional requests

### 🛠️ Essential Tools

- **[Hashcat](hashcat/)** - Password cracking reference
- **[TShark/Wireshark](tshark/)** - Packet analysis cheatsheets
- **[Linux Administration](linux/)** - Essential commands and troubleshooting
