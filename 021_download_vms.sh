#!/bin/bash
wget -O /opt/cuckoos/ovas/Windows10.zip https://az792536.vo.msecnd.net/vms/VMBuild_20190311/VirtualBox/MSEdge/MSEdge.Win10.VirtualBox.zip
unzip /opt/cuckoos/ovas/Windows10.zip -d /opt/cuckoos/ovas/
rm -f /opt/cuckoos/ovas/Windows10.zip
