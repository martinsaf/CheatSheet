# BIND9 DNS Server Lab

## Lab Overview
Practical DNS server configuration using BIND9 on Docker containers.

## Network Architecture
| Role | Hostname | IP Address |
|------|----------|------------|
| Primary DNS Server | dns-primary | 172.18.0.2 |
| Subdomain DNS Server | dns-subdomain | 172.18.0.5 |
| Secondary DNS Server | dns-secondary | 172.18.0.3 |
| Test Client | client | 172.18.0.4 |

## Exercises
1. Primary DNS Server Configuration (.cb domain)
2. Subdomain DNS Server Configuration (danune.cb)  
3. Secondary DNS Server Configuration
4. DNS Delegation and Zone Transfers

## Configuration Files
- [named.conf.local](bind9-configs/named.conf.local)
- [db.cb](bind9-configs/db.cb)
- [named.conf.options](bind9-configs/named.conf.options)

## Useful Commands
See [troubleshooting guide](troubleshooting.md) for common issues and solutions.
