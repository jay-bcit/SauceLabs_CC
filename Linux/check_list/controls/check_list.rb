#############################################
# 0. Is package installed? : vnc4server
describe package('vnc4server'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end


#############################################
# 1. Is service running? : sshd
# 2. Is service running? : vnc4server
describe service('ufw') do
  it { should be_enabled }
  it { should be_running }
end

describe service('sshd') do
  it { should be_enabled }
  it { should be_running }
end
describe processes("Xvnc4") do
  its('users') { should eq ['root'] }
end


###########################################
# 3. Is port opend? : sshd
# 4. Is port opend? : vnc4server
describe port(22) do
  it { should be_listening }
end
describe port(5901) do
  it { should be_listening }
end


###########################################
# 5. New user added and sudoers?
# 6. Does user has home directory?
describe user('vagrant') do
  it { should exist }
  its('uid') { should eq 900 }
  its('groups') { should eq ['vagrant', 'sudo']}
  its('home') { should eq '/home/vagrant' }
  its('shell') { should eq '/bin/bash' }
end



###########################################
# 7. Is timezone set by UTC?
describe command('cat /etc/timezone && timedatectl | grep "Time zone" | cut -d " " -f 19') do
   its('stdout') { should match 'Etc/UTC' }
end


###########################################
# 8. Is vnc emulator has correct symlink?
describe file('/etc/alternatives/x-terminal-emulator') do
    it { should exist }
    it { should be_symlink }
    it { should be_file }
    it { should be_linked_to '/usr/bin/xfce4-terminal.wrapper' }
end



###########################################
# 9. Is cron_vnc.sh in /etc/cron.d/cron_vnc?
describe file('/etc/cron.d/cron_vnc') do
    it { should exist }
    its('content') { should match( '@reboot root /root/crontabs/cron_vnc.sh' ) }
end
