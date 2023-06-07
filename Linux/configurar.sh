#!/bin/bash
clear

# shellcheck source=red.sh
#source ./red.sh
source ./funciones.sh

#echo "$ruta_local"

### Variables Auxiliares
#version=$(cat version.txt)
error=0
interf_red=""
usuario="$USER"


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
paquetes=("nmap" "cifs-utils" "rsync" "cairosvg")
for i in "${!paquetes[@]}"
do
    bash banner.sh
    printf "%1s\n" "${LIME_YELLOW}            Chequeando software necesario${NORMAL}"
    printf "%1s\n" "${BRIGHT}------------------------------------------------${NORMAL}"
    echo ""
    num=$((i+1))
    printf "%1s\n" "      $num - ${BRIGHT}${paquetes[$i]}${NORMAL}"
    echo ""
    sudo apt -y install "${paquetes[$i]}"
    sleep 1
done

bash banner.sh
printf "%1s\n" "${LIME_YELLOW}            Configurando el sistema ${NORMAL}"
printf "%1s\n" "${BRIGHT}------------------------------------------------${NORMAL}"
echo ""
echo "  1 - Creando carpetas auxiliares"

echo "  Carpeta $ruta_local/config..."
if [ ! -d config ]
then
	mkdir config
fi
echo "...Listo"

echo "  Carpeta $ruta_local/datos..."
if [ ! -d datos ]
then
	mkdir datos
fi
echo "...Listo"

sleep 1
echo "      ... Listo"
echo ""
echo "  2 - Generando ID Única del Sistema"
if [ ! -a config/ID.txt ]
then
    touch config/ID.txt
    uuid=$(uuidgen)
    uuid=${uuid^^}
    echo "$uuid" > config/ID.txt
fi
sleep 1
echo "      ... Listo"
sleep 1

seleccion=100

while [ "$seleccion" -eq 100 ]; do
    bash banner.sh
    echo "  3 - Registrando equipo con el servidor de respaldos"
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
        echo "            $num - ${interfaces[$i]}"
    done

    num_interfaces=${#interfaces[@]}

    echo ""
    read -r seleccion
    seleccion=$((seleccion-1))

    case  1:${seleccion:--} in
        (1:*[!0-9]*|1:0*[89]*)
        ! echo "      ${seleccion} no es un valor válido"; seleccion=100
        ;;
        ($((seleccion<=num_interfaces))*)
            item=${interfaces[$seleccion]}
            #echo "Seleccionó $item"
            
        ;;
        ($((seleccion>num_interfaces))*)
            echo "      ${seleccion} no es un valor válido"
            seleccion=100
        ;;
    esac
    #sleep 2

   

    echo "${interfaces[$seleccion]}" > config/interfaz.txt
    interf_red=${interfaces[$seleccion]}

    #printf "%1s\n" "      Se ha seleccionado la interfáz:  ${BRIGHT}${interfaces[$seleccion]}${NORMAL}"
    
done

bash banner.sh
printf "%1s\n" "      Se ha seleccionado la interfáz:  ${BRIGHT}${interf_red}${NORMAL}"

#rango=$(ip a show ${interfaces[$seleccion]})
#echo "dato red: ${dato}"
echo ""
echo "      Obteniendo parámetros de la red con la interfáz seleccionada..."
rango=$(rango_red "$interf_red")
sleep 2
echo "      ...Listo."
echo ""

printf "%1s\n" "      Rango de red:  ${BRIGHT}${rango}${NORMAL}"

sleep 2
echo ""
printf "%1s\n" "     ${YELLOW}Por favor indique la dirección MAC del servidor de respaldos:${NORMAL}"
# echo "      Por favor indique la dirección MAC del servidor de respaldos:"
echo "      (formato: xx:xx:xx:xx:xx:xx)"
echo ""

read -r mac_disp
echo "$mac_disp" > config/dispositivo.txt
echo ""

printf "%1s\n" "      Ubicando al servidor  ${BRIGHT}${mac_disp}${NORMAL} en la red..."
echo ""
echo "      Escaneando la red en busca del servidor."
buscar_h "$rango" "$mac_disp" & PID=$! #simulate a long process
echo "      Por favor espere..."
printf "      "
# While process is running...
while kill -0 $PID 2> /dev/null; do 
    printf  "▓"
    sleep 1
done
printf ""

echo "    ...Escaneo Completo"
#Código de animación de espera tomado del usuario cosbor11 de stackoverflow.com
#Obtenido de https://stackoverflow.com/questions/12498304/using-bash-to-display-a-progress-indicator
sleep 2

bash banner.sh
ip_servidor=$(cat config/ip_servidor.txt)
echo ""
printf "%1s\n" "      IP del servidor:  ${BRIGHT}${ip_servidor}${NORMAL}"

echo ""
echo "      Accediendo a la carpeta de respaldos del servidor..."

if [ ! -d /media/"$usuario"/servidorR ]
then
	sudo mkdir /media/"$usuario"/servidorR> /dev/null
fi
sudo chown "$usuario" /media/"$usuario"/servidorR

#echo "fin de crear carpeta de montaje"

id=$(cat config/ID.txt)
#echo "usuario actual: $USER"
sudo mount -t cifs //"${ip_servidor}"/respaldos /media/"$usuario"/servidorR
sleep 1
echo "      ... Listo"

echo ""
echo "      Registrando PC en el servidor..."
# --> Revisar este artículo: https://askubuntu.com/questions/1021643/how-to-specify-a-password-when-mounting-a-smb-share-with-gio

sudo mkdir /media/"$USER"/servidorR/"${id}"
# Desmontado de unidad remota
sudo umount //"${ip_servidor}"/respaldos

sleep 1
echo "      ... Listo"

# Creación de ID imprimible
touch "$ruta_local/config/ID.svg"
cat encabezado_ID.txt > "$ruta_local/config/ID.svg"
echo "${id}" >> "$ruta_local/config/ID.svg"
cat final_ID.txt >> "$ruta_local/config/ID.svg"
#mogrify -format png -- ID.svg
cairosvg -f pdf -o "$ruta_local/config/ID.pdf" "$ruta_local/config/ID.svg"

bash banner.sh
echo "      ID imprimible creada"
printf "%1s\n" "${RED}            ATENCION:${NORMAL}"
printf "%1s\n" "${RED}            IMPRIMA el documento que aparecerá en pantalla. ${NORMAL}"
printf "%1s\n" "${RED}            Esa es la ID que permitirá restaurar el Sistema. ${NORMAL}"
printf "%1s\n" "${YELLOW}            Presione ENTER para continuar. ${NORMAL}"
read ok
xdg-open "$ruta_local/config/ID.pdf"

bash banner.sh
printf "%1s\n" "${YELLOW}            Creando subrutina de respaldo${NORMAL}"
echo "00 23 * * 5 $ruta_local/autorespaldo.sh" > cronrespaldo
crontab cronrespaldo
