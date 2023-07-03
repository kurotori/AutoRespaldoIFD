#!/bin/bash

source "./funciones.sh"

registro "ERROR" "No se pudo encontrar al servidor de respaldos." "$ruta_local/registros"

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
