#!/bin/bash
#ruta_local=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

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

mapeo "$rango"

mac_servidor=$(cat "$ruta_local/config/dispositivo.txt")
ip_servidor=$(buscar_h "$rango" "$mac_servidor")


if [ ${#ip_servidor} -gt 6 ]; then
    
    mensCuerpo="Servidor de respaldos ubicado en la IP:$ip_servidor"
    notify-send -t 3000 -i "$ruta_local/img/red_Freepik.png" "$mensajeTit" "$mensCuerpo"

#2 - Montar la carpeta de respaldos
    idPC=$(cat config/ID.txt)
    dirRespaldo="smb://${ip_servidor}/respaldos"
    gio mount -a "$dirRespaldo"
    #gio mkdir "$dirRespaldo"/"${idPC}"
    dirRespaldo=$(gio info "$dirRespaldo"|grep -e "local path"|cut -d":" -f2,3)

    sleep 1

#3 - Iniciar el respaldo
    touch "$dirRespaldo/$idPC/respaldo_$fecha.txt"
    rsync -aznvP --exclude-from="$ruta_local/config/excluidos.txt" --max-size=200m "$HOME"/ "$dirRespaldo"/"$idPC" >> "$dirRespaldo"/"$idPC"/"respaldo_$fecha.txt"
    #rsync -azvP --exclude-from="$ruta_local/config/excluidos.txt" --max-size=200m "$HOME"/ "$dirRespaldo"/"$idPC" >> "$dirRespaldo"/"$idPC"/"respaldo_$fecha.txt"
#4 - Generar informe

#5 - Desmontar carpeta de respaldos

else
#ERROR 1.1 - No se puede ubicar al servidor de respaldos 
    mensCuerpo="No se pudo encontrar al servidor de respaldos."
    notify-send -t 3000 "$mensajeTit" "$mensCuerpo" 
    registro "ERROR" "No se pudo encontrar al servidor de respaldos."
fi




