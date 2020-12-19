#!/bin/sh
sudo apt update -y
sudo apt upgrade -y
sudo apt install python3 python3-pip python3-dev libffi-dev libssl-dev  -y
sudo apt install virtualbox virtualbox-guest-additions-iso virtualbox-dkms -y
sudo apt install libjpeg-dev zlib1g-dev swig ssdeep tcpdump mongodb volatility -y
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

echo 'fs.file-max = 100000' | sudo tee -a /etc/sysctl.conf
sudo sysctl -w fs.file-max=100000

sudo pip3 install -U weasyprint==0.42.2
sudo pip2 install -U pysistent==0.16.1
sudo pip2 install -U cryptography==3.2.0
sudo pip2 install -U cuckoo
sudo mkdir /etc/cuckoo
sudo chmod 750 /etc/cuckoo
sudo chown -R $(whoami):$(whoami) /etc/cuckoo
echo "export CUCKOO=/etc/cuckoo" >> ~/.bashrc
export CUCKOO=/etc/cuckoo
cuckoo --cwd /etc/cuckoo
cuckoo community
