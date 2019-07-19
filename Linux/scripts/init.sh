#!/bin/bash -x
set -o nounset  # Treat unset variables as an error

declare user_name=vagrant

# Add vagrant user to sudoers
echo "$user_name        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers
sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers
