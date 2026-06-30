# 📘 Basic Linux

---

# 1. 🖥️ System & Information

- `cat /etc/os-release` — Check OS version
- `uname -a` — Check kernel version
- `apt update && apt upgrade` — Update system
- `<command> | ccze -A` — Colorize output

### Graphical Access to System Files
```
# Open file manager as administrator
nautilus admin:///path/to/folder

# Practical examples:
nautilus admin:///etc/apache2
nautilus admin:///var/www
nautilus admin:///etc/ssh

# ⚠️ WARNING: May hang the terminal
# Solution: run in background
nautilus admin:///etc/apache2/sites-available &
```

---

# 2. 📑 Journalctl (Systemd Logs)

### Main Commands

- `journalctl` — View all logs
- `journalctl -u <service>` — Logs for a specific service (e.g., `ssh.service`)
	- `journalctl -u apache2`
	- `journalctl -u ssh`
	- `journalctl -u apache2 -xe`
- `journalctl -p err..alert` — Filter by severity
- `journalctl --since "1 hour ago"`
- `journalctl --since yesterday --until "today 09:00"`
- `journalctl -f` — Follow logs in real time
- `journalctl -b` — Logs from the last boot
- `journalctl /usr/bin/sshd` — Logs from a specific binary
- `journalctl -xe`
	- `-x` -> Shows additional explanations (like a translator)
	- `-e` -> Jumps to the end of the file (the most recent logs)
- `journalctl -xe | grep -i error`
	- `-i` -> Ignores case (error, Error, ERROR - all appear)
- `journalctl -xe | grep -i fail`
- `journalctl -xe | grep -i warning`
- `journalctl -xe | grep -i "permission denied"`

### Format Output

- `journalctl -o json-pretty`
- `journalctl -o verbose`

### Maintenance

- `journalctl --disk-usage` — Check disk space used
- `sudo journalctl --vacuum-time=2weeks` — Clean up old logs

---

# 3. 📂 System Navigation

- `cd`, `ls`, `pwd`, `mkdir`, `rm`

- Common Issues:
    - *Permission denied* → use `sudo`
    - *Command not found* → install package / fix PATH

### Search for files
- `find ~ -name "*.txt"` — Searches for all `.txt` files in the home directory

---

# 4. 👤 User & Group Management

### Users

- `sudo adduser name`
- `sudo deluser name`
- `sudo usermod [options] name`
- `passwd name`
- `su - name`
- `id name`
- `grep name /etc/passwd`
- `passwd -l name` — Lock account (blocks password login)
- `passwd -u name` — Unlock account

### Groups

- `sudo addgroup <group>`
- `sudo usermod -aG group name`
- `groups name`

---

# 5. 🔐 Permissions & Ownership

- `ls -l`, `chmod`, `chown`, `chgrp`

### chmod Table (Octal)

| Value | Permissions | Meaning                      |
| ----- | ----------- | ---------------------------- |
| 0     | ---         | No permissions               |
| 1     | --x         | Execute only                 |
| 2     | -w-         | Write only                   |
| 3     | -wx         | Write + execute              |
| 4     | r--         | Read only                    |
| 5     | r-x         | Read + execute               |
| 6     | rw-         | Read + write                 |
| 7     | rwx         | Read + write + execute       |

### Examples
- `chmod 644 file.txt`
- `chmod 755 script.sh`
- `chmod 600 private_key`
- `sudo chown user:group file`

---

# 6. 🛡️ Sudo & Security

- Edit sudoers (always use visudo): `user ALL=(ALL) ALL`
- Grant sudo permission: user ALL=(ALL) ALL
- Restrict commands:
- `technician ALL=(ALL) /usr/bin/systemctl restart ssh`

### Root Account Management (Lock/Unlock)
- `sudo passwd -l root` — Lock root account (invalidates password, adds `!` in `/etc/shadow`)
- `sudo passwd -u root` — Unlock root account (removes `!` from `/etc/shadow`, reactivates password)
- ⚠️ **Golden Rule**: Never lock the `root` account (`passwd -l`) before testing that your user has 100% `sudo` permissions. If `sudo` fails and `root` is locked, you lose administrator access (except by going to Recovery Mode).

---

# 7. 🔒 SSH Security

- Config: `/etc/ssh/ssh_config`
- Examples: `AllowUsers analyst technician`, `DenyUsers operator`
- Restart SSH: `sudo systemctl restart ssh`

---

# 8. ⚙️ Process Management
### Processes
- `ps`, `ps -u user`, `top`
- `kill <PID>` — Terminate a process
- `kill -9 <PID>` — If the process resists

### Services (systemd)
- `systemctl start/stop/restart/status <service>`
- `systemctl list-units --type=service` — View active services
- `journalctl -u <service> -p err`

---

# 9. 📜 Scripts & Automation

