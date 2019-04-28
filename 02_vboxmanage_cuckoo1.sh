#!/bin/sh
mkdir /opt/cuckoos
mkdir /opt/cuckoos/shared
vboxmanage createvm --name "cuckoo1" --ostype Windows10_64 --register
vboxmanage modifyvm "cuckoo1" --memory 1024 --acpi on --boot1 dvd --nic1 nat
vboxmanage createhd --filename "/opt/cuckoos/cuckoo1/cuckoo1-hdd1.vdi" --size 18000
vboxmanage storagectl "cuckoo1" --name "SATA Controller" --add sata --controller IntelAHCI
vboxmanage storageattach "cuckoo1" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "/opt/cuckoos/cuckoo1/cuckoo1-hdd1.vdi"
vboxmanage storageattach "cuckoo1" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium host:/dev/sr0 --passthrough on
vboxmanage hostonlyif create
vboxmanage modifyvm "cuckoo1" --nic1 hostonly
vboxmanage modifyvm "cuckoo1" --hostonlyadapter1 vboxnet0
vboxmanage sharedfolder add "cuckoo1" --name "Shared" --hostpath /opt/cuckoos/shared --automount
cp /etc/cuckoo/agent/agent.py /opt/cuckoos/shared
wget https://www.python.org/ftp/python/2.7.11/python-2.7.11.amd64.msi -O /opt/cuckoos/shared/python-2.7.11.amd64.msi
wget http://effbot.org/media/downloads/PIL-1.1.7.win32-py2.7.exe -O /opt/cuckoos/shared/PIL-1.1.7.win32-py2.7.exe
