#!/bin/sh
apt update -y
apt upgrade -y
apt install python python-pip python-dev libffi-dev libssl-dev  -y
apt install virtualbox virtualbox-guest-additions-iso virtualbox-dkms -y
apt install libjpeg-dev zlib1g-dev swig ssdeep tcpdump mongodb volatility -y
setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump
pip install -U weasyprint==0.42.2
pip install -U cuckoo
mkdir /etc/cuckoo
chmod 750 /etc/cuckoo
cuckoo --cwd /etc/cuckoo
echo "export CUCKOO=/etc/cuckoo" >> ~/.bashrc
