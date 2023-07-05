#!/bin/bash
clear

# Funciones de Red


#Realiza un mapeo de la red
#Parámetro 1: rango de red
mapeo()
{
    #echo "$1"
    #ip_l=$(nmap -sP "$1" >/dev/null && ip neigh)
    ip_l=$(nmap -sP "$1" >/dev/null && ip neigh)
    #ip_l=$(nmap -sP "$1" >/dev/null && arp -an)
    echo "$ip_l">"./aux/lista_ips.txt"
}


#Parámetro 1: rango de red, Parámetro 2: MAC del servidor
buscar_h()
{   

    if [[ -f "./ip_PC.txt" ]]; then
        ip_servidor=$(cat "./ip_PC.txt")
    else
        ip_servidor=""
    fi
    
    #Tiempo actual del sistema
    t_actual=$(date +%s)

    #Chequeo de carpetas y archivos auxiliares
    if [ ! -d "./aux" ]
    then
        mkdir "./aux"
    fi

    if [ -s "./aux/tiempo_reg.txt" ]
    then
        t_reg=$(cat "./aux/tiempo_reg.txt")
    else
        t_reg=0
    fi
    
    #Chequeo del último escaneo
    ult_reg=$(( t_actual - t_reg))
    
    if [[ $ult_reg -ge 86400 ]] || [[ ${#ip_servidor} -lt 6 ]]; then
        
        mapeo "$1"
        ip_h2=$(grep -c "$2" "./aux/lista_ips.txt")
        #echo "cant $ip_h2"

        if [ "$ip_h2" -eq 1 ]
        then
            ip_h=$(grep -i "$2" "./aux/lista_ips.txt"|awk '{print $1}'|sed 's/[()]//g')
        fi
    else
        ip_h="${ip_servidor}"
    fi

    echo "$ip_h">"./aux/ip_servidor.txt"
    date +%s>"./aux/tiempo_reg.txt"
    #echo "$ip_h"

}


#Determina el rango de la red local
#Parámetro 1: interfáz de red
rango_red()
{
    #ip_local=$(ip addr |sed -e 's/^[ \t]*//'| grep -e "inet[^6]"|grep -v 'vboxnet0'|cut -d" " -f2|grep -v '127.0.0.1')
    ip_local=$(ip a list $1|sed -e 's/^[ \t]*//'|grep -e "inet[^6]"|cut -d" " -f2)
    ip_parte1=$(echo "$ip_local"|cut -d"." -f1,2,3)
    ip_parte2=$(echo "$ip_local"|cut -d"/" -f2)
    ip_rango="$ip_parte1.0/$ip_parte2"
    echo "$ip_rango"
}

#Permite obtener un listado de las interfaces del sistema
listar_interfaces()
{
    interfaces=()
    for dato in $(ip address | grep "^[0-9].*" | cut -d ":" -f 2)
    do 
        interfaces+=("$dato") 
    done

    for i in "${!interfaces[@]}"
    do
        echo "$i - ${interfaces[$i]}"
    done
}

## Ejecución
##


seleccion=100
while [ "$seleccion" -eq 100 ]; do

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

            

                #echo "${interfaces[$seleccion]}" > config/interfaz.txt
                interf_red=${interfaces[$seleccion]}
                echo "$interf_red"
                #printf "%1s\n" "      Se ha seleccionado la interfáz:  ${BRIGHT}${interfaces[$seleccion]}${NORMAL}"
                
            done

rango=$(rango_red "$interf_red")
echo "$rango"

echo "Indique la MAC del dispositivo buscado:"
read -r mac_disp
echo "      Escaneando la red en busca del servidor."
buscar_h "$rango" "$mac_disp" & PID=$! #simulate a long process
echo "      Por favor espere..."
printf "      "
# While process is running...
while kill -0 $PID 2> /dev/null; do 
    printf  "o"
    sleep 1
done
printf ""
clear
echo "    ...Escaneo Completo"
ip_PC=$(cat "./aux/ip_servidor.txt")
echo "$mac_disp - $ip_PC"