#!/bin/bash
vboxmanage list vms
echo -n "Enter name of VM [$vm] > "
read vmname
vboxmanage startvm $(vmname)

echo vboxmanage snapshot "cuckoo1" take "snap_clean-state" --pause
echo vboxmanage controlvm "cuckoo1" poweroff
echo vboxmanage snapshot "cuckoo1" restorecurrent
