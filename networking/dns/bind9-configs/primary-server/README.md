# Primary DNS Server Configuration (.cb domain)

## Overview

This directory contains the configuration files for the **primary (master) DNS server** responsible for the top-level domain `.cb`.

## Core Configuration File: `/etc/bind/db.cb`

### File Structure & Syntax

A DNS zone file consists of **records** with specific fields separated by whitespace (spaces or tabs).

| Position | Field Name | Description                                     | Example                          |
| -------- | ---------- | ----------------------------------------------- | -------------------------------- |
| 1        | **NAME**   | Record's domain name (relative to zone)         | `dns`, `@` (zone apex)           |
| 2        | **TTL**    | Time-To-Live in seconds (optional)              | `20` or omitted (uses `$TTL`)    |
| 3        | **CLASS**  | Address class (almost always `IN` for Internet) | `IN`                             |
| 4        | **TYPE**   | Record type (`SOA`, `NS`, `A`, etc.)            | `SOA`, `A`                       |
| 5+       | **RDATA**  | Type-specific data                              | Ip address, hostname, parameters |

### complete Zone File for Exercise 1a

```bind
; BIND9 Zone File for .cb domain
$TTL    20                      ; Global TTL: 20 seconds for all records

; Start of Authority - Defines zone parameters
@   IN  SOA dns.cb. admin.cb. (
                    1       ; Serial (version, increment on changes)
                    600     ; Refresh = 10 minutes (600 seconds)
                    60      ; Retry = 1 minute (60 seconds)
                    86400   ; Expire = 1 day (86400 seconds)
                    20 )    ; Minimum TTL = 20 seconds

; Name Server Record - Declares authoritative server for .cb
@   IN  NS  dns.cb.

; Address Record - Maps dns.cb to its IP address
dns IN  A   172.18.0.2
```

## Record Breakdown

### 1. SOA (Start of Authority) Record

The SOA record defines the fundamental properties of the DNS zone:

- **MNAME**: `dns.cb.` - Primary master name server for the zone
- **RNAME**: `admin.cb` - Administrator email (format: `admin.cb.` = `admin@cb`)
- **SERIAL**: `1` - Zone version number (must increment after each change)
- **REFRESH**: `600` - How ofter secondary servers should check for updates (10 minutes)
- **RETRY**: `60` - Retry interval if refresh fails (1 minute)
- **EXPIRE**: `86400` - Time before zone data is invalid if primary is unreachable (1 day)
- **MINIMUM**: `20` - Minimum TTL for negative caching (20 seconds)

### 2. NS (Name Server) Record

- Declares `dns.cb.` as the authoritative name server for the `.cb` domain
- The `@` symbol represents the zone apex (`.cb.` itself)

### 3. A (Address) Record

- Provides the **glue record** - essential for resolving the name server's own address
- Maps `dns.cb.` to IP address `172.18.0.2`

## Critical Configuration Notes

### TTL (Time To Live) Hierarchy

1. **Global TTL**: `$TTL 20` applies to all records unless overriden
2. **Record-specific TTL**: Can be specified in the second field of any record
3. **SOA Minimum TTL**: Used for negative responses (NXDOMAIN)

### Name Resolution

- **Relative names**: `dns` becomes `dns.cb.` (appends zone name)
- **Absolute names**: `dns.cb.` (ends with dot) is fully qualified
- **Zone apex**: `@` represents the zone itself (`.cb.`)

## Serial Number Management

**CRUCIAL**: The serial number must be **incremented** every time the zone file is modified, or changes won't propagate to secondary servers.

```bind
; Before change
@ IN SOA dns.cb. admin.cb. (1 600 60 86400 20)

; After adding a record - INCREMENT SERIAL!
@ IN SOA dns.cb. admin.cb. (2 600 60 86400 20)
```

## Associated Configuration Files

**`/etc/bind/named.conf.local`**

```bind
zone "cb" {
    type master;
    file "/etc/bind/db.cb";
};
```

### Testing Commands

```bash
# Check zone file syntax
named-checkzone cb /etc/bind/db.cb

# Test DNS resolution from client
nslookup dns.cb 172.18.0.2
ping dns.cb
```

### Common Issues & Solutions

- **"Servfail" or no response**: Check BIND service status: `service bind9 status`
- **Syntax errors**: Use `named-checkzone` to validate the zone file
- **No glue record**: Without the A record for `dns.cb.`, the NS record is unresolvable
- **Serial not incremented**: Secondary servers won't recognize changes

---

**Key Takeway**: The SOA defines zone parameters, NS declares authority, and A provides the essential IP mapping. All three are required for a functional DNS zone.
