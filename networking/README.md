# 🌐 Networking Labs & Practical Projects

Collection of hands-on networking labs covering DNS, web servers, and network services configuration.

## 📚 Labs Overview

### DNS Server Configuration
- **📁 Folder:** [`/dns/`](./dns/)
- **🎯 Objective:** Configure BIND9 DNS servers with domain delegation, subdomains, and zone transfers
- **🛠️ Technologies:** BIND9, Docker, Zone Files, DNS Hierarchy
- **📖 Documentation:** [DNS Lab Guide](./dns/bind9-lab.md)

### Apache Web Server  
- **📁 Folder:** [`/http/`](./http/) 
- **🎯 Objective:** Set up Apache HTTP server with virtual hosts, authentication, and DNS integration
- **🛠️ Technologies:** Apache2, Virtual Hosts, HTTP Authentication, DNS Integration
- **📖 Documentation:** [Apache Lab Guide](./http/http-server.md)

## 🏗️ Lab Architecture

### Common Docker Network

Network: 172.18.0.0/24
├── 🖥️ dns-primary (172.18.0.2) - Primary DNS + Web Server
├── 🌐 dns-subdomain (172.18.0.3) - Subdomain DNS
├── 🔄 dns-secondary (172.18.0.4) - Secondary DNS
└── 💻 client (172.18.0.5) - Testing client

### Domain Structure
- **Top-level domain:** `.cb` (DNS Lab)
- **Subdomain:** `danune.cb` (DNS Lab) 
- **Web domain:** `xpto.cb` (Apache Lab)

## 🛠️ Common Tools & Commands

### DNS Tools
```bash
dig @server domain.com
nslookup domain.com server
named-checkzone domain file.db
```

### Web Server Tools
```bash
curl -I http://domain.com
apache2ctl configtest
systemctl status apache2
```

### Docker Management
```bash
docker exec -it container bash
docker network create lab-network
docker-compose up -d
```

## 🐛 Troubleshooting

- **DNS Issues:** Check [DNS Troubleshooting Guide](./dns/troubleshooting.md)
- **Service Problems:** Verify logs in `/var/log/`
- **Network Connectivity:** Use `ping` and `traceroute`

## 📖 Learning Objectives

- ✅ Understand DNS hierarchy and zone delegation
- ✅ Configure authoritative and recursive DNS servers  
- ✅ Set up Apache virtual hosts and name-based hosting
- ✅ Implement HTTP basic authentication
- ✅ Manage services in containerized environments
- ✅ Troubleshoot network services effectively

## 🚀 Getting Started

1. Clone this repository
2. Navigate to specific lab folder
3. Follow the lab guide
4. Use Docker containers for practice environment

---

*Part of practical coursework for Internet Technologies - BSc Computer Engineering*

