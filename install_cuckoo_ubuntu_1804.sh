#!/bin/sh

# Install dependancies
sudo apt update -y
sudo apt upgrade -y
sudo apt install python3 python3-pip python3-dev python python-pip libffi-dev libssl-dev  -y
sudo apt install virtualbox virtualbox-guest-additions-iso virtualbox-dkms -y
sudo apt install libjpeg-dev zlib1g-dev swig ssdeep tcpdump mongodb volatility -y
sudo apt install unzip -y

# Allow tcpdump to be run
sudo setcap cap_net_raw,cap_net_admin=eip /usr/sbin/tcpdump

# Configure memory and file limits
echo 'fs.file-max = 100000' | sudo tee -a /etc/sysctl.conf
sudo sysctl -w fs.file-max=100000
sudo sysctl -p
echo '*         hard    nofile      500000' | sudo tee -a /etc/security/limits.conf
echo '*         soft    nofile      500000' | sudo tee -a /etc/security/limits.conf

# Create OPT directory
mkdir /opt/cuckoos
mkdir /opt/cuckoos/shared
mkdir /opt/cuckoos/ovas

# Download Windows Virtual Machines
wget -O /opt/cuckoos/ovas/Windows10.zip https://az792536.vo.msecnd.net/vms/VMBuild_20190311/VirtualBox/MSEdge/MSEdge.Win10.VirtualBox.zip
unzip /opt/cuckoos/ovas/Windows10.zip -d /opt/cuckoos/ovas/
mv /opt/cuckoos/ovas/MSEdge\ -\ Win10.ova /opt/cuckoos/ovas/Windows10.ova
rm -f /opt/cuckoos/ovas/Windows10.zip

# Download Shared files for Analysis VMs
wget https://www.python.org/ftp/python/2.7.11/python-2.7.11.amd64.msi -O /opt/cuckoos/shared/python-2.7.11.amd64.msi
wget https://github.com/lightkeeper/lswindows-lib/raw/master/amd64/python/PIL-1.1.7.win-amd64-py2.7.exe -O /opt/cuckoos/shared/PIL-1.1.7.amd64-py2.7.exe
wget https://patchmypc.com/freeupdater/PatchMyPC.exe -O /opt/cuckoos/shared/PatchMyPC.exe

# Configure network interfaces and IPTables
vboxmanage hostonlyif create
vboxmanage hostonlyif ipconfig vboxnet0 --ip 192.168.56.1 --netmask 255.255.255.0
NETWORKINTERFACE = $(ip link | awk -F: '$0 !~ "lo|vir|wl|^[^0-9]"{print $2;getline}')
sudo iptables -t nat -A POSTROUTING -o "$NETWORKINTERFACE" -s 192.168.56.0/24 -j MASQUERADE
sudo iptables -P FORWARD DROP
sudo iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -s 192.168.56.0/24 -j ACCEPT
sudo iptables -A FORWARD -s 192.168.56.0/24 -d 192.168.56.0/24 -j ACCEPT
sudo iptables -A FORWARD -j LOG
sudo iptables-save > /etc/network/iptables.rules
sysctl -w net.ipv4.ip_forward=1
sudo echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

# Create Analysis VM
vboxmanage import /opt/cuckoos/ovas/Windows10.ova --vsys 0 --vmname Windows10 --cpus 2 --memory 4096 --unit 10 --disk /opt/cuckoos/Windows10.vmdk
vboxmanage modifyvm Windows10 --nic1 hostonly
vboxmanage modifyvm Windows10 --hostonlyadapter1 vboxnet0
vboxmanage sharedfolder add Windows10 --name "Shared" --hostpath /opt/cuckoos/shared --automount

# Install Cuckoo
sudo pip3 install -U weasyprint==0.42.2
sudo pip2 install -U pyrsistent==0.16.1
sudo pip2 install -U cryptography==3.2.0
sudo pip2 install -U cuckoo
sudo mkdir /etc/cuckoo
sudo chmod 750 /etc/cuckoo
sudo chown -R $(whoami):$(whoami) /etc/cuckoo
echo "export CUCKOO=/etc/cuckoo" >> ~/.bashrc
export CUCKOO=/etc/cuckoo
cuckoo --cwd /etc/cuckoo
cuckoo community
