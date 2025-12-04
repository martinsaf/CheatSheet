## **📁 README.md para `virtual-hosts/`:**

```markdown
# 🌐 Apache Virtual Host Configurations

This directory contains the actual Apache Virtual Host configuration files used in the practical lab.

## 📋 Configuration Files Overview

| File | Purpose | Key Features |
|------|---------|--------------|
| **[000-default.conf](000-default.conf)** | Default Virtual Host template | Base configuration, inherited by others |
| **[www.xpto.cb.conf](www.xpto.cb.conf)** | Main domain (`www.xpto.cb`) | Default site, `/teste` directory authentication |
| **[madeira.xpto.cb.conf](madeira.xpto.cb.conf)** | Madeira Virtual Host | Permanent redirect to external site, custom error pages |
| **[castelobranco.xpto.cb.conf](castelobranco.xpto.cb.conf)** | Castelo Branco Virtual Host | Full-site HTTP Basic Authentication |
| **[www6.xpto.cb.conf](www6.xpto.cb.conf)** | IPv6-only Virtual Host | IPv6 interface binding (`[::]:80`) |
| **[default-ssl.conf](default-ssl.conf)** | SSL/TLS template | HTTPS configuration (not used in lab) |

## 🔧 Key Configuration Patterns

### 1. **Name-based Virtual Hosting**
```apache
<VirtualHost *:80>
    ServerName domain.xpto.cb
    DocumentRoot /var/www/directory
</VirtualHost>
```

### 2. **HTTP Basic Authentication**
```apache
<Directory "/path/to/protected">
    AuthType Basic
    AuthName "Restricted Area"
    AuthUserFile /etc/htpasswd/.htpasswd
    Require valid-user
</Directory>
```

### 3. **Permanent Redirect**
```apache
Redirect permanent / http://external.site.com
```

### 4. **Custom Error Pages**
```apache
ErrorDocument 404 /404.html
ErrorDocument 403 /403.html
```

### 5. **IPv6 Virtual Host**
```apache
<VirtualHost [::]:80>
    ServerName ipv6domain.xpto.cb
    # ... configuration
</VirtualHost>
```

## 🎯 Exercise Implementation

### **Exercise 4 - Name-based Virtual Hosts**
- `madeira.xpto.cb.conf` → Serves content from `/var/www/madeira`
- `castelobranco.xpto.cb.conf` → Serves content from `/var/www/castelobranco`

### **Exercise 5 - HTTP Authentication**
- `castelobranco.xpto.cb.conf` → Full site authentication
- `www.xpto.cb.conf` → `/teste` directory authentication only

### **Exercise 6 - IPv6 Virtual Host**
- `www6.xpto.cb.conf` → IPv6-only accessible site

### **Exercise 7 - Advanced Features**
- `madeira.xpto.cb.conf` → Redirect + custom error pages

## 🚀 Activation Commands
```bash
# Enable a Virtual Host
sudo a2ensite filename.conf

# Disable a Virtual Host  
sudo a2dissite filename.conf

# Reload Apache configuration
sudo systemctl reload apache2

# Test configuration syntax
sudo apache2ctl configtest
```

## 📝 Notes
- All configurations are **working examples** from the practical lab
- Authentication uses centralized `<Directory>` directives (not `.htaccess`)
- IPv6 configuration demonstrates interface-specific binding
- Error pages and redirects show Apache capabilities

## 🔗 Related Files
- DNS configuration: See `networking/dns/bind9-lab.md` directory
- Authentication files: See `networking/http/apache-configs/auth-configs` directory
- Lab documentation: See `networking/http/http-server.md`




