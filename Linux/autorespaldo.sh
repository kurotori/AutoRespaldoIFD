#!/bin/bash
ruta_local=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

source "$ruta_local/funciones.sh"
source "$ruta_local/red.sh"

# Permite redirigir las notificaciones al monitor principal
export DISPLAY=':0.0'

#1 - Ubicar el servidor de respaldos

interfaz=$(cat "$ruta_local/config/interfaz.txt")
rango=$(rango_red "$interfaz")
notify-send -t 3000 -i "$ruta_local/img/red_Freepik.png" "Sistema de Respaldo Automático" "Buscando al servidor de respaldos en el rango $rango con la interfaz $interfaz"
mapeo "$rango"
mac_server=$(cat "$ruta_local/config/dispositivo.txt")
ip_server=$(buscar_h "$rango" "$mac_server")

if [ ${#ip_server} -gt 6 ]; then
    notify-send -t 3000 -i "$ruta_local/img/red_Freepik.png" "Sistema de Respaldo Automático" "Servidor de respaldos ubicado en la IP:$ip_server"    

#2 - Montar la carpeta de respaldos
#3 - Iniciar el respaldo
#4 - Generar informe
#5 - Desmontar carpeta de respald

else
#ERROR 1.1 - No se puede ubicar al servidor de respaldos 
    notify-send -t 3000 "Sistema de Respaldo Automático" "ERROR: No se pudo continuar. No se pudo ubicar al servidor de respaldos"
    registro "ERROR" "No se pudo encontrar al servidor de respaldos. "
fi




os