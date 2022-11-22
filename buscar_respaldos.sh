#!/bin/bash
clear

if [ ! -d ./aux ]
then
	mkdir ./aux
fi

touch ./aux/lista_ips.txt
touch ./aux/tiempo_reg.txt
touch ./aux/ip_h.txt


### Variables Auxiliares
titulo="Respaldo Remoto Automático"
ubicacion=$(pwd)
config="$HOME/.respaldos"
PC_ID=$(cat $config/aux/ID.txt)
error_msg=""
t_actual=$(date +%s)
fecha=$(date +%d-%m-%Y)
hora=$(date +%H-%M)
t_reg=0
version=$(cat version.txt)
fecha_v="08_2022"

if [ -s ./aux/tiempo_reg.txt ]
then
	t_reg=$(cat ./aux/tiempo_reg.txt)
else
	t_reg=0
fi

reintentos=0


#### Funciones Auxiliares ####
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

#----


#----
#parámetro 1: rango
buscar_h()
{
	ip_l=$(nmap -sP $1 >/dev/null && arp -an)
	echo "$ip_l">./aux/lista_ips.txt
	date +%s>./aux/tiempo_reg.txt #Se registra el tiempo UNIX de la búsqueda
}


# # # # # # # # # # # # # # # 
# EJECUCIÓN
# # # # # # # # # 

while  [ $reintentos -lt 3 ]
do
    
    notify-send "$titulo" "Ubicando al servidor de respaldos en la red" -i "$ubicacion"/img/red_Freepik.png
    banner
    mac_disp=$(cat ./dispositivo.txt)
    echo "    Obteniendo los parámetros de la red..."
    echo "    Por favor espere..."
    ip_local=$(ip addr |sed -e 's/^[ \t]*//'| grep -e "inet[^6]"|grep -v 'vboxnet0'|cut -d" " -f2|grep -v '127.0.0.1')
    ip_parte1=$(echo $ip_local|cut -d"." -f1,2,3)
    ip_parte2=$(echo $ip_local|cut -d"/" -f2)
    ip_rango="$ip_parte1.0/$ip_parte2"


    ult_reg=$(expr $t_actual - $t_reg)
            banner		
		    
		    echo ""
		    banner
		    printf "%1s\n" "${WHITE}-----------------${NORMAL}"
		    printf "%1s\n" "${LIME_YELLOW}    Escaneo de Red${NORMAL}"
		    printf "%1s\n" "${WHITE}-----------------${NORMAL}"
		    echo ""
		    echo "    Rango de red local: $ip_rango"
            echo "    ID: $PC_ID"
		    echo "    Ubicando al Servidor de Respaldos: $mac_disp"

		    buscar_h "$ip_rango" & PID=$! #simulate a long process
		    echo "    Por favor espere..."
		    printf "["
		    # While process is running...
		    while kill -0 $PID 2> /dev/null; do 
			    printf  "▓"
			    sleep 1
		    done
		    printf "]"

		    echo "    Búsqueda Completa"
		    #Código de animación de espera tomado del usuario cosbor11 de stackoverflow.com
		    #Obtenido de https://stackoverflow.com/questions/12498304/using-bash-to-display-a-progress-indicator
    #------




    #ip_h1=$(cat ./aux/lista_ips.txt)
    #$(nmap -sP $ip_rango >/dev/null && arp -an)

    #Buscamos al servidor en el listado de IPs y MACs obtenidas 
    ip_h2=$(cat aux/lista_ips.txt|grep -c "$mac_disp")
    
    #$(echo "$ip_h1"|grep -c "$mac_disp")
    #echo "$ip_rango"
    #echo "$ip_h2"

    if [ $ip_h2 -eq 1 ]
    then
        #Si el servidor fue ubicado, nos aseguramos que no haya reintentos
        reintentos=3
	    echo " "
	    ip_h=$(cat ./aux/lista_ips.txt|grep "$mac_disp"|awk '{print $2}'|sed 's/[()]//g')
        notify-send "$titulo" "Servidor de respaldos ubicado en $ip_h" -i "$ubicacion"/img/red_Freepik.png
        
        banner
        printf "%1s\n" "${BRIGHT}    IP del Servidor:${NORMAL} ${ip_h} ${NORMAL}"
        printf "%1s\n" "${BRIGHT}    ID de respaldo: ${NORMAL} ${PC_ID} ${NORMAL}"
        echo "$ip_h"
    else
        banner
        printf "%1s\n" "${RED}    ERROR: No pudo ubicar el Servidor de Respaldo en la red local.${NORMAL}"
	    printf "%1s\n" "${YELLOW}    Verifique si se encuentra encendido.${NORMAL}"
        echo " "
        reintentos=$((reintentos+1))
        restantes=$((3-reintentos))

        if [ $restantes -gt 0 ]
        then
            sleep 5 & PID=$! #simulate a long process
	        echo "    Respaldo en pausa. Reintento en 1 minuto. Restan $restantes reintentos"
	        printf "["
	        # While process is running...
	        while kill -0 $PID 2> /dev/null; do 
		        printf  "▓"
		        sleep 1
	        done
	        printf "]"
            echo " "
	        echo "    ...reintentando ubicar el Servidor de Respaldos"
            sleep 2
        fi
    fi


done







