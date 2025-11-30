# 🐧 Apache Web Server - Practical Work

## Objective
Configure Apache server with Virtual Hosts, authentication, and integrated DNS.

## Environment
- **Server:** dns-primary (172.18.0.2) - Apache + DNS Bind9
- **Client:** client (172.18.0.5) - Testing with curl/browser
- **Domain:** xpto.cb

## Exercises
- [ ] 1. Basic preparation
- [ ] 2. DNS configuration for xpto.cb
- [ ] 3. Apache installation and configuration
- [ ] 4. Name-based Virtual Hosts
- [ ] 5. Basic HTTP authentication
- [ ] 6. IPv6 Virtual Hosts
- [ ] 7. Advanced configurations

## Useful Commands
```bash
# Test Virtual Host
curl -H "Host: madeira.xpto.cb" http://172.18.0.2

# View Apache logs
tail -f /var/log/apache2/error.l
```
### **2. `http/apache-configs/`**
```text
apache-configs/
├── virtual-hosts/
│ ├── www.xpto.cb.conf
│ ├── madeira.xpto.cb.conf
│ └── castelobranco.xpto.cb.conf
├── auth-configs/
│ ├── .htaccess
│ └── .htpasswd
└── docker/
├── Dockerfile.apache-dns
└── docker-compose.yml
```

### **3. `http/docker-setup.md`**

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

### **4. `networking/README.md`** (Index)

# 🌐 Practical Network Work

## 📚 Laboratories

### DNS Bind9
- [DNS server configuration](dns/bind9-lab.md)
- Troubleshooting: [dns/troubleshooting.md](dns/troubleshooting.md)

### Apache Web Server  
- [Apache + Virtual Hosts Configuration](http/http-server.md)
- [Docker Setup](http/docker-setup.md)

## 🛠️ Common Tools
- `dig`, `nslookup`, `curl`, `apache2ctl`

## Exercise 2: DNS Configuration

### ✅ 2a) DNS Service for xpto.cb domain
- **BIND9 already installed** on dns-primary (172.18.0.2)
- **Created zone file:** `/etc/bind/db.xpto.cb`
- **Added to configuration:** `/etc/bind/named.conf.local`

#### Zone File Content:
```bind
; /etc/bind/db.xpto.cb
@       IN      SOA     dns.xpto.cb. admin.xpto.cb. (
                              1         ; Serial
                         600         ; Refresh
                          60         ; Retry
                        86400         ; Expire
                            20 )      ; Negative Cache TTL

; Name Servers
@       IN      NS      dns.xpto.cb.

; A Records  
@       IN      A       172.18.0.2
dns     IN      A       172.18.0.2
www     IN      A       172.18.0.2

; AAAA Records (IPv6)
www6    IN      AAAA    ::1
```

#### Verification:
```bash
named-checkzone xpto.cb /etc/bind/db.xpto.cb
service bind9 restart
```

---
