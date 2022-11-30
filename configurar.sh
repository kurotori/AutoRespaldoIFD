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

if [ ! -d ./config ]
then
	mkdir ./config
fi

sleep 1
echo "		... Listo"

echo "2 - Generando ID Única del Sistema"
if [ ! -a ./config/ID.txt ]
then
    touch ./config/ID.txt
    uuid=$(uuidgen)
    echo "$uuid" > ./config/ID.txt
fi
echo "		... Listo"
sleep 2

seleccion=0

while [ "$seleccion" -eq 0 ]; do
    bash banner.sh
    echo "3 - Registrando equipo con el servidor de respaldos"
    echo ""

    echo "      Por favor indique la interfáz de red a usar:"

    #Obteniendo interfaces de red
    interfaces=()
    for dato in $(ip address | grep "^[0-9].*" | cut -d ":" -f 2)
    do 
        interfaces+=("$dato")
    done

    #Listando interfaces de red
    for i in "${!interfaces[@]}"
    do
        num=$((i+1))
        echo "$num - ${interfaces[$i]}"
    done

    num_interfaces=${#interfaces[@]}

    read -r seleccion
    seleccion=$((seleccion-1))

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
    esac
    sleep 2

   

    echo "${interfaces[$seleccion]}" > ./config/interfaz.txt
    echo "Se ha seleccionado la "

done






echo "		Por favor indique la dirección MAC del servidor:"
echo "		(formato: xx:xx:xx:xx:xx:xx)"

read -r mac_disp
echo "$mac_disp" > ./config/dispositivo.txt

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









