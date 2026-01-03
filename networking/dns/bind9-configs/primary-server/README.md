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

### Complete Zone File for Exercise 1a

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

```text
NORMAL REGIST (NS/A):
[NAME] [TTL] CLASS TYPE RDATA-simple
   ↓     ↓     ↓     ↓       ↓
   @     -    IN    NS    dns.cb.

SOA REGIST (SPECIAL):
[NAME] [TTL] CLASS TYPE RDATA-complex
   ↓     ↓     ↓     ↓       ↓
   @     -    IN    SOA   dns.cb. admin.cb. ( SERIAL REFRESH RETRY EXPIRE MINIMUM )
```

## Record Breakdown

### Quick Reference: DNS Record Fields

| Field | Meaning                            | Example in `db.cb`            |
| ----- | ---------------------------------- | ----------------------------- |
| `@`   | Zone apex (the domain itself)      | `@ IN NS dns.cb.`             |
| `IN`  | Internet class (always this)       | `IN`                          |
| `SOA` | Start of Authority (zone metadata) | `SOA dns.cb. admin.cb. (...)` |
| `NS`  | Name Server (authoritative server) | `NS dns.cb.`                  |
| `A`   | Address record (IPv4)              | `A 172.18.0.2`                |

### 1. SOA (Start of Authority) Record

The SOA record defines the fundamental properties of the DNS zone:

- **MNAME**: `dns.cb.` - Primary master name server for the zone
- **RNAME**: `admin.cb` - Administrator email (format: `admin.cb.` = `admin@cb`)
- **SERIAL**: `1` - Zone version number (must increment after each change)
- **REFRESH**: `600` - How often secondary servers should check for updates (10 minutes)
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

### **`/etc/bind/named.conf.local`**

This file **declares** zones to the BIND9 service. Each `zone` block tells BIND:

- **`cb`**: The domain name to be authoritative for
- **`type master;`**: This server is the primary (master) for the zone
- **`file "/etc/bind/db.cb";`**: Path to the zone file containing DNS records

```bind
zone "cb" {
    type master;
    file "/etc/bind/db.cb";
};
```

**Why Its Needed:**

- BIND9 doesnt automatically load all `.db` files in `/etc/bind/`
- Each zone must be explicity declared
- The `zone` name must match your domain (`"cb"` = `.cb`)

**Key Concepts:**

- `zone "cb"` = Declares authority for the `.cb` domain
- `type master` = This is the primary/authoritative server
- `file` directive = Points to the actual zone data (`db.cb`)
- The zone name **must match** the domain in your zone file

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

---

## Exercise-by-Exercise Implementation

### Exercise 1a: Configure Primary Server with Timeouts

**Objective:** Create a basic zone file with specified timeouts.

**Configuration (`db.cb` lines 1-7):**

```bind
$TTL 20
@ IN SOA dns.cb. admin.cb. (
   1     ; Serial (starts at 1)
   600   ; Refresh = 10 minutes (600 seconds)
   60    ; Retry = 1 minute (60 seconds)
   86400 ; Expire = 1 day (86400 seconds)
   20    ; Minimum TTL = 20 seconds
)
```

**Key Points:**

- Time values must be converted to seconds
- Serial starts at 1 and must increment with changes
- Minimum TTL in SOA is for negative caching

### Exercise 1b: Add A Record for dns.cb

**Objective:** Map the name server to its IP address.
**Configuration (`db.cb` line 9):**

```bind
dns IN A 172.18.0.2
```

**Why This Matters:**

- Without this "glue record", the NS declaration is unresolvable
- Creates the host `dns.cb` -> `172.18.0.2`

### Exercise 1c: Configure Client DNS

**Objective:** Point client to our DNS server.

**Command on client:**

```bash
echo "nameserver 172.18.0.2" > /etc/resolv.conf
```

### Exercise 1d/1e: Testing

**Successful test (1d):**

```bash
nslookup dns.cb 172.18.0.2 # Returns 172.18.0.2
ping dns.cb                # Should work
```

**Expected failure (1e):**

```bash
ping cliente.danune.cb      # Should fail - subdomain not configured yet
```

### Exercise 2a: Subdomain Delegation

**Objective:** Delegate `danune.cb` to another server.
**Configuration (`db.cb` lines 6-7):**

```bind
danune IN NS milk.danune.cb.
milk.danune.cb. IN A 172.18.0.3
```

**Critical Details:**

- Two records required: NS (Who manages) + A (where they are)
- `milk.danune.cb.` needs trailing dot (absolute name)
- Delegation happens at the subdomain level (`danune` not `@`)

---

## Complete `db.cb` File (After Exercise 2a)

```bind
; BIND9 Zone File for .cb domain
$TTL 20
@ IN SOA dns.cb. admin.cb. (4 600 60 86400 20)

@ IN NS dns.cb.
danune IN NS milk.danune.cb.

dns IN A 172.18.0.2
milk.danune.cb. IN A 172.18.0.3
```

**Serial Note:** Serial _can be_ 4 after multiple test iterations.

---

# Subdomain DNS Configuration (danune.cb)

## Overview

This directory contains configuration files for the **subdomain DNS server** responsible for the `danune.cb` domain.

## Core Configuration File: `/etc/bind/db.danune.cb`

### Complete Zone File (Exercises 2b + 2c)

