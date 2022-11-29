#!/bin/bash

#----
#Parámetro 1: rango de red
mapeo()
{
    ip_l=$(nmap -sP $1 >/dev/null && arp -an)
    echo "$ip_l">./aux/lista_ips.txt
}


#Parámetro 1: rango de red, Parámetro 2 MAC del servidor
buscar_h()
{
    mapeo "$1"
    ip_h2=$(grep -c "$2" ./aux/lista_ips.txt)
    #echo "cant $ip_h2"

    if [ $ip_h2 -eq 1 ]
    then
        ip_h=$(grep "$2" ./aux/lista_ips.txt|awk '{print $2}'|sed 's/[()]//g')
    fi

	echo "$ip_h"
}



rango_red()
{
    ip_local=$(ip addr |sed -e 's/^[ \t]*//'| grep -e "inet[^6]"|grep -v 'vboxnet0'|cut -d" " -f2|grep -v '127.0.0.1')
    ip_parte1=$(echo "$ip_local"|cut -d"." -f1,2,3)
    ip_parte2=$(echo "$ip_local"|cut -d"/" -f2)
    ip_rango="$ip_parte1.0/$ip_parte2"
    echo "$ip_rango"
}


listar_interfaces()
{
    interfaces=()
    for dato in $(ip address | grep "^[0-9].*" | cut -d ":" -f 2)
    do 
        interfaces+=("$dato") 
    done

    for i in "${!interfaces[@]}"
    do
        echo "$i - ${interfaces[$i]}"
    done
}

listar_interfaces

#echo "${coso[@]}"
