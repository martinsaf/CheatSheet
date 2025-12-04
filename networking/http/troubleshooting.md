### Docker DNS Challenge
**Issue:** Docker containers automatically overwrite `/etc/resolv.conf` with their internal DNS (127.0.0.11).

**Symptoms:**
- Intermittent DNS resolution failures
- Client cannot resolve custom domain names
- Previous DNS configurations disapper after container restarts

**Immediate Solution:**
```bash
# Manually set DNS (temporary)
echo "nameserver 172.18.0.2" > /etc/resolv.conf

# Test
nslookup madeira.xpto.cb
```

**Permanent Solutions:**
1. Docker run with custom DNS: `docker run --dns 172.18.0.2 ...`
2. Docker network configuration: Set DNS at network level
3. Container initialization script: Configure DNS at startup

