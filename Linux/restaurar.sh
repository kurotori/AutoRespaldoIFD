#!/bin/bash
clear
source ./funciones.sh

banner
printf "%1s\n" "${LIME_YELLOW}         Ingrese la ID de Respaldo del equipo:${NORMAL}"
printf "%1s\n" "${BRIGHT}------------------------------------------------${NORMAL}"
read -r idPC
