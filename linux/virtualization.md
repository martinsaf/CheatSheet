# 🖥️ Virtualization & Guest Additions

## 🔧 Common Problem: Drag & Drop Not Working
**Typical Error:** `"Dragging from guest to host not supported by guest"`

## 🛠️ Step-by-Step Solution:

```bash
# 1. Update system
sudo apt update 
sudo apt upgrade -y

# 2. In VirtualBox menu: Devices → Insert Guest Additions CD image

# 3. Install from CD (runs automatically)
# - Click "Yes" when prompted

# 4. Reboot
sudo reboot
```

## ⚠️ If Automatic Installation Fails:
```bash
# Install dependencies manually
sudo apt install -y build-essential dkms linux-headers-$(uname -r)

# Mount and install manually
sudo mkdir -p /mnt/cdrom
sudo mount /dev/sr0 /mnt/cdrom
cd /mnt/cdrom
sudo ./VBoxLinuxAdditions.run
sudo reboot
```

## ✅ Installation Verification:
```bash
lsmod | grep vbox                 # Check loaded modules
systemctl status vboxadd-service  # Check service status
```

## 🔧 Additional Configuration:
- **VirtualBox Settings** → **General** → **Advanced** → **Drag & Drop: Bidirectional**
- **Devices** → **Drag & Drop** → **Bidirectional**

## 🐛 Troubleshooting Commands:
```bash
# Check installation logs
cat /var/log/vboxadd-install.log

# Complete reinstallation if needed
sudo apt remove --purge virtualbox-guest-* -y
sudo apt install virtualbox-guest-utils -y

# Verify kernel modules
lsmod | grep -i vbox
```

## 💡 Pro Tips:
- Always run `apt update` before `apt upgrade`
- Ensure your kernel headers match your running kernel
- Guest Additions provide better performance, shared clipboard, and seamless mouse integration
- Regular updates of Guest Additions are recommended when updating VirtualBox
