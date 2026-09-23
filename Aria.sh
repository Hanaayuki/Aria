#!/bin/bash
# Creado por Hannayuki  https://github.com/Hanaayuki
# Ayudado por vextremera y gatolsbc  https://github.com/gatolsbc  y https://github.com/vextremera
# Me tire una semana trabjajando en esto tengo sueño y hambre  y tuve que ir a chorromil paginas preguntarle a ia alguna que otra cosa era posible asi que 
#pagame ila
# Asistente "Aria" para ayudar en Linux 

# Obtenemos el nombre del usuario actual del sistema
USUARIO=$(whoami)

#ENSEÑAR O HACER
# Esta función que hace que  Aria Pregunte si explica o ejecuta
ensenar_o_hacer() {
    local explicacion="$1"
    local comando="$2"
    
    echo ""
    echo "¿Cómo prefieres que lo hagamos?"
    echo " 1) Enséñame cómo se hace (Para aprender)"
    echo " 2) Hazlo tú por mí (Automático)"
    echo -n "Elige una opción [1 o 2]: "
    read -r accion
    
    if [ "$accion" = "1" ]; then
        echo -e "\n modo enseñanza "
        echo -e "$explicacion"
        echo -e "\n(Nota: En la terminal esto se haría con el comando: $comando)"
    elif [ "$accion" = "2" ]; then
        echo -e "\n modo automático "
        echo "Déjamelo a mí, estoy trabajando en ello..."
        eval "$comando"
    else
        echo "Opción no válida. Volviendo..."
    fi
}

#Funcion para pausar uwu
pausa() {
    echo ""
    echo -n "Presiona [Enter] para volver al menú principal..."
    read -r
}

#Asistente aria primera frase que tiene que decir
clear
echo "===================================================="
echo "Hola, soy 🌸Aria🌸, tu asistente personal"
echo "   Señorit@ $USUARIO, estoy iniciando..."
echo "===================================================="
sleep 2
echo "¿Cómo ha ido su día hoy?"
sleep 2 

