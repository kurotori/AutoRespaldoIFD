#!/bin/bash
algo=0

while [ "${algo}" -ne 100 ]; do
    clear
    echo 'Ingrese un número'

    read -r algo

    algo=$((algo-1))

    lista=("coso" "cosa" "cose")
    num=${#lista[@]}


    case  1:${algo:--} in
    (1:*[!0-9]*|1:0*[89]*)
    ! echo "${algo} no es un valor válido"; algo=0
    ;;
    ($((algo<=num))*)
        item=${lista[$algo]}
        echo "Seleccionó $item"
        
    ;;
    ($((algo>num))*)
        echo "${algo} no es un valor válido"
    ;;
    *)
       echo "${algo} no es un valor válido"
       algo=0
    ;;
    esac
sleep 2
done











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
