#!/bin/bash
echo "Mount Windows installation media to the Ubuntu operating system. Press any key after drive has mounted."
read
vboxmanage startvm "cuckoo1"
echo "Install and configure your Cuckoo VM to a ready state. Press any key to suspend and snapshot."
read
vboxmanage snapshot "cuckoo1" take "snap_clean-state" --pause
vboxmanage controlvm "cuckoo1" poweroff
vboxmanage snapshot "cuckoo1" restorecurrent
