# OWASP ZAP Basics

## Installation
- Download the appropriate installer from `https://www.zaproxy.org/download/`
- For OAST/Interactsh support, ensure the "OAST Support" add-on is installed (`Tools` → `Plugins` → search "OAST").

## Proxy Setup
Zap listens by default on `localhost:8080`. Point your browser or Burp Suite upstream proxy to this address.

### Browser Configuration
- Set manual proxy to `127.0.0.1`, port `8080`
- Import the ZAP ROOT CA certificate for HTTPS interception: `Tools` -> `Options` -> `Dynamic SSL Certificates` -> `Save`

## OAST (Out-of-Band) with Interactsh
This bypasses restrictions of PortSwigger's Community Edition when requiring out-of-band interaction. 

1. Go to `Tools` -> `Options` -> `OAST` -> `Interactsh` tab
2. Set `Server URL` to `https://interactsh.com`
3. Click **New Payload**. This generates a domain like `c0ffee12345.oastify.com`. Copy it.
4. Use this payload directly in your injections
5. Monitor interactions in the `OAST` tab -> `Interactsh` -> **"Poll"**
6. A successful DNS/HTTP interaction confirms the injection worked

## Scripting
ZAP supports scripts in JavaScript, Python, Ruby, etc.
- `Tools` -> `Scripts` -> `New Script`
- Choose type (HTTP Sender, Proxy Listener, etc.)