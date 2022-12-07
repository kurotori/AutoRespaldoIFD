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

# Se chequea la existencia de la carpeta 'aux' conteniendo los datos de configuración
if [ -d ./aux ]
then
   opcion=0

   while [ $opcion -ne 5 ]; do
        bash ./banner.sh

        # Cambio de color de fondo tomado de: https://askubuntu.com/questions/558280/changing-colour-of-text-and-background-of-terminal
        printf "\e[48;5;255m;%1s\n" "    ${RED}ERROR: No se encontró la carpeta auxiliar.      ${NORMAL}"
        echo ""
        printf "%1s\n" "    ${BRIGHT}Elija una opción para continuar: ${NORMAL}"
        echo ' '
        printf "%1s\n" "        ${BRIGHT}1 - ${NORMAL} Reconfigurar el sistema de respaldos ${NORMAL}"
        printf "%1s\n" "        ${BRIGHT}2 - ${NORMAL} Restaurar el sistema desde un respaldo ${NORMAL}"
        printf "%1s\n" "        ${BRIGHT}X - ${NORMAL} Cancelar y Salir ${NORMAL}"

        read -r opcion

        case $opcion in
            1)
                echo "reconfigurar"
                sleep 2s
                bash configurar.sh
                opcion=5
            ;;
            2)
                echo "restaurar"
                sleep 2s
                opcion=5
            ;;
            [xX])
               echo ' '
                opcion=5
               
            ;;
            *)
               echo ' '
               
                printf "\e[48;5;255m;%1s\n" "    ${RED}ERROR: Opción no válida.      ${NORMAL}"
                sleep 2s
                opcion=0
            ;;
        esac
   done
   

	
   

fi
