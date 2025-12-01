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

### 3e) Test from Client Browser
**Question**: "What page is displayed when accessing http://xpto.cb?"
**Answer**: Custom personalized page: `<h1>Meu Site xpto.cb</h1>`
```bash
wget -q -O - http://www.xpto.cb

# after 3g):
# Output: <h1>Meu Site xpto.cb</h1>
```

### 3f) Find Document Root
```bash
grep -r "DocumentRoot" /etc/apache2/
# Found: /var/www/html
```

### 3g) Customize Default Page
```bash
echo "<h1>Meu Site xpto.cb</h1>" > /var/www/html/index.html
```

### 3h) Create /teste Directory
```bash
# Create directory in DocumentRoot (Web content goes in `/var/www/html/`, configuration in `/etc/apache2/`)
mkdir /var/www/html/teste
echo "<h1>Pagina de Teste</h1>" > /var/www/html/teste/index.html

# Test access
wget -q -O - http://www.xpto.cb/teste/
# Expected: "<h1>Pagina de Teste</h1>"
```

## Exercise 4: Name-based Virtual Hosts

### 4a) Add DNS Records for New Virtual Hosts
Add new A records to `/etc/bind/db.xpto.cb`:
```bind
madeira        IN       172.18.0.2
castelobranco  IN       172.18.0.2
```
#### Importante: Increase Serial Number
```bind
@       IN      SOA     dns.cb. admin.cb. (
                              2         ; Serial increased from 1 to 2
```

#### Verification:
```bash
named-checkzone xpto.cb /etc/bind/db.xpto.cb
service bind9 restart

# DNS resolution
nslookup madeira.xpto.cb
# Expected: 172.18.0.2
```

### 4b) Test and Analyze

**Teste Execution:**
```bash
wget -q -O - http://www.xpto.cb           # <h1>Meu Site xpto.cb</h1>
wget -q -O - http://madeira.xpto.cb       # <h1>Meu Site xpto.cb</h1>
wget -q -O - http://castelobranco.xpto.cb # <h1>Meu Site xpto.cb</h1>
```

**Question**: "Are different pages shown? Why?"
**Answer**: No, all three URLs show the same page beacause:
1. DNS resolves all domains to the same IP address (172.18.0.2)
2. Apache is configured with only one default Virtual host
3. Without named-base virtual hosting, Apache serve the default DocumentRoot for all requests

**Conclusion**: This demonstrates the need for name-based virtual hosts to serve different content for different domain names pointing to the same server.

### 4c) Create Name-based Virtual Hosts

#### Create Document Roots:
```bash
mkdir -p /var/www/madeira
mkdir -p /var/www/castelobranco

echo '<h1>Bem-vindo a Madeira!'</h1>' > /var/www/madeira/index.html
echo '<h1>Bem-vindo a Castelo Branco!</h1>' > /var/www/castelobranco/index.html
```

##### **Virtual Host Configuration Files**:
**madeira.xpto.cb.conf**:
```apache
<VirtualHost *:80>
  ServerName madeira.xpto.cb
  DocumentRoot /var/www/madeira
</VirtualHost>
```
**castelobranco.xpto.cb.conf**:
```apache
<VirtualHost *:80>
  ServerName castelobranco.xpto.cb
  DocumentRoot /var/www/castelobranco
</VirtualHost>
```
**Enable Virtual Hosts**:
```bash
a2ensite madeira.xpto.cb.conf
a2ensite castelobranco.xpto.cb.conf
service apache2 reload
```

### 4d) Test Virtual Hosts Functionality
**Test Results**:
```bash
wget -q -O - http://www.xpto.cb
# <h1>Meu Site xpto.cb</h1> (default site)

wget -q -O - http://madeira.xpto.cb
# <h1>Bem-vindo a Madeira!</h1> (madeira virtual host)

wget -q -O - http://castelobranco.xpto.cb
# <h1>Bem-vindo a Castelo Branco!</h1> (castelobranco virutal host)
```
**Conclusion**: Name-based virtual hosts are working correctly. Each domain now serves distinct content from its own DocumentRoot directory.

### 5a) Password Protect castelobranco.xpto.cb

#### Configuration Applied:
1. Created password file with `htpasswd`
2. Added authentication directives to Virtual Host
3. Apache configured to require valid use for entire site

#### Test Results:
```bash
# Madeira site (no authentication required):
wget -q -O - http://madeira.xpto.cb
# <h1>Bem-vindo a Madeira!</h1>

# Castelo Branco without credentials:
wget -q -O - http://castelobranco.xpto.cb
# No output (401 Authorization Required)

# Castelo Branco with credentials:
wget -q -O - --user=joao --password=xpto123 http://castelobranco.xpto.cb
# <h1>Bem-vindo a Castelo Branco!</h1>
```
**Success**: Entire `castelobranco.xpto.cb` site now requires HTTP Basic Authentication.

