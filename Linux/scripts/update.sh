#!/bin/bash -xeu
set -o nounset  # Treat unset variables as an error

# Record current package lists
dpkg -l > packge_list_01.txt
echo "Last update: $(date -R)" >> packge_list_01.txt

# Check packages that needs to be updated and upgrades it
sudo apt update -y
sudo apt upgrade -y

# Record package lists after update to compare in check_list.sh
dpkg -l > packge_list_02.txt
echo "Last update: $(date -R)" >> packge_list_02.txt

# Disable daily apt unattended updates
echo 'APT::Periodic::Enable "0";' >> /etc/apt/apt.conf.d/10periodic
