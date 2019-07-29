#!/bin/bash
vboxmanage hostonlyif create
vboxmanage hostonlyif ipconfig vboxnet0 -–ip 192.168.56.1 –-netmask 255.255.255.0

mkdir /opt/cuckoos
mkdir /opt/cuckoos/shared
mkdir /opt/cuckoos/ovas

cd /opt/cuckoos/ovas
wget https://az792536.vo.msecnd.net/vms/VMBuild_20180425/VirtualBox/MSEdge/MSEdge.Win10.VirtualBox.zip
wget https://az412801.vo.msecnd.net/vhd/VMBuild_20141027/VirtualBox/IE9/Windows/IE9.Win7.For.Windows.VirtualBox.zip

cd /opt/cuckoos/shared
cp /etc/cuckoo/agent/agent.py /opt/cuckoos/shared
wget https://www.python.org/ftp/python/2.7.11/python-2.7.11.amd64.msi -O /opt/cuckoos/shared/python-2.7.11.amd64.msi
wget https://github.com/lightkeeper/lswindows-lib/raw/master/amd64/python/PIL-1.1.7.win-amd64-py2.7.exe -O /opt/cuckoos/shared/PIL-1.1.7.amd64-py2.7.exe
wget https://download-installer.cdn.mozilla.net/pub/firefox/releases/67.0.2/win32/en-US/Firefox%20Setup%2067.0.2.exe -O /opt/cuckoos/shared/firefox_setup.exe
wget https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7B3413E80F-D138-B59F-D5BB-E20EAEA63A95%7D%26lang%3Den%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dprefers%26ap%3Dx64-stable-statsdef_1%26installdataindex%3Dempty/chrome/install/ChromeStandaloneSetup64.exe -O /opt/cuckoos/shared/chrome_setup.exe

vboxmanage import Windows10.ova --vsys 0 --vmname Windows10 --cpus 1 --memory 1024 --unit 10 --disk /opt/cuckoos/Windows10.vmdk
vboxmanage modifyvm Windows10 --nic1 hostonly
vboxmanage modifyvm Windows10 --hostonlyadapter1 vboxnet0
vboxmanage sharedfolder add Windows10 --name "Shared" --hostpath /opt/cuckoos/shared --automount

vboxmanage import Windows7.ova --vsys 0 --vmname Windows7 --cpus 1 --memory 1024 --unit 10 --disk /opt/cuckoos/Windows7.vmdk
vboxmanage modifyvm Windows7 --nic1 hostonly
vboxmanage modifyvm Windows7 --hostonlyadapter1 vboxnet0
vboxmanage sharedfolder add Windows7 --name "Shared" --hostpath /opt/cuckoos/shared --automount

iptables -t nat -A POSTROUTING -o eth0 -s 192.168.56.0/24 -j MASQUERADE
iptables -P FORWARD DROP
iptables -A FORWARD -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -s 192.168.56.0/24 -j ACCEPT
iptables -A FORWARD -s 192.168.56.0/24 -d 192.168.56.0/24 -j ACCEPT
iptables -A FORWARD -j LOG
sysctl -w net.ipv4.ip_forward=1