- `chmod +x script.sh`
- Use absolute paths

---

# 10. 🌐 Network (Interface & Configuration)

### Basic Commands
- `ping`, `ip a`, `ip route`, `curl`, `wget`
- `ls -lt /var/log` — List logs from newest to oldest
- `sudo tail -n 20 /var/log/syslog | ccze -A` — Colored lines with authentication failures

### Routes (ip route)
```text
ip route show
ip route add 192.168.1.0/24 via 192.168.0.1 dev eth0
ip route del 192.168.1.0/24
ip route add default via 192.168.0.1
ip route get 8.8.8.8
```
### Persistence (netplan)
```text
routes: 
	- to: 192.168.1.0/24
	  via: 192.168.0.1
```

### NetworkManager (nmcli)
- `nmcli con show`, `nmcli dev status`
- `nmcli con up "Connection"`
- `nmcli con add type ethernet ...`
- `nmcli dev wifi connect "SSID" password "password"`
- `nmcli con reload`

### Persistent Configuration (/etc/network/interfaces)
```text
# iface ens160 inet dhcp
iface ens160 inet static
	address 10.222.4.46
	netmask 255.255.255.0
	gateway 10.222.4.10
	
dns-nameservers 10.222.4.10
```

---

# 11. 📦 Packages (APT)

- `apt update`,  `apt upgrade`
- `apt install <pkg>`, `apt remove <pkg>`
- `apt --fix-broken install`

---

# 12. 💾 Disks & Storage

- `df -h`, `du -sh *`, `lsblk`
- `mount` / `umount`

---

# 13. 🗜️ Compression

- `tar`, `gzip`, `zip`, `unzip`

---

# 14. 🔥 Firewall (UFW)

- `ufw status`
- `ufw allow 22`
- `ufw deny <port>`

---

# 15. 🩺 System Diagnosis
(Logical Sequence)
```bash
#1. 🕵️‍♂️ PROCESS IDENTIFICATION
ps aux              # Photo of all processes
top                 # Real-time monitoring
pgrep <name>        # Find specific PID

# 2. 📊 SYSTEM HEALTH
uptime              # System load + uptime
free -h             # Available RAM memory
df -h               # Disk space

# 3. 🔧 PROCESS MANAGEMENT
kill <PID>          # Gracefully stop process
kill -0 <PID>       # Force stop (last resort)

# 4. 🌐 NETWORK VERIFICATION
ss -tuln            # Open ports (TCP/UDP)
systemctl status ssh # Critical services
```
Diagnostic Order:
1. Processes -> 2. Resources -> 3. Network -> 4. Services

# 16. 🐛 LOGS & DEBUG
(Complementary to Journalctl)
```bash
# REAL-TIME LOGS
sudo tail -f /var/log/syslog   # General logs
sudo tail -f /var/log/auth.log # Authentications

# CHECK CRITICAL SERVICES
systemctl list-units --type=service --state=failed
systemctl --failed

# CONTINUOUS MONITORING
watch -n 2 'ps aux | head -20' # View processes every 2s
htop                           # Enhanced top (if installed)
```

- Shows only lines with "error" - and updates in real time
	- `tail -f /var/log/syslog | grep -i error`

---

# 17. 🌐 Networks & Protocols

🔍 DNS & Name Resolution
- `nslookup rtp.pt` - Find IPs of a domain
- `cat /etc/resolv.conf` - View configured DNS servers
- `sudo systemd-resolve --flush-caches` - Clear DNS cache

📊 TCP Sessions & Netstat
- `netstat -tunap | grep tcp` - View all TCP sessions
- `ss -tunap` - Modern alternative to netstat
- `netstat -tunap | grep [IP]` - Filter sessions by specific IP

🎯 TCP Connection States
- LISTEN: Service listening for new connections
- ESTABLISHED: Active connection in communication
- TIME_WAIT: Connection closed, in cleanup period
- CLOSE_WAIT: Waits for local application to close connection

📊 Session Counting
- `sudo netstat -tunap | grep -c ESTABLISHED` - Count established sessions
- `ss -tunap state established | wc -l` - Alternative with ss
- `netstat -tunap | grep tcp | awk '{print $6}' | sort | uniq -c` - Count by state

📡 Traffic Capture & Analysis
- `sudo wireshark` - Initialize Wireshark with privileges
- DNS Filter: `udp.port == 53`
- General TCP Filter: `tcp && ip.addr == [my_ip]`

# 18. 🖱️ Graphical Interface & Admin
```
# Graphical administrative access
nautilus admin:///path

# More stable alternatives:
sudo thunar /path      # Lightweight file manager
sudo pcmanfm /path     # Another alternative
sudo mc                # Midnight Commander (terminal)

# For hung processes:
pkill nautilus         # Kill nautilus processes
```