#Bucle principal (el menu vamos)
while true; do
    clear
    echo "===================================================="
    echo "🌸 BIENVENID@ a Linux Mint | ¿En qué le puedo ayudar? 🌸"
    echo "===================================================="
    echo " 1) Quiero ir al apartado de las guías"
    echo " 2) Quiero ver la información de mi PC"
    echo " 3) Quiero ver si tengo conexión a internet"
    echo " 4) Quiero saber los comandos de Linux"
    echo " 5) Quiero ver una serie"
    echo " 6) Mantenimiento: Actualizar y limpiar el sistema"
    echo " 7) Apagar o reiniciar el ordenador "
    echo " 8) Página del creador "
    echo " 9) Temporizador "
    echo " 10) Calculadora "
    echo " 11) Mi hermano"
    echo " 12) Salir"
    echo "===================================================="
    echo -n "Elige una opción [1-8]: "
    read -r numero
     #para Hana del futuro case lo que hace case lo puse en documentacion
    case $numero in
        1)
            echo "============================================================================================================================================"       
            echo -e                                             "🧸GUÍAS🦎" #Visual estudio me recomendo poner el -e no entiendo por que 
            echo "Bienvenid@ a Linux Mint. Aquí todo es más fácil de lo que parece."
            echo "1. Tu 'Menú de Inicio' está abajo a la izquierda (el logo verde de Mint)."
            echo "2. Para instalar apps, usa el 'Gestor de Software' (es como la Play Store)."
            echo "3. Para tus archivos, abre 'Archivos' (el icono de la carpeta)."
            echo "4. Para actualizar, fíjate en el icono del escudo abajo a la derecha."
            echo "5. Para abrir la terminal, busca 'Terminal' en el Menú o presiona Ctrl+Alt+T."
            echo "6. Para apagar o reiniciar, haz clic en el icono de tu usuario abajo a la derecha o escribe 'shutdown' o 'reboot' en la terminal."
            echo "7. Ire subiendo mas cositas a futuro asi que actualiza el asitente en mi github"
            echo "========================================================================================================================================="
            pausa

            ;;
        
        2)
            clear
            echo "=================================================="
            echo " Información de mi PC"
            echo "=================================================="
            echo " 1) Ver la información general de mi PC"
            echo " 2) Ver la RAM y su uso"
            echo " 3) Ver el uso del procesador"
            echo " 4) Ver el espacio de almacenamiento (Discos)"
            echo " 5) Volver al menú principal"
            echo "=================================================="
            echo -n "Elige una opción: "
            read -r op_pc

            case $op_pc in
                1)
                    texto="Para ver la información general en Linux Mint de forma fácil:\n1. Ve al Menú (abajo a la izquierda).\n2. Escribe 'Información del sistema' y ábrelo.\nAhí verás tu procesador, tarjeta gráfica y versión de Linux."
                    cmd="sudo apt install neofetch -y && clear && neofetch"
                    ensenar_o_hacer "$texto" "$cmd"
                    ;;
                2)
                    texto="Para ver la RAM que estás gastando:\n1. Abre el Menú.\n2. Busca y abre el 'Monitor del sistema'.\n3. Ve a la pestaña 'Recursos'."
                    cmd="free -h"
                    ensenar_o_hacer "$texto" "$cmd"
                    ;;
                3)
                    texto="Para ver tu procesador:\nAl igual que con la RAM, busca el 'Monitor del sistema' en tu menú principal."
                    cmd="lscpu | grep 'Model name'"
                    ensenar_o_hacer "$texto" "$cmd"
                    ;;
                4)
                    texto="Para ver el espacio en tus discos:\n1. Abre el Menú.\n2. Busca la aplicación 'Discos' o simplemente abre tu carpeta de Archivos y mira a la izquierda."
                    cmd="df -h /"
                    ensenar_o_hacer "$texto" "$cmd"
                    ;;
                5)
                    echo "Volviendo..."
                    ;;
                *)
                    echo "Opción no válida"
                    ;;
            esac
            pausa
            ;;
        
        3)
            echo -e "\n COMPROBANDO CONEXIÓN "
            echo "Comprobando conexión con los servidores de Google..."
            if ping -c 1 8.8.8.8 &> /dev/null; then
                echo " ¡Todo perfecto! Tienes conexión a Internet(❁´◡`❁)."
            else
                echo " Parece que no hay conexión. Revisa el icono de red abajo a la derecha ＞﹏＜."
            fi
            pausa
            ;;
        
        4)
            echo -e "\n    COMANDOS BÁSICOS DE LINUX "
            echo "No tienes que aprenderlos de memoria, pero aquí tienes los básicos:"
            echo " - pwd   : Te dice en qué carpeta estás ahora mismo"
            echo " - ls    : Te muestra los archivos de la carpeta actual"
            echo " - cd    : Sirve para entrar a otras carpetas (ej. cd Descargas)"
            echo " - sudo  : Es la palabra mágica. Te da permisos de administrador"
            pausa
            ;;
        
        5)
            #creo que ya entendi para que sirve el -e en echo, es para que reconozca los caracteres especiales como \n
            echo -e "\n--- Iniciando la serie SERIE ---" 
            echo "Abriendo tu navegador de entretenimiento..."
        
            xdg-open "https://www.netflix.com" 2>/dev/null || echo "Abre tu navegador y ve a tu plataforma favorita"
            pausa
            ;;
        
        6)
            echo -e "\n---  MANTENIMIENTO DEL SISTEMA ---"
            texto="En Linux Mint es muy fácil actualizar:\n1. Fíjate abajo a la derecha, en la barra de tareas.\n2. Verás un icono de un ESCUDITO.\n3. Si tiene un punto azul/naranja, hay actualizaciones.\n4. Ábrelo y dale a 'Instalar actualizaciones'."
            cmd="echo 'Actualizando...' && sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && echo '¡Todo limpio y actualizado!'"
            ensenar_o_hacer "$texto" "$cmd"
            pausa
            ;;

        7)
          echo "Dime qué prefieres que haga (apagar / reiniciar):"
	  read  -r energia

	  case "$energia " in
	         "apagar")
			echo "Apagando las luces....."
			sleep 1
			sudo shutdown now
			;;


	         "reiniciar")
			  Echo "No ahi sistema, Reiniciando..."
			  sleep 1
			  sudo reboot 
			  ;;

		*)
			 echo  "opcion no valida  solo puedes decir si apagar o reiniciar

 esac



	11) #Funcion Hermano Abel
	   echo "Mi hermano mayor mmmmmmm el es un asistente al igual que yo pero yo soy mas tuya"
	   echo "Mientras que el es un asistente de su propio creador y es mas completa "
	   echo "por ejemplo el es mucho mas de  programacion o Asitente mas de su programador"
           echo "mientras que yo soy mas cientifica y tuya $whoiam"	
	   echo " y con mis funciones nuevas o por venir podre hacer mas"
	   echo "De hecho mi creador esta pensando en sacarme en forma app  y con un avatar"
	   echo "mejor por que ahora solo soy 1 y 0 sin cara en futuro sere 0 y 1 con cara"




        12)
            echo -e "\n ¡Ha sido un placer ayudarte!"
            exit 0
            ;;
        
        *)
            echo " El número no es válido. Por favor, elige del 1 al 8"
            sleep 1
            ;;
    esac
done

