#!/bin/sh
mkdir /opt/cuckoos
mkdir /opt/cuckoos/shared
echo Enter the name of this cuckoo machine:
read cuckooname
vboxmanage createvm --name "${cuckooname}" --ostype Windows10_64 --register
vboxmanage modifyvm "${cuckooname}" --memory 1024 --acpi on --boot1 dvd --nic1 nat
vboxmanage createhd --filename "/opt/cuckoos/${cuckooname}/${cuckooname}-hdd1.vdi" --size 50000
vboxmanage storagectl "${cuckooname}" --name "SATA Controller" --add sata --controller IntelAHCI
vboxmanage storageattach "${cuckooname}" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "/opt/cuckoos/${cuckooname}/${cuckooname}-hdd1.vdi"
vboxmanage storageattach "${cuckooname}" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium host:/dev/sr0 --passthrough on
vboxmanage hostonlyif create
vboxmanage hostonlyif ipconfig vboxnet0 -–ip 192.168.56.1 –-netmask 255.255.255.0
vboxmanage modifyvm "${cuckooname}" --nic1 hostonly
vboxmanage modifyvm "${cuckooname}" --hostonlyadapter1 vboxnet0
vboxmanage sharedfolder add "${cuckooname}" --name "Shared" --hostpath /opt/cuckoos/shared --automount
cp /etc/cuckoo/agent/agent.py /opt/cuckoos/shared
wget https://www.python.org/ftp/python/2.7.11/python-2.7.11.amd64.msi -O /opt/cuckoos/shared/python-2.7.11.amd64.msi
wget https://github.com/lightkeeper/lswindows-lib/raw/master/amd64/python/PIL-1.1.7.win-amd64-py2.7.exe -O /opt/cuckoos/shared/PIL-1.1.7.amd64-py2.7.exe
echo "Set-ExecutionPolicy Unrestricted" >> /opt/cuckoos/shared/install_flarevm.ps1
echo ". { iwr -useb http://boxstarter.org/bootstrapper.ps1 } | iex; get-boxstarter -Force" >> /opt/cuckoos/shared/install_flarevm.ps1
echo "Install-BoxstarterPackage -PackageName https://raw.githubusercontent.com/fireeye/flare-vm/master/install.ps1" >> /opt/cuckoos/shared/install_flarevm.ps1
