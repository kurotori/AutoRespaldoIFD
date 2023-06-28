#!/bin/bash

source "./funciones.sh"
echo "algo"
buscar_h "172.16.2.0/24" "00:25:22:db:0d:d2"
coso=$(gio mount -l|grep -c -e "smb://172.16.2.128/respaldos")

if [ $coso -gt 0 ]; then
    echo "hay"
else
    
fi







# source ./red.sh

# rango=$(rango_red)
# coso=$(buscar_h "$rango" "00:25:22:db:0d:d2")
# echo "$coso"







# for host in `cat ip_adds2`
# do
# echo "Hostname:" $host
# sudo ssh -t -o BatchMode=yes -o ConnectTimeout=5 $host 'echo IP: `hostname -i`;read junk total used free shared buffers cached junk < <(free -g  | grep ^Mem);echo Memory: $total GiB'
# echo -e "\n"
# done
