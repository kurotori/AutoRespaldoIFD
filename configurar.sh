#!/bin/bash
clear

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
banner()
{	
	t_actual=$(date +%s)
	fecha=$(date +%d-%m-%Y)
	hora=$(date +%H-%M)
	clear
	printf "%1s\n" "${BRIGHT}------------------------------------------------${NORMAL}"
	printf "%1s\n" "${LIME_YELLOW}    Sistema de Respaldos Automatizados v ${version}${NORMAL}"
    printf "%1s\n" "${LIME_YELLOW}            Configurando el sistema ${NORMAL}"
	printf "%1s\n" "${BRIGHT}--- $fecha ----------------------- $hora ---${NORMAL}"
	echo ""
	
}

#----

banner
printf "%1s\n" "${BRIGHT}------------------------------------------------${NORMAL}"

echo "1 - Creando carpetas auxiliares"

if [ ! -d ~/.respaldos ]
then
	mkdir ~/.respaldos
fi

if [ ! -d ~/.respaldos/aux ]
then
	mkdir ~/.respaldos/aux
fi

sleep 1
echo "... Listo"

echo "2 - Generando ID Única del Sistema"
if [ ! -a ~/.respaldos/aux/ID.txt ]
then
    touch ~/.respaldos/aux/ID.txt
    uuid=$(uuidgen)
    echo "$uuid" >> ~/.respaldos/aux/ID.txt
fi

sleep 1
echo "... Listo"









