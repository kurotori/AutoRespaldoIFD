#!/bin/bash
for host in `cat ip_adds2`
do
echo "Hostname:" $host
sudo ssh -t -o BatchMode=yes -o ConnectTimeout=5 $host 'echo IP: `hostname -i`;read junk total used free shared buffers cached junk < <(free -g  | grep ^Mem);echo Memory: $total GiB'
echo -e "\n"
done
