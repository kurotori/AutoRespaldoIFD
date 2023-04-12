#!/bin/bash


#Genera una entrada con marca de tiempo en un archivo de registro
#Parámetros: 1 - Tipo de registro, 2 - Dato del registro
registro()
{
    printf -v anio '%(%Y)T' -1
    printf -v mes '%(%m)T' -1
    printf -v dia '%(%d)T' -1
    printf -v hora '%(%H)T' -1
    printf -v minuto '%(%M)T' -1
    printf -v segundo '%(%S)T' -1

    if [ ! -d ./registros ]
    then
        mkdir ./registros
    fi

    touch ./registros/"$1_$anio-$mes-$dia.txt"
    echo "[$anio-$mes-$dia $hora:$minuto:$segundo] - $1: $2" >> ./registros/"$1_$anio-$mes-$dia.txt"
    echo "[$anio-$mes-$dia $hora:$minuto:$segundo] - $1: $2"

}

#registro "PRUEBAS" "Esto es una prueba"