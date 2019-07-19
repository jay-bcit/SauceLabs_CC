#!/bin/bash -xeu
set -o nounset  # Treat unset variables as an error

# Apt cleanup.: removes dependencies from uninstalled applications.
apt autoremove
apt update

# Delete unneeded files.
rm -f /home/vagrant/*.sh
rm -f /home/vagrant/*.txt

# Zero out the rest of the free space using dd, then delete the written file.
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY

# Add `sync` so Packer doesn't quit too early, before the large file is deleted.
sync
