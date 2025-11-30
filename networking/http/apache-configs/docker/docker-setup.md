# 🐳 Docker configuration for Apache + DNS

## Containers
- Reuse existing network (172.18.0.0/24)
- Server: Apache2 + Bind9 in the same container
- Client: Ubuntu with testing tools

## Deploy Commands
```bash
docker build -t apache-dns .
docker run -d --network dns-network --ip 172.18.0.2 apache-dns
```

## File Structure
```text
apache-configs/
├── virtual-hosts/
│   ├── www.xpto.cb.conf
│   ├── madeira.xpto.cb.conf
│   └── castelobranco.xpto.cb.conf
├── auth-configs/
│   ├── .htaccess
│   └── .htpasswd
└── docker/
    ├── Dockerfile.apache-dns
    └── docker-compose.yml
```
