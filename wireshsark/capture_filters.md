# Wireshark - Capture Filters

Filters applied **before** starting the capture.

## Basic Filters

- `udp`
- `tcp`
- `port 53`
- `udp port 53` - captures only DNS
- `host <VM_IP>` - captures only VM traffic

## Combined Filters

- `udp and host <VM_IP>`
- `udp and port 53 and host <VM_IP>`

## Additional Examples

- `net 192.168.1.0/24`
- `tcp portrange 1-1024`
