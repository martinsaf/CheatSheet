# Docker Setup for BIND9 Lab

## 1. Create Docker Network

```bash
docker network create --subnet=172.18.0.0/16 dns-lab
```

## 2. Create Containers

```bash
docker run -d --name dns-primary --network dns-lab --ip 172.18.0.2 ubuntu:16.04 tail -f /dev/null
docker run -d --name dns-subdomain --network dns-lab --ip 172.18.0.3 ubuntu:16.04 tail -f /dev/null
docker run -d --name dns-secondary --network dns-lab --ip 172.18.0.4 ubuntu:16.04 tail -f /dev/null
docker run -d --name client --network dns-lab --ip 172.18.0.5 ubuntu:16.04 tail -f /dev/null
```

## 3. Install BIND9 on Servers

```bash
# On each server
apt update && apt install -y bind9 bind9utils
```

## 4. Install Text Editor (Optional but Recommended)

```bash
# Install nano (simpler for beginners)
apt install -y nano

# Or install vim (if preferred)
apt install -y vim
```

**Note:** Run this command inside each container where you need to edit files.

## Client Configuration

### Essential Step: Configure DNS Server

The client must be told which DNS server to use. This is done by editing `/etc/resolv.conf`

```bash
# Set primary DNS server
echo "nameserver 172.18.0.2" > /etc/resolv.conf

# Verify configuration
cat /etc/resolv.conf
```

### What This Does:

- `nameserver 172.18.0.2` = "Use the server at 172.18.0.2 for all DNS queries"
- Without this, the client cannot resolve `dns.cb`, `cliente.danune.cb`, etc.

## Alternative: Create Container with Pre-Configured DNS

```bash
docker run -d --name client --network dns-lab --ip 172.18.0.5 \ --dns 172.18.0.2 \ ubuntu:16:04 tail -f /dev/null
```

## Installing DNS Tools on Client

```bash
# The base Ubuntu image doesn't unclude DNS utilities
apt update
apt install -y dnsutils iputils-ping

# Verify installation
which nslookup
which dig
```

## Testing DNS Configuration

```bash
# Test basic resolution
nslookup dns.cb

# If it fails, check your resolv.conf
cat /etc/resolv.conf
```
