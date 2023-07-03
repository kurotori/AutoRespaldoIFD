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
    srvRespaldo="smb://${ip_servidor}/respaldos"
    
    #Chequeo del punto de montaje
    p_montaje=$(gio mount -l|grep -c -e "smb://${ip_servidor}/respaldos")
    echo "$p_montaje"
    if [ "$p_montaje" -lt 1 ]; then
        gio mount -a $srvRespaldo
    fi

    dirRespaldo=$(gio info "$srvRespaldo"|grep -e "local path"|cut -d":" -f2,3)
    
    linkRespaldo="$ruta_local/respaldos"

    if [ -L "$linkRespaldo" ]; then
        unlink "$linkRespaldo"
        ln -sF $dirRespaldo/ $linkRespaldo
        echo "link re-creado"
    else
        ln -sF $dirRespaldo/ $linkRespaldo
        echo "link creado"
    fi

    sleep 1

#3 - Iniciar el respaldo
    rutaReg="${linkRespaldo}/${idPC}/registro"
    archReg="$rutaReg/respaldo_${fecha}.txt"
    touch "$archReg"
    registro "ACTIVIDAD" "Respaldo iniciado en $ip_servidor con la ID: $idPC." "$rutaReg" 
    #rsync -aznvP --exclude-from="$ruta_local/config/excluidos.txt" --max-size=200m "$HOME"/ "$dirRespaldo"/"$idPC" >> "${linkRespaldo}/${idPC}/respaldo_${fecha}.txt"
    rsync -azvP --exclude-from="$ruta_local/config/excluidos.txt" --max-size=200m "$HOME"/ "$linkRespaldo/$idPC" >> "$archReg"
#4 - Generar informe
    cp "$archReg" "$ruta_local/registros/"
    registro "ACTIVIDAD" "Respaldo finalizado." "$rutaReg"
    registro "ACTIVIDAD" "Respaldo finalizado." "$ruta_local/registros"
#5 - Desmontar carpeta de respaldos y deshacer vínculo simbólico
    gio mount -u "$srvRespaldo"
    unlink "$linkRespaldo"
    echo "quitar link"
#6 - 

else
#ERROR 1.1 - No se puede ubicar al servidor de respaldos 
    mensCuerpo="No se pudo encontrar al servidor de respaldos."
    notify-send -t 3000 "$mensajeTit" "$mensCuerpo" 
    registro "ERROR" "No se pudo encontrar al servidor de respaldos." "$ruta_local/registros"
fi




