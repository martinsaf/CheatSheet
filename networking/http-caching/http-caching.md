# HTTP Caching Lab

## Exercise 1 - HTTP Server preparation

### Environment
- **Server:** `dns-primary` container (Ubuntu 16.04, IP: 172.18.0.2)
= **Proxy:** `web-proxy` container (IP: 172.18.0.6, port mapping 8080:80)
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
