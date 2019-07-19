#!/bin/bash -x
set -o nounset  # Treat unset variables as an error

# Variables
declare user_name=vagrant
declare email_addr=__EMAIL_ADDR__

declare servie_name_ssh=sshd
declare servie_name_vnc=Xvnc4
declare port_num_ssh=22
declare port_num_vnc=5901
declare time_zone=Etc/UTC
declare mail_hostname=$(hostname -f)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #

# 1. Is service running? : sshd
ps cax | grep $servie_name_ssh > /dev/null
if [ $? -eq 0 ]; then
  echo "[PASS] Service is running : $servie_name_ssh"
  mailx -s "[PASS] Service is running : $servie_name_ssh :: $mail_hostname" $email_addr < /dev/null
else
  echo "[FAIL] Service is not running : $servie_name_ssh"
  mailx -s "[FAIL] Service is not running : $servie_name_ssh :: $mail_hostname" $email_addr < /dev/null
fi


# 2. Is service running? : vnc4server
ps cax | grep $servie_name_vnc > /dev/null
if [ $? -eq 0 ]; then
  echo "[PASS] Service is running : $servie_name_vnc"
  mailx -s "[PASS] Service is running : $servie_name_vnc :: $mail_hostname" $email_addr < /dev/null
else
  echo "[FAIL] Service is not running : $servie_name_vnc"
  mailx -s "[FAIL] Service is not running : $servie_name_vnc :: $mail_hostname" $email_addr< /dev/null
fi



# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #




# 3. Is port opend? : sshd
ss -lnt | grep $port_num_ssh > /dev/null
if [ $? -eq 0 ]; then
  echo "[PASS] Port opend and listning: $port_num_ssh"
  mailx -s "[PASS] Port opend and listning: $port_num_ssh :: $mail_hostname" $email_addr < /dev/null
else
  echo "[FAIL] Port is not opend : $port_num_ssh"
  mailx -s "[FAIL] Port is not opend : $port_num_ssh :: $mail_hostname" $email_addr < /dev/null
fi



# 4. Is port opend? : vnc4server
ss -lnt | grep $port_num_vnc > /dev/null
if [ $? -eq 0 ]; then
  echo "[PASS] Port opend and listning: $port_num_vnc"
  mailx -s "[PASS] Port opend and listning: $port_num_vnc :: $mail_hostname" $email_addr < /dev/null
else
  echo "[FAIL] Port is not opend: $port_num_vnc"
  mailx -s "[FAIL] Port is not opend : $port_num_vnc :: $mail_hostname" $email_addr < /dev/null
fi




# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #




# 5. New user added and sudoers?
cat /etc/passwd | grep $user_name > /dev/null && sudo cat /etc/sudoers | grep $user_name > /dev/null
if [ $? -eq 0 ]; then
  echo "[PASS] User exist and has been added to sudoers: $user_name"
  mailx -s "[PASS] User exist and has been added to sudoers: $user_name :: $mail_hostname" $email_addr < /dev/null
else
  echo "[FAIL] User does not exist"
  mailx -s "[FAIL] User does not exist: $user_name :: $mail_hostname" $email_addr < /dev/null
fi




# 6. Does user has home directory?
ls /home | grep $user_name > /dev/null
if [ $? -eq 0 ]; then
  echo "[PASS] User home directory exists: Path => $(pwd /home/$user_name)"
  mailx -s "[PASS] User home directory exists: Path => $(pwd /home/$user_name) :: $mail_hostname" $email_addr < /dev/null
else
  echo "[FAIL] User home directory does not exist"
  mailx -s "[FAIL] User home directory does not exist: Username => $user_name :: $mail_hostname" $email_addr < /dev/null
fi


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #




# 7. Is timezone set by UTC?
if [[ $(cat /etc/timezone) && $(timedatectl | grep "Time zone" | cut -d " " -f 19) == "$time_zone" ]]; then
  if [ $? -eq 0 ]; then
    echo "[PASS] Timezone has been set by : $time_zone"
    mailx -s "[PASS] Timezone has been set by : $time_zone :: $mail_hostname" $email_addr < /dev/null
  else
    echo "[FAIL] Timezone has not been set"
    mailx -s "[FAIL] Timezone has not been set : Current Time_Zone:  $(timedatectl | grep "Time zone" | cut -d " " -f 19) :: $mail_hostname" $email_addr < /dev/null
  fi
fi



# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - #




# 8. Compare package lists to see system software is up to date
diff packge_list_01.txt packge_list_02.txt | grep "> ii" > /dev/null
if [ $? -eq 0 ]; then
  echo "[SYSTEM] List of packages that has been added / updated
$(diff packge_list_01.txt packge_list_02.txt)"
  diff packge_list_01.txt packge_list_02.txt > result.txt
  mailx -s "[SYSTEM] List of packages that has been added / updated :: $mail_hostname" $email_addr < result.txt
else
  echo "[SYSTEM] No packages has been changed"
  mailx -s "[SYSTEM] No packages has been changed :: $mail_hostname" $email_addr < /dev/null

fi
