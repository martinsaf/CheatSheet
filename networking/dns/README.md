# BIND9 DNS Server Configuration Lab

A practical guide to configuring DNS servers using BIND9 in a Docker environment.

## 📚 Contents

- [Lab Overview](bind9-lab.md)
- [Troubleshooting Guide](troubleshooting.md)
- [Docker Setup](docker-setup.md)
- [Configuration Files](bind9-configs/)

## 🎯 Learning Objectives

- Configure primary DNS servers
- Setup subdomain delegation
- Configure secondary DNS servers for redundancy
- Test DNS resolution and zone transfers

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/martinsaf/CheatSheet.git
cd CheatSheet/networking/dns

# Create Docker environment
bash scripts/create-lab.sh

# Follow exercise in bind9-lab.md
```

## 🔧 Prerequisites

- Docker installed
- Basic Linux command line knowledge
- Understanding of DNS concepts

## 📁 Project Structure

```text
bind9-configs/
├── primary-server/     # .cb domain configuration
├── subdomain-server/   # danune.cb configuration
└── secondary-server/   # Slave configuration
scripts/               # Automation scripts
```

## 📖 Exercises

1. Primary DNS Server Configuration
2. Subdomain DNS Server Configuration
3. Secondary DNS Server Configuration
4. DNS Delegation and Zone Transfers

## 🤝 Contributing

Feel free to submit issues and enhancement requests!
