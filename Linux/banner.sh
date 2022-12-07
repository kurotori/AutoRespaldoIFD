#!/bin/bash
clear

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
	printf "%1s\n" "${BRIGHT}----------------------------------------------${NORMAL}"
	printf "%1s\n" "${LIME_YELLOW}        ${titulo} ${version}${NORMAL}"
	printf "%1s\n" "${BRIGHT}-- $fecha ----------------------- $hora --${NORMAL}"
	echo ""
}

banner