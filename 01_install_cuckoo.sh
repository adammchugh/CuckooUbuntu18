#!/bin/sh
sudo apt update -y
sudo apt upgrade -y
sudo apt install python python-pip python-dev libffi-dev libssl-dev  -y
sudo apt install virtualbox virtualbox-guest-additions-iso virtualbox-dkms -y
sudo apt install libjpeg-dev zlib1g-dev swig ssdeep tcpdump mongodb volatility -y
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump
sudo pip install -U weasyprint==0.42.2
sudo pip install -U cuckoo
sudo mkdir /etc/cuckoo
sudo chmod 750 /etc/cuckoo
sudo chmod -R cuckoo:cuckoo /etc/cuckoo
echo "export CUCKOO=/etc/cuckoo" >> ~/.bashrc
export CUCKOO=/etc/cuckoo
cuckoo --cwd /etc/cuckoo
cuckoo community
