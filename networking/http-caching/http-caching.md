# HTTP Caching Lab

## Exercise 1 - HTTP Server preparation

### Environment
- **Server:** `dns-primary` container (Ubuntu 16.04, IP: 172.18.0.2)
- **Proxy:** `web-proxy` container (IP: 172.18.0.6, port mapping 8080:80)
- **Client:** Windows desktop browser via proxy

## Setup Step
1. Configured Apache server in dns-primary (docker container)
```bash
apt update
apt install apache2 mysql-server php libapache2-mod-php php-mysql

# exercise asks for `ufw disable` but docker container doesnt have it

service apache2 restart
```

2. Added port forwarding proxy (Windows cant access Docker bridge IPs directly):
```bash
docker run -d --name web-proxy -p 8080:80 --network dns-lab alpine/socat tcp-listen:80,fork,reuseaddr tcp-connect:172.18.0.2:80
```

3. Access via Windows browser: `http://localhost:8080/`
**Browser output**: "Meu Site xpto.cb"

**Note:**
Original plan was to user `client` container, but browser DevTools testing required Windows access. Proxy solution allows both:
- Internal testing via `client` container: `curl http://172.18.0.2`
- Browser testing from Windows: `http://localhost:8080`

---
## Exercise 2 - Test Page Preparation

### Step 1a: Create `teste1.html` file
```bash
# Inside dns-primary container, /var/www/html
touch teste1.html
vim teste1.html
```
```html
<!doctype html>
<html lang="pt">
<head>
  <meta charset="utf-8">
  <title>Teste 1</title>
</head>

<body>
  <h1>Testando...</h1>
</body>
</html>
```

### Step 2b: Access test page
- **From Desktop browser:** `http://localhost:8080/teste1.html`
- **Expected output:** Page with "Testando..." heading

### Verification
Test with curl from Windows:
```bash
curl http://localhost:8080/teste1.html
```
**Output should show:**
```html
<!doctype html>
<html lang="pt">
<head>
        <meta chatset="utf-8">
        <title>Teste 1</title>
</head>
<body>
        <h1>Testando...</h1>
</body>
</html>
```

---
## Exercise 3 - Basic HTTP Protocol Verification

### Step 3a: Open browser DevTools (F12) -> Network tab

### Step 3b: Force full page reload (Ctrl+F5)

### Step 3c: Analyze captured data
**Expected results:**
1. Number of requests: 2
   - `teste1.html` (from Apache server, IP 172.18.0.2)
   - `content.css` (from browser extension, not from the server)
2. HTTP method: GET (for both requests)
3. Status code: 200 OK
   - `teste1.html`: 200 OK
   - `content.css`: 200 OK (from extension, not from Apache)
4. Headers HTTP from server:
   - MIME type: `text/html` (Content-Type)
   - Compression: Yes (`content-encoding: gzip`)
   - Diference Date vs Last-Modified:
     - `Date: Sat, 06 Dec 2025 16:18:02 GMT` (response time)
     - `Last-Modified: Sat, 06 Dec 2025 15:36:26 GMT` (modification file time)
     - Difference: ~42 minutes
   - Last-Modified corresponds to the file? yes, look correct
   - ETag? Yes (`"8d-6454a5340232f-gzip"`)
  
#### **To filter only my website:**
**On DevTools Network:**
1. On filter field write: `localhost:8080`
2. Or: `domain:localhost`
3. Now I only see the request from my server (bottom information from request still says 1/2 requests).


   

