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

### 2b) The server must have the names 'dns.xpto.cb' and 'www.xpto.cb' associated with the server's IPv4 address and 'www6.xpto.cb' associated with the server's IPv6 address.

#### Add to named.conf.local

```bind
zone "xpto.cb" {
    type master;
    file "/etc/bind/db.xpto.cb";
};
```

Zone file now contains:
- `dns.xpto.cb` → 172.18.0.2 ✅
- `www.xpto.cb` → 172.18.0.2 ✅  
- `www6.xpto.cb` → ::1 (placeholder IPv6) ✅

### 2c) Client DNS Configuration
```bash
# Configure client to use custom DNS
echo "nameserver 172.18.0.2" > /etc/resolv.conf
```

### 2d) Connectivity Testing
```bash
# Test DNS resolution
nslookup www.xpto.cb
# Expected: 172.18.0.2

# Test network connectivity
ping www.xpto.cb
# Expected: successful ping to 172.18.0.2
```

## Exercise 3: Apache Installation & Basic Configuration

### 3b) Install Apache Web Server
```bash
# Install Apache on dns-primary
apt update && apt install -y apache2
```

### 3c) Verify Service Status
```bash
# Restart and check Apache service
service apache2 restart
service apache2 status

# Expected output: "Active: active (running)"
# Expected: Service starts with warning (normal behavior from `service apache2 start`)
# Warning: "Could not reliably determine the server's FQDN"
```

### 3d) Apache Logs
- **Access logs**: /var/log/apache2/access.log
- **Error logs**: /var/log/apache2/error.log
- **Check for startup errors**:
```bash
tail -f /var/log/apache2/error.log
```

