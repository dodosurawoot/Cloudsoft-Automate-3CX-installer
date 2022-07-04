#!bin/bash
#automate insallation of 3CXPBX

set -e

#Update and inastall all the required packages
apt-get update -y
apt- upgrade -y

#auto create file and fill test in file
echo /etc/apt/sources.list.d/3cxpbx.list 
echo deb http://downloads-global.3cx.com/downloads/debian buster main >> /etc/apt/sources.list.d/3cxpbx.list

echo /etc/apt/sources.list.d/3cxpbx-testing.list
echo deb http://downloads-global.3cx.com/downloads/debian/testing buster-testing main >> /etc/apt/sources.list.d/3cxpbx-testing.list

#auto install gnupg and apt-key
apt install gnupg -y
wget http://downloads-global.3cx.com/downloads/3cxpbx/public.key -y
apt-key add public.key -y
echo "deb http://downloads-global.3cx.com/downloads/debian buster main" | tee /etc/apt/sources.list.d/3cxpbx.list

#Update and inastall all the required packages
apt-get updae -y

#remove locales
apt-get purge locales -y

#install locales package and select the locale for encoding UTF-8
apt-get install locales -y
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8

#Dowload SSH welcome banner and set the banner
wget -P /etc/profile.d/ https://raw.githubusercontent.com/dodosurawoot/Cloudsoft-Banner/main/banner.sh
chmod 644 /etc/profile.d/banner.sh

#Edit sshd_config to allow ssh banner
sed -i 's/^#Banner.*/Banner \/etc\/profile.d\/banner.sh/g' /etc/ssh/sshd_config

#Restart sshd
systemctl restart sshd

#install 3CXPBX
apt auto remove -y
apt-get install 3cxpbx -y
