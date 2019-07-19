#!bin/bash -x
set -o nounset  # Treat unset variables as an error

declare mail_hostname=$(hostname -f)

# INstall postfix
sudo debconf-set-selections <<< "postfix postfix/mailname string $mail_hostname"
sudo debconf-set-selections <<< "postfix postfix/main_mailer_type string 'Internet Site'"
sudo apt-get install mailutils -y


# Set postfix as send-only server
#sed -i "s/inet_interfaces = all/inet_interfaces = loopback-only/" /etc/postfix/main.cf
echo << EOF >> /etc/postfix/main.cf
inet_interfaces = loopback-only
myhostname=$mail_hostname
EOF

# Reload modified configuration
sudo systemctl restart postfix

# Enable postfix
sudo systemctl enable postfix
