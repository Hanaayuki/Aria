#!/bin/bash

#Creado por Hannayuki  https://github.com/Hanaayuki






echo "Hola soy Aria tu asistente personal señorit@ whoiam " 
echo "Estoy iniciando.... Como a ido su dia whoiam?"
sleep 2 

while true; do

echo "===================================================="
echo "        Bienvenid@ en que le puedo ayudar           "
echo "                                                    "
echo " 1) Quiero ir al apartado de las guias              "
echo " 2) Quiero ver la informacion de mi pc              "
echo " 3) Quiero ver si tengo conexion a internet         "
echo " 4) Quiero saber los comandos de linux              "
echo " 5) Quiero Ver una serie                            "
echo " 6) pagina del creador                              "
echo "===================================================="

sleep 2
read numero
#========================================#
#Apartado del listado de numeros 


if [$numero -lt 1]; then
    echo "El numero no es valido"
    break 
fi

if [$numero -gt 6]; then 
    echo "el numero no es valido"
    break
fi
#========================================#
#opcion 1
if  [$numero -eq 1]; then 
      echo "Todavia en proceso lo siento :( "
#opcion 2


if [$numero -eq 2]; then 
	echo "iniciandooooo"
clear 
	echo "=================================================="
	echo "		Porfavor selecione una opcion           "
	echo " 1) Ver la informacion general de mi pc           "
	echo " 2) ver la RAM y su uso                           "
	echo " 3) Ver El uso de del procesado y su informacion  "
	echo " 4) Ver el uso de la memoria y su informacion     "
	echo " 5) Ver mi Ip                                     "
	echo "=================================================="

	read OP



if [OP -eq 1  ]; then
    echo " voy a tener que instalar una extension "
    echo " 1)  Aceptar                            "
    echo " 2)  Cancelar                           "

	read  numero 
	
	if  [$numero  -eq 1 ] then
		echo "...Instalando ..."
		






 

#opcion 3



