#!bin/bash -x
set -o nounset  # Treat unset variables as an error

# Firewall (ufw) configuration
## 1. Reset to defualt and enable ufw
sudo ufw --force reset
sudo ufw --force enable

## 2. Add rules: base_line
sudo ufw default deny incoming
sudo ufw default allow outgoing

## 3. Add ruels: sshd
sudo ufw allow ssh

## 4. Add ruels: vnc4server
sudo ufw allow from any to any port 5901 proto tcp


# Hardening sshd - simple_ver
## 1. Disable IPv6 for sshd + Backup original config file
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bck
sed -i "s/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/" /etc/ssh/sshd_config

## 2. Restart service: sshd
sudo systemctl restart sshd
