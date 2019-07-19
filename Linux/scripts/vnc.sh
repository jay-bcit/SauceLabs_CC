#!bin/bash -x
set -o nounset  # Treat unset variables as an error

declare vnc_pass="P@ssw0rd"
declare vnc_emulator="/etc/alternatives/x-terminal-emulator"
declare target_emulator="/usr/bin/xfce4-terminal.wrapper"

# install vncserver, xfce desktop manager
sudo apt-get install vnc4server xfce4 xfce4-goodies -y


# Change the symlink to default emulator as xfce4-terminal.wrapper
if [[ -s $vnc_emulator ]]; then
  if [[ $(ls $vnc_emulator | cut -d " " -f 11) != "$target_emulator*" ]]; then
    sudo unlink $vnc_emulator && sudo ln -s $target_emulator $vnc_emulator
    echo "[SYSTEM] - CHANGED - Current emuloator for VNC : $(ls $vnc_emulator | cut -d " " -f 11)"
  else
    echo "[SYSTEM] - NO_CHANGED - Current emuloator for VNC : $(ls $vnc_emulator | cut -d " " -f 11)"
  fi
else
  echo "[SYSTEM] - NULL - Current emulator has no symlink to the wrapper"
fi


# Configure VNC password
sudo umask 0077                                                 # use safe default permissions
sudo mkdir -p "/root/.vnc"                                      # create config directory
sudo chmod go-rwx "/root/.vnc"                                  # enforce safe permissions
sudo printf "$vnc_pass\n$vnc_pass\n\n" | sudo vncpasswd         # generate and write a password
#vncpasswd -f <<<"$vnc_pass" >"$HOME/.vnc/passwd"


# Create xstartup file
sudo cat <<EOF > /root/.vnc/xstartup
#!/bin/bash
startxfce4 &
EOF
sudo chmod +x /root/.vnc/xstartup


# Create script for crontab to start vnc4server at boot
sudo umask 0077                                                 # use safe default permissions
sudo mkdir -p "/root/crontabs"                                  # create config directory
sudo chmod go-rwx "/root/crontabs"                              # enforce safe permissions
sudo cat <<EOF > /root/crontabs/cron_vnc.sh
#!/bin/bash
sudo printf "$vnc_pass\n$vnc_pass\n\n" | sudo /usr/bin/vnc4server
EOF
sudo chmod +x /root/crontabs/cron_vnc.sh

# Add script to crontabs
sudo echo "@reboot root /root/crontabs/cron_vnc.sh" > /etc/cron.d/cron_vnc





# Run vncserver
sudo vnc4server
