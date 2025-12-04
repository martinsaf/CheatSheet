# 🔐 HTTP Authentication Configuration

## Approach Used
Authentication was implemented using **Apache Directory directives** in Virtual Host configuration files, rather than `.htaccess` files.

### Why This Approach?
- ✅ **Security:** Centralized configuration in protected `/etc/apache2/` directory
- ✅ **Performance:** Apache doesn't need to check for `.htaccess` on every request
- ✅ **Maintenance:** Easier to manage and audit
- ✅ **Compliance:** Follows Apache best practices

## Contents

### 1. [directory-auth-example.conf](directory-auth-example.conf)
**ACTUAL IMPLEMENTATION** - The exact configuration used in Exercise 5c to protect the `/teste` directory.

### 2. [htaccess-example.htaccess](htaccess-example.htaccess)  
**EXAMPLE** - Alternative .htaccess approach (not used, for comparison).

### 3. [.htpasswd](.htpasswd)
Password file with three users (joao, maria, miguel).

## Key Learning
The lab demonstrates the using `<Directory>` directives in Virtual Host configuration files instead of `.htaccess` files for better security and performance.
