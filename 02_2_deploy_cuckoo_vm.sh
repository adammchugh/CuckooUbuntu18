#!/bin/bash

sudo vboxmanage import /opt/cuckoos/ovas/Windows10.ova --vsys 0 --vmname Windows10 --cpus 1 --memory 1024 --unit 10 --disk /opt/cuckoos/Windows10.vmdk
vboxmanage modifyvm Windows10 --nic1 hostonly
vboxmanage modifyvm Windows10 --hostonlyadapter1 vboxnet0
vboxmanage sharedfolder add Windows10 --name "Shared" --hostpath /opt/cuckoos/shared --automount
