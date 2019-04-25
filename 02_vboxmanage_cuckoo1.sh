#!/bin/sh
vboxmanage createvm --name "cuckoo1" --ostype Windows10_64 --register
vboxmanage modifyvm "cuckoo1" --memory 1024 --acpi on --boot1 dvd --nic1 nat
vboxmanage createhd --filename "/path/to/VirtualBox\ VMs/cuckoo1/cuckoo1-hdd1.vdi" --size 18000
vboxmanage storagectl "cuckoo1" --name "SATA Controller" --add sata --controller IntelAHCI
vboxmanage storageattach "cuckoo1" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "/path/to/VirtualBox\ VMs/cuckoo1/cuckoo1-hdd1.vdi"
vboxmanage storageattach "cuckoo1" --storagectl "SATA Controller" --port 1 --device 0 --type dvddrive --medium /home/mekhalleh/Utils/images.iso/sw_dvd5_win_pro_n_7w_sp1_64bit_english_-2_mlf_x17-59641.iso
vboxmanage hostonlyif create
vboxmanage modifyvm "cuckoo1" --nic1 hostonly
vboxmanage modifyvm "cuckoo1" --hostonlyadapter1 vboxnet0
vboxmanage sharedfolder add "cuckoo1" --name "Shared" --hostpath /path/to/VirtualBox\ VMs/shared --automount
cp /etc/cuckoo/agent/agent.py /path/to/VirtualBox\Vms/shared
# https://www.python.org/ftp/python/2.7.11/python-2.7.11.amd64.msi
# http://effbot.org/media/downloads/PIL-1.1.7.win32-py2.7.exe
