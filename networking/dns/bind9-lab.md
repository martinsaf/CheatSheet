# BIND9 DNS Server Lab

## Lab Overview
Practical DNS server configuration using BIND9 on Docker containers.

## Network Architecture
| Role | Hostname | IP Address |
|------|----------|------------|
| Primary DNS Server | dns-primary | 172.18.0.2 |
| Subdomain DNS Server | dns-subdomain | 172.18.0.3 |
| Secondary DNS Server | dns-secondary | 172.18.0.4 |
| Test Client | client | 172.18.0.5 |

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

## Exercise 1 - Primary DNS Server Configuration

### ✅ 1a) Primary server for .cb domain
- Configured with required timeout in `db.cb`
- Refresh: 600s (10min), Retry: 60s (1min), Expire: 86400s (1 day), TTL: 20s

### ✅ 1b) A record for dns.cb
- `dns IN A 172.18.0.2` in zone file

### ✅ 1c) Client DNS Configuration
- Client configured to use 172.18.0.5 as nameserver

### ✅ 1d) DNS resolution test
- `ping dns.cb` successful

### 🔍 1e) Non-existent domain test
- `ping cliente.danune.cb` fails as expected (subdomain not configured yet)

## Exercise 2 - Subdomain DNS Server

### ✅ 2a) Subdomain delegation in primary server
- Added NS record for `danune.cb` in `db.cb`
- Added glue record `milk.danune.cb A 172.18.0.3`

### 🔄 2b) Subdomain server configuration
- Created zone file `db.danune.cb` with required timeouts
- Refresh: 300s (5min), Retry: 60s (1min), Expire: 86400s (1 day), TTL: 20s
