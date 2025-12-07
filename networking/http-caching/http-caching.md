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

## Exercise 5 - Special Server Configurations

### Step 5a) Create subdirectories and test images
Comands executed:
```bash
# Create directories
mkdir -p var/www/html/{static,dynamic,hybrid}

# Install ImageMagick for creating images
apt update && apt install -y imagemagick

# Create test images (100x100 pixels, different colors)
convert -size 100x100 xc:red /var/www/html/static/static.jpg
convert -size 100x100 xc:blue /var/www/html/dynamic/dynamic.jpg
convert -size 100x100 xc:green /var/www/html/hybrid/hybrid.jpg

# Verify files
ls -la /var/www/html/hybrid/
ls -la /var/www/html/dynamic/
ls -la /var/www/html/static/
```

### Step 5b) Modify teste1.html to display images
#### Upated teste1.html:
```html
<!doctype html>
<html lang="pt">
<head>
        <meta charset="utf-8">
        <title>Teste 1</title>
</head>
<body>
        <h1>Testando...</h1>
        <p>Modificando...</p>

        <img src="static/static.jpg">
        <img src="dynamic/dynamic.jpg">
        <img src="hybrid/hybrid.jpg">
</body>
</html>
```
**Access URL:** `http://localhost:8080/teste1.html`

### Step 5d) Test initial page load
#### Execute in browser:
1. Open `http://localhost:8080/teste1.html`
2. Force full reload (Ctrl+F5)
3. Observe Network tab in DevTools

#### Expected results for 5d-i:
**Total browser requests: 6**
1. `teste1.html` (200 OK) - main HTML page
2. `favicon.ico` (404 Not Found) - browser auto-request
3. `static/static.jpg` (200 OK) - static image
4. `dynamic/dynamic.jpg` (200 OK) - dynamic image
5. `hybrid/hybrid.jpg` (200 OK) - hybrid image
6. `content.css` (200 OK) - browser extension (external)

#### Answer to 5d-i:
**Number of requests:** 5 (to our server)

### Step 5e) Results

#### Step 5e-i) Analyze normal refresh (F5):
**Requests observed: 6 (to Apache server)**
1. `teste1.html`
   - Request: Conditional with `If-Modified-Since`
   - Status: **304 Not Modified** (cache valid)
   - Cache status: Validated with server
2. `content.css`
   - Browser extension resource (external, not from our server)
3. `static/static.jpg`, `dynamic/dynamic.jpg`, `hybrid/hybrid`
   - Request: **Not present** in Network tab
   - Status: **200 OK** (from memory cache) shown in browser
   - Cache status: Loaded directlry from browsers memory cache
  
**Key finding:**
- Only 1 HTTP request was made to our Apache server (`teste1.html`)
- All 3 images were served from **browsers memory cache without cache** any without any network request
- The browser displayed status "200 OK (from memory cache)" for each image

#### Step 5e-ii) Status codes analysis:
**Response received from server:**
- `teste1.html`: **304 Not Modified** (conditional request successful)
- Images: **No HTTP response** (served from memory cache)

**Browser-reported status per resource:**
- `teste1.html`: 304 Not Modified
- `static/static.jpg`: 200 OK (from memory cache)
- `dynamic/dynamic.jpg`: 200 OK (from memory cache)
- `hybrid/hybrid.jpg`: 200 OK (from memory cache)

**Technical explanation:**
The browser employs a multi-level caching hierarchy:
1. **Memory cache** (RAM, very fast) - Images were stored here from the previous Ctrl+F5
2. **Disk cache** (persistent storage)
3. **Network request** (HTTP) - Only triggered when cache is invalid/missing

Since the images were recently loaded (within seconds), the browser served them directly from memory cache without making HTTP requests. This demonstrates how effective caching can eliminate network traffic for repeated resources.

