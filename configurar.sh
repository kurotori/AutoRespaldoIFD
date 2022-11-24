#!/bin/bash
clear

source ./red.sh

version=$(cat version.txt)

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

bash banner.sh
printf "%1s\n" "${LIME_YELLOW}            Configurando el sistema ${NORMAL}"
printf "%1s\n" "${BRIGHT}------------------------------------------------${NORMAL}"

echo "1 - Creando carpetas auxiliares"

if [ ! -d ./aux ]
then
	mkdir ./aux
fi

sleep 1
echo "		... Listo"

echo "2 - Generando ID Única del Sistema"
if [ ! -a ./aux/ID.txt ]
then
    touch ./aux/ID.txt
    uuid=$(uuidgen)
    echo "$uuid" > ./aux/ID.txt
fi
echo "		... Listo"

echo "3 - Registrando equipo con el servidor de respaldos"
echo ""
echo "		Por favor indique la dirección MAC del servidor:"
echo "		(formato: xx:xx:xx:xx:xx:xx)"

read mac_disp
echo "$mac_disp" > ./aux/dispositivo.txt

echo "		Ubicando al servidor ($mac_disp) en la red..."
echo "		Obteniendo parámetros de la red..."
rango=$(rango_red)

echo "		...Listo. Rango de red: $rango"
echo "		Escaneando la red. Por favor espere..."
ip_servidor=$(buscar_h "$rango" "$mac_disp")

echo "		...Listo. IP del servidor: $ip_servidor"

echo "		Accediendo a la carpeta de respaldos del servidor"

if [ ! -d /media/"$USER"/servidor ]
then
	sudo mkdir /media/"$USER"/servidor
fi
sudo 

sleep 1
echo "... Listo"









