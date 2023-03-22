#!/bin/bash
# Permite redirigir las notificaciones al monitor principal
export DISPLAY=':0.0'


fecha=$(date)
notify-send -t 3000 "FECHA" "$fecha"
echo "HHH ${fecha}" >> pruebacron.txt