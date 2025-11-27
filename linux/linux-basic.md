# 📘 Basic Linux

---

# 1. 🖥️ System & Information

- `cat /etc/os-release` — Check OS version
- `uname -a` — Check kernel version
- `apt update && apt upgrade` — Update system
- `<command> | ccze -A` — Colorize output

---

# 2. 📑 Journalctl (Systemd Logs)

### Main Commands

- `journalctl` — View all logs
- `journalctl -u <service>` — Logs for a specific service (e.g., `ssh.service`)
- `journalctl -p err..alert` — Filter by severity
- `journalctl --since "1 hour ago"`
- `journalctl --since yesterday --until "today 09:00"`
- `journalctl -f` — Follow logs in real time
- `journalctl -b` — Logs from the last boot
- `journalctl /usr/bin/sshd` — Logs from a specific binary

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

### Groups

- `sudo addgroup group`
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
#### Persistence (netplan)
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
systemctl ssh state # Critical services
```
Diagnostic Order:
1. Processes -> 2. Resources -> 3. Network -> 4. Services

---

# 16. 🐛 LOGS & DEBUG
(Complementary to Journactl)
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
