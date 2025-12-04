# 🔐 HTTP Authentication Configuration

## Approach Used
Authentication was implemented using **Apache Directory directives** in Virtual Host configuration files, rather than `.htaccess` files.

### Why This Approach?
- ✅ **Security:** Centralized configuration in protected `/etc/apache2/` directory
- ✅ **Performance:** Apache doesn't need to check for `.htaccess` on every request
- ✅ **Maintenance:** Easier to manage and audit
- ✅ **Compliance:** Follows Apache best practices

### Configuration Examples

#### Directory Authentication (Used in this lab):
```apache
<Directory "/var/www/html/teste">
    AuthType Basic
    AuthName "Acesso Restrito ao Teste"
    AuthUserFile /etc/htpasswd/.htpasswd
    Require valid-user
</Directory>

Creating/Managing Passwords:
```bash
# Create new user
htpasswd -c /path/to/.htpasswd username

# Add additional user
htpasswd /path/to/.htpasswd anotheruser

# Verify file
cat /path/to/.htpasswd
```
