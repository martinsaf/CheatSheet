# BIND9 Troubleshooting Guide

## Common Issues and Solutions

### 1. BIND Service Management in Docker
```bash
# Start/stop BIND (Docker containers dont use systemd)
service bind9 start
service bind9 stop
service bind9 restart

# Check if BIND is running
ps aux | grep named
netstat -tuln | grep :53
```

### 2. Configuration Syntax Checking
```bash
# Check zone file syntax
named-checkzone cb /etc/bind/db.cb

# Check main configuration
named-checkconf
```

### 3. DNS Testing Commands
```bash
# Test DNS resolution
nslookup dns.cb 172.18.0.2
dig @172.18.0.2 dns.cb

# Test locally on DNS server
dig @127.0.0.1 dns.cb
```

## DNS Delegation Issues

### Symptoms: 
- nslookup works with specific server, but ping doesnt
- "unknown host" errors despite DNS resolution working

### Solutions:
- Verify both DNS server in `/etc/resolv.conf`
- Test with `nslookup hostname dns-server-ip`
- Check delegation with `dig +trace`
