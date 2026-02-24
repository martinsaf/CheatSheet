# Wireshark - Display Filters

Filters used **after** the capture, in te Wireshark filter bar.

## General filters

- `ip.addr == 192.168.1.10`
- `tcp.port == 80`
- `udp.port == 53`
- `http`
- `dns`

## Useful filters for UDP/DNS

- `udp` - shows only UDP datagrams
- `udp.port == 53` - DNS traffic
- `ip.addr == <IP_VM>` - virtual machine traffic
- `udp.port == 53 && ip.addr == <IP_VM>`
- `udp && (udp.srcport == 53 || udp.dstport == 53) && ip.addr == <IP_VM>`
- `dns.qry.name == "www.rtp.pt"` - specific DNS requests

## Filters for troubleshooting

- `tcp.analysis.retransmission`
- `tcp.analysis.flags`
- `icmp`

## Combined filters

- `dns && ip.addr == <IP_VM>`
- `udp.length > 50`
