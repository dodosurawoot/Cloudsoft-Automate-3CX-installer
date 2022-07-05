#!bin/bash

#Ignore all errors and warnings
set -e 

#Disable Selinux Temporarily
SELINUX_STATUS=$(getenforce)
if [ "$SELINUX_STATUS" != "Disabled" ]; then
    echo "Disabling SELINUX Temporarily"
    setenforce 0
else
  echo "SELINUX it is already disabled"
fi

#Disable SeLinux Permanently
sefile="/etc/selinux/config"
if [ -e $sefile ]
then
  sed -i 's/^SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
fi

#Update and inastall all the required packages
apt-get update -y
apt-get upgrade -y

#auto create file and fill test in file
echo /etc/apt/sources.list.d/3cxpbx.list 
echo deb http://downloads-global.3cx.com/downloads/debian buster main >> /etc/apt/sources.list.d/3cxpbx.list

echo /etc/apt/sources.list.d/3cxpbx-testing.list
echo deb  http://downloads-global.3cx.com/downloads/debian buster-testing main >> /etc/apt/sources.list.d/3cxpbx-testing.list

#auto install gnupg and apt-key
apt install gnupg -y
wget http://downloads-global.3cx.com/downloads/3cxpbx/public.key
apt-key add public.key
echo "deb http://downloads-global.3cx.com/downloads/debian buster main" | tee /etc/apt/sources.list.d/3cxpbx.list

#Update and inastall all the required packages
apt-get update -y
apt-get upgrade -y

#remove locales
apt-get purge locales -y

#install locales package and select the locale for encoding UTF-8
apt-get install locales -y
locale-gen en_US.UTF-8

#Remove all file in directory /etc/profile.d/
rm -rf /etc/profile.d/*

#Dowload SSH welcome banner and set the banner
wget -P /etc/profile.d/ https://raw.githubusercontent.com/dodosurawoot/Cloudsoft-Banner/main/banner.sh
chmod 644 /etc/profile.d/banner.sh

#Edit sshd_config to allow ssh banner
sed -i 's/^#Banner.*/Banner \/etc\/profile.d\/banner.sh/g' /etc/ssh/sshd_config

#Enable PrintMotd
sed -i 's/^PrintMotd.*/PrintMotd no/g' /etc/ssh/sshd_config

#Restart sshd
systemctl restart sshd

#Disable Pre-authentication banner message from server
sed -i 's/^#PreAuthenticationBanner.*/PreAuthenticationBanner none/g' /etc/ssh/sshd_config

#Update and inastall all the required packages
apt-get update -y
apt-get upgrade -y

#install 3CXPBX
apt autoremove -y
apt-get install 3cxpbx -y
