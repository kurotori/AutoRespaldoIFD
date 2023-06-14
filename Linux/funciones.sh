#!/bin/bash

### Variables Auxiliares
ruta_local=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
fecha=$(date +%d-%m-%Y)
hora=$(date +%H-%M)
version=$(cat version.txt)
fecha=$(date +%d-%m-%Y)
hora=$(date +%H-%M)

#Colores del texto
#---Formatos del texto
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)	
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

#Muestra el encabezado de la interfáz de usuario
banner()
{	
	
	titulo="Respaldo Remoto Automático"
	
	clear
	printf "%1s\n" "${BRIGHT}----------------------------------------------${NORMAL}"
	printf "%1s\n" "${LIME_YELLOW}        ${titulo} ${version}${NORMAL}"
	printf "%1s\n" "${BRIGHT}-- $fecha ----------------------- $hora --${NORMAL}"
	echo ""
}

#Genera una entrada con marca de tiempo en un archivo de registro
#Parámetros: 1 - Tipo de registro, 2 - Dato del registro
registro()
{
    printf -v anio '%(%Y)T' -1
    printf -v mes '%(%m)T' -1
    printf -v dia '%(%d)T' -1
    printf -v hora '%(%H)T' -1
    printf -v minuto '%(%M)T' -1
    printf -v segundo '%(%S)T' -1

    if [ ! -d ./registros ]
    then
        mkdir ./registros
    fi

    touch ./registros/"$1_$anio-$mes-$dia.txt"
    echo "[$anio-$mes-$dia $hora:$minuto:$segundo] - $1: $2" >> ./registros/"$1_$anio-$mes-$dia.txt"
    echo "[$anio-$mes-$dia $hora:$minuto:$segundo] - $1: $2"

}

#Genera una pausa en la ejecución, esperando a que el usuario presione ENTER
espere()
{
    echo 'Presione ENTER para continuar'
    read ok
}



# Funciones de Red


#Realiza un mapeo de la red
#Parámetro 1: rango de red
mapeo()
{
    ip_l=$(nmap -sP "$1" >/dev/null && ip neigh)
    #ip_l=$(nmap -sP "$1" >/dev/null && arp -an)
    echo "$ip_l">"$ruta_local/config/lista_ips.txt"
}


#Parámetro 1: rango de red, Parámetro 2: MAC del servidor
buscar_h()
{
    mapeo "$1"
    ip_h2=$(grep -c "$2" "$ruta_local/config/lista_ips.txt")
    #echo "cant $ip_h2"

    if [ $ip_h2 -eq 1 ]
    then
        ip_h=$(grep -i "$2" "$ruta_local/config/lista_ips.txt"|awk '{print $1}'|sed 's/[()]//g')
    fi

	echo "$ip_h">"$ruta_local/config/ip_servidor.txt"
    echo "$ip_h"
}


#Determina el rango de la red local
#Parámetro 1: interfáz de red
rango_red()
{
    #ip_local=$(ip addr |sed -e 's/^[ \t]*//'| grep -e "inet[^6]"|grep -v 'vboxnet0'|cut -d" " -f2|grep -v '127.0.0.1')
    ip_local=$(ip a list $1|sed -e 's/^[ \t]*//'|grep -e "inet[^6]"|cut -d" " -f2)
    ip_parte1=$(echo "$ip_local"|cut -d"." -f1,2,3)
    ip_parte2=$(echo "$ip_local"|cut -d"/" -f2)
    ip_rango="$ip_parte1.0/$ip_parte2"
    echo "$ip_rango"
}

#Permite obtener un listado de las interfaces del sistema
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

#