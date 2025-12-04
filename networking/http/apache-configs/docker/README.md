# 🐳 Docker Environment Configuration

Docker containers used for the Apache Web Server practical lab.

## 🏗️ Network Architecture

| Container | IP Address | Role | Services |
|-----------|------------|------|----------|
| **dns-primary** | 172.18.0.2 | Primary Server | Apache2 + BIND9 DNS |
| **client** | 172.18.0.5 | Testing Client | wget, networking tools |

## 📂 Directory Structure
```
docker/
├── Dockerfile.apache-dns    # Server container definition
├── docker-compose.yml       # Multi-container orchestration
└── README.md               # This file
```

## 🚀 Quick Start

### Using Docker Compose:
```bash
docker-compose up -d
```

### Manual Container Creation:
```bash
# Create network
docker network create --subnet=172.18.0.0/16 dns-lab

# Create server container
docker run -d --name dns-primary \
  --network dns-lab --ip 172.18.0.2 \
  -v $(pwd)/configs:/etc/apache2 \
  ubuntu:16.04 tail -f /dev/null

# Create client container  
docker run -d --name client \
  --network dns-lab --ip 172.18.0.5 \
  ubuntu:16.04 tail -f /dev/null
```

## 🔧 Container Setup

### **dns-primary (Server)**
```bash
# Access container
docker exec -it dns-primary bash

# Install services
apt update && apt install -y apache2 bind9 vim wget

# Copy configurations
cp -r /host/configs/* /etc/apache2/
```

### **client (Testing Client)**
```bash
# Access container
docker exec -it client bash

# Install testing tools
apt update && apt install -y curl wget dnsutils vim

# Configure DNS
echo "nameserver 172.18.0.2" > /etc/resolv.conf
```

## ⚠️ Important Notes

### DNS Configuration Challenge
Docker containers automatically overwrite `/etc/resolv.conf`. Solutions:
1. Use `--dns` flag when creating containers
2. Configure DNS at Docker network level
3. Manual configuration inside containers

### Persistent Configuration
For development, consider:
- Volume mounts for configuration files
- Dockerfile with pre-installed services
- docker-compose for easy management

## 🐛 Troubleshooting

### Common Issues:
1. **DNS not resolving**: Check `/etc/resolv.conf` in client
2. **Apache not responding**: Verify service is running (`systemctl status apache2`)
3. **Network connectivity**: Use `ping` between containers
4. **Port conflicts**: Check with `ss -tulpn`

### Verification Commands:
```bash
# Check container IPs
docker network inspect dns-lab

# Test DNS from client
docker exec -it client nslookup www.xpto.cb

# Test web server
docker exec -it client curl http://www.xpto.cb
```

## 📚 Related Documentation
- [Apache Configuration](https://github.com/martinsaf/CheatSheet/blob/main/networking/dns/bind9-lab.md)
- [Authentication Setup](https://github.com/martinsaf/CheatSheet/tree/main/networking/http/apache-configs/auth-configs)
- [Main Lab Guide]([../http-server.md](https://github.com/martinsaf/CheatSheet/blob/main/networking/http/http-server.md))
