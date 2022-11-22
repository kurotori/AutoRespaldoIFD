#!/bin/bash
clear

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

bash ./banner.sh

if [ -d ./aux ]
then
	printf "%1s\n" "${RED}ERROR: ${YELLOW}No se encontró la carpeta auxiliar.${NORMAL}"
    echo ""
    printf "%1s\n" "${BRIGHT}Elija una opción: ${NORMAL}"
    printf "%1s\n" "${BRIGHT}1 - ${NORMAL} Reconfigurar el sistema de respaldos ${NORMAL}"
    printf "%1s\n" "${BRIGHT}2 - ${NORMAL} Restaurar el sistema desde un respaldo ${NORMAL}"

fi

if [ -s ./aux/ID.txt ]
then
	mkdir ~/.respaldos/aux
fi
