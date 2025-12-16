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
