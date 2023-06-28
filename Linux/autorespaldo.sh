#!/bin/bash
#ruta_local=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
# shellcheck source=./funciones.sh

source "./funciones.sh"
source "$ruta_local/red.sh"


# Permite redirigir las notificaciones hacia el monitor principal
export DISPLAY=':0.0'

### Variables Auxiliares ###
mensajeTit="Sistema de Respaldo Automático"

#1 - Ubicar el servidor de respaldos

interfaz=$(cat "$ruta_local/config/interfaz.txt")
rango=$(rango_red "$interfaz")

notify-send -t 3000 -i "$ruta_local/img/red_Freepik.png" "Sistema de Respaldo Automático" "Buscando al servidor de respaldos en el rango $rango con la interfaz $interfaz"

#mapeo "$rango"

mac_servidor=$(cat "$ruta_local/config/macServidor.txt")
#echo "$mac_servidor"
#buscar_h "$rango" "$mac_servidor"

#espere
ip_servidor=$(buscar_h "$rango" "$mac_servidor")

echo "IP: $ip_servidor"

if [ ${#ip_servidor} -gt 6 ]; then
    
    mensCuerpo="Servidor de respaldos ubicado en la IP:$ip_servidor"
    notify-send -t 3000 -i "$ruta_local/img/red_Freepik.png" "$mensajeTit" "$mensCuerpo"

#2 - Montar la carpeta de respaldos
    idPC=$(cat config/ID.txt)
    dirRespaldo="smb://${ip_servidor}/respaldos"
    
    #Chequeo del punto de montaje
    p_montaje=$(gio mount -l|grep -c -e "smb://${ip_servidor}/respaldos")
    if [ "$p_montaje" -lt 0 ]; then
        gio mount -a "$dirRespaldo"      
    fi
    
    dirRespaldo=$(gio info "$dirRespaldo"|grep -e "local path"|cut -d":" -f2,3)
    
    linkRespaldo="$ruta_local/respaldos"

    if [ -L "$linkRespaldo" ]; then
        unlink "$linkRespaldo"
        ln -s "$dirRespaldo" "$linkRespaldo"
        echo "link re-creado"
    else
        ln -s "$dirRespaldo/" "$linkRespaldo"
        echo "link creado"
    fi
  

    sleep 1

#3 - Iniciar el respaldo
    touch "${linkRespaldo}/${idPC}/respaldo_${fecha}.txt"
    registro "ACTIVIDAD" "Respaldo iniciado en $ip_servidor con la ID: $idPC."
    rsync -aznvP --exclude-from="$ruta_local/config/excluidos.txt" --max-size=200m "$HOME"/ "$dirRespaldo"/"$idPC" >> "${linkRespaldo}/${idPC}/respaldo_${fecha}.txt"
    #rsync -azvP --exclude-from="$ruta_local/config/excluidos.txt" --max-size=200m "$HOME"/ "$dirRespaldo"/"$idPC" >> "$dirRespaldo"/"$idPC"/"respaldo_$fecha.txt"
#4 - Generar informe
    registro "ACTIVIDAD" "Respaldo finalizado."
#5 - Desmontar carpeta de respaldos y deshacer vínculo simbólico
    gio mount -u "$dirRespaldo"
    #unlink "$linkRespaldo"
    echo "quitar link"

else
#ERROR 1.1 - No se puede ubicar al servidor de respaldos 
    mensCuerpo="No se pudo encontrar al servidor de respaldos."
    notify-send -t 3000 "$mensajeTit" "$mensCuerpo" 
    registro "ERROR" "No se pudo encontrar al servidor de respaldos."
fi