```bind
; BIND9 Zone File for danune.cb subdomain
$TTL 20  ; Global TTL: 20 seconds

; Start of Authority - Exercise 2b
@ IN SOA milk.danune.cb. admin.danune.cb. (1 5M 1M 1D 20)

; Name Server Record
@ IN NS milk.danune.cb.

; Address Records - Exercise 2c
milk     IN A 172.18.0.3   ; Subdomain DNS server itself
cliente   IN A 172.18.0.5   ; Test client
servidor IN A 172.18.0.4   ; Secondary DNS server

; IPV6 Records - Exercise 2d (placeholder)
milk6       IN AAAA  ::1
cliente6    IN AAAA  ::1
servidor6   IN AAAA  ::1
```

#### IPv4 & IPv6 Tests

```bash
ping -c 2 cliente.danune.cb
ping -c 2 servidor.danune.cb
ping -c 2 milk.danune.cb

ping6 -c 2 cliente6.danune.cb
ping6 -c 2 servidor6.danune.cb
ping6 -c 2 milk6.danune.cb
```

The DNS delegation chain is fully functional. IPv6 records are configured but use placeholder addresses (`::1`) as specified in the exercise.

### Key Differences from Primary Zone (.cb)

| Aspect    | Primary (.cb)     | Subdomain (danune.cb)     |
| --------- | ----------------- | ------------------------- |
| Zone Name | `cb`              | `danune.cb`               |
| SOA MNAME | `dns.cb`          | `milk.danune.cb`          |
| Refresh   | 10 minutes (600s) | 5 minutes (5M/300s)       |
| NS Record | `@ IN NS dns.sb.` | `@ IN NS milk.danune.cb.` |

### Time Format Notes

BIND9 accepts human-readable time formats.

### Associated Configuration Files

`/etc/bind/named.conf.local`

```bind
zone "danune.cb" {
   type master;
   file "/etc/bind/db.danune.cb";
};
```

### Testing Commands

```bash
# Check zone file syntax
named-checkzone danune.cb /etc/bind/db.danune.cb

# Test from client (after delegation is configured)
nslookup cliente.danune.cb 172.18.0.2 # Should return 172.18.0.5
nslookup servidor.danune.cb 172.18.0.2 # Shoudl return 172.18.0.4
```

### Common Issues

- "SERVFAIL" error: Ensure delegation is properly configured in primary servers `db.cb`
- No response: Verify BIND9 service is running on subdomain server
- NXDOMAIN for milk.danune.cb: Check glue record exists in primary zone

---

# Secondary DNS Configuration (danune.cb)

## Overview
This directory contains configuration files for the secondary (slave) DNS server that provides redundancy for the `danune.cb` domain.

## Core Configuration File: `/etc/bind/named.conf.local`

### Slave Zone Declaration
Unlike primary servers, secondary servers declare zone as `slave` type and specify the primary servers IP address:
```bind
zone "danune.cb" {
   type slave;
   file "var/cache/bind/db.danune.cb";
   masters { 172.18.0.3; };
};
```

### Key Configuration Points
- `type slave`: Server receives zone data via automatic transfers
- `file`: Located in `/var/cache/bind/` (not `/etc/bind/`) / BIND writes here automatically
- `masters`: IP of the primary authoritative server for this zone
- **NO manual zone file creation:** The `db.danune.cb` file is automatically created after zone transfer

## Exercise-by-Exercise Implementation

### Exercise 3a: Configure Secondary Server
**Objective**: Set up slave server for automatic zone transfers.

**Configuration (`/etc/bind/named.conf.local`):**
```bind
zone "danune.cb" {
   type slave;
   file "/var/cache/bind/db.danune/cb";
   masters { 172.18.0.3; };
};
```

**Verification Commands:**
```bash
# Check configuration syntax
named-checkconf /etc/bind/named.conf.local

# Restart BIND9
service bind9 restart

# Check if zone file was transferred (after 1-2 minutes)
ls -la /var/cache/bind/
```

### Exercise 3b: Verify Automatic Zone Transfer
**Objective**: Confirm zone data is replicated from primary.

**Verification Steps:**
1. Wait 1-2 minutes after configuration the slave
2. Check if zone file appears in cache:
```bash
ls -la /var/cache/bind/ 
```
3. Test DNS resolution locally:
```bash
nslookup cliente.danune.cb 127.0.0.1
```

**Expected Result:** The slave server should successfully resolve queries for the `danune.cb` domain.

### Exercise 3c: Add Record to Primary and Increment Serial
**Objective:** Modify primary zone and verify propagation.

**On Primary Server (`dns-subdomain`):**
1. Edit `/etc/bind/db.danune.cb`
2. Add new A record and increment serial:
; Before: serial = 2
; After: serial = 3
iogurte IN A 172.18.0.6
3. Restart BIND9 on primary

### Exercise 3d: Verify Automatic Replication
**Objective:** Confirm changes propagate to secondary.
**On Secondary Server:**
```bash
# Wait for automatic transfer (1-2 minutes)
# Then test:
nslookup iogurte.danune.cb 127.0.0.1 
```

**Success Criteria**: Secondary resolves the new `iogurte.danune.cb` record without manual intervention.

### Exercise 3e: Failover Testing
**Objective**: Demonstrate high availability when primary fails.
**Test Procedure**:
1. Stop primary server:
```bash
# On dns-subdomain
docker stop dns-subdomain
```

2. Configure client to use secondary DNS:
```bash
# On client container
echo "nameserver 172.18.0.4" > /etc/resolv.conf
```

3. Test DNS resolution:
```bash
nslookup iogurte.danune.cb 172.18.0.4 
```

3. Restore primary (after testing):
```bash
docker start dns-subdomain
echo "nameserver 172.18.0.2" > /etc/resolv.conf
```

---

**Key Takeaway:** Secondary DNS servers provide redundancy through automatic zone transfers. The slave configuration is simpler than master configuration but requires proper network connectivity and serial number management on the primary server.