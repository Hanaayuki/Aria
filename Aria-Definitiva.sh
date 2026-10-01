#!/usr/bin/env bash
# Aria - asistente personal para Linux Mint y Fedora.
# Creado por Hannayuki | https://github.com/Hanaayuki
# Ayudado por vextremera y gatolsbc | https://github.com/gatolsbc https://github.com/vextremera
# Anime desde terminal: https://github.com/Zhuchii/ani-es

USUARIO="$(id -un 2>/dev/null || whoami)"
URL_CREADOR="https://github.com/Hanaayuki"
URL_CICLO="https://ceice.gva.es/es/web/formacion-profesional/publicador-de-cicles/-/asset_publisher/M0SqOt5YOf05/content/ciclo-formativo-anatomia-patologica-y-citodiagnostico"
URL_CURRICULO="https://ceice.gva.es/documents/161863064/163306714/san_pat_cito_loe.pdf"
URL_ANI_ES="https://github.com/Zhuchii/ani-es"

# -------------------- GESTOR DE PAQUETES --------------------
GESTOR_PAQUETES=""

detectar_gestor_paquetes() {
    if command -v apt-get >/dev/null 2>&1; then
        GESTOR_PAQUETES="apt"
    elif command -v dnf >/dev/null 2>&1; then
        GESTOR_PAQUETES="dnf"
    else
        GESTOR_PAQUETES=""
    fi
}

actualizar_lista_paquetes() {
    case "$GESTOR_PAQUETES" in
        apt) sudo apt-get update ;;
        dnf) sudo dnf makecache ;;
        *)
            echo "No se encontró APT ni DNF. Aria está preparada para Linux Mint y Fedora."
            return 1
            ;;
    esac
}

instalar_paquete() {
    local paquete="$1"

    case "$GESTOR_PAQUETES" in
        apt) sudo apt-get install -y "$paquete" ;;
        dnf) sudo dnf install -y "$paquete" ;;
        *)
            echo "No se puede instalar '$paquete': gestor de paquetes no compatible."
            return 1
            ;;
    esac
}

detectar_gestor_paquetes

limpiar() {
    clear 2>/dev/null || true
}

pausa() {
    printf '\nPresiona [Enter] para continuar...'
    read -r _ || true
}

confirmar() {
    local respuesta
    printf '%s [s/N]: ' "$1"
    read -r respuesta || return 1
    [[ "${respuesta,,}" == "s" || "${respuesta,,}" == "si" || "${respuesta,,}" == "sí" ]]
}

abrir_url() {
    local url="$1"
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$url" >/dev/null 2>&1 &
        echo "Abriendo el navegador..."
    else
        echo "No se encontró xdg-open. Puedes abrir esta dirección manualmente:"
        echo "$url"
    fi
}

# -------------------- INFORMACIÓN DEL PC --------------------
mostrar_sistema() {
    echo "Información general del sistema"
    echo "--------------------------------"
    if [[ -r /etc/os-release ]]; then
        . /etc/os-release
        printf 'Sistema: %s\n' "${PRETTY_NAME:-Linux}"
    else
        echo "Sistema: Linux"
    fi
    printf 'Kernel: %s\n' "$(uname -r)"
    printf 'Arquitectura: %s\n' "$(uname -m)"
    printf 'Equipo: %s\n' "$(hostname 2>/dev/null || echo desconocido)"
    if command -v lscpu >/dev/null 2>&1; then
        lscpu | awk -F: '/Model name|Nombre del modelo/ {gsub(/^[ \t]+/, "", $2); print "Procesador: " $2; exit}'
    fi
}

mostrar_ram() {
    if command -v free >/dev/null 2>&1; then
        free -h
    else
        echo "No se encontró el comando free."
    fi
}

mostrar_cpu() {
    echo "Procesos que más CPU están utilizando:"
    if command -v ps >/dev/null 2>&1; then
        ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 8
    else
        echo "No se encontró el comando ps."
    fi
    echo
    echo "Carga del sistema (últimos 1, 5 y 15 minutos):"
    cat /proc/loadavg 2>/dev/null || uptime
}

mostrar_discos() {
    echo "Espacio de almacenamiento:"
    df -hT -x tmpfs -x devtmpfs 2>/dev/null || df -h
    if command -v lsblk >/dev/null 2>&1; then
        echo
        echo "Discos y particiones:"
        lsblk -o NAME,SIZE,TYPE,MOUNTPOINT 2>/dev/null || lsblk
    fi
}

menu_pc() {
    local opcion
    while true; do
        limpiar
        echo "=================================================="
        echo "             INFORMACIÓN DE MI PC"
        echo "=================================================="
        echo " 1) Información general"
        echo " 2) RAM y uso"
        echo " 3) Procesador y procesos"
        echo " 4) Espacio de almacenamiento"
        echo " 5) Volver"
        echo "=================================================="
        printf "Elige una opción: "
        read -r opcion || return
        case "$opcion" in
            1) mostrar_sistema; pausa ;;
            2) mostrar_ram; pausa ;;
            3) mostrar_cpu; pausa ;;
            4) mostrar_discos; pausa ;;
            5) return ;;
            *) echo "Opción no válida."; pausa ;;
        esac
    done
}

# -------------------- MODO ENSEÑANZA / AUTOMÁTICO --------------------
# Solo permite ejecutar funciones incluidas aquí; no utiliza eval.
ensenar_o_hacer() {
    local explicacion="$1"
    local accion="$2"
    local comando="$3"
    local eleccion

    echo
    echo "¿Cómo prefieres hacerlo?"
    echo " 1) Enséñame cómo se hace"
    echo " 2) Hazlo automáticamente"
    printf "Elige una opción [1/2]: "
    read -r eleccion || return

    case "$eleccion" in
        1)
            echo
            echo "MODO ENSEÑANZA"
            printf '%b\n' "$explicacion"
            [[ -n "$comando" ]] && printf '\nComando utilizado: %s\n' "$comando"
            ;;
        2)
            echo
            echo "MODO AUTOMÁTICO"
            case "$accion" in
                mostrar_sistema) mostrar_sistema ;;
                mostrar_ram) mostrar_ram ;;
                mostrar_cpu) mostrar_cpu ;;
                mostrar_discos) mostrar_discos ;;
                actualizar_sistema) actualizar_sistema ;;
                *) echo "Acción no reconocida; no se ha ejecutado nada." ;;
            esac
            ;;
        *) echo "Opción no válida." ;;
    esac
}

actualizar_sistema() {
    case "$GESTOR_PAQUETES" in
        apt)
            echo "Se actualizará el sistema usando APT (Linux Mint/Ubuntu)."
            sudo apt-get update && sudo apt-get upgrade && sudo apt-get autoremove
            ;;
        dnf)
            echo "Se actualizará el sistema usando DNF (Fedora)."
            sudo dnf upgrade --refresh && sudo dnf autoremove
            ;;
        *)
            echo "No se ha detectado APT ni DNF."
            return 1
            ;;
    esac
}

# -------------------- CONEXIÓN --------------------
comprobar_internet() {
    echo "Comprobando la conexión..."
    if command -v curl >/dev/null 2>&1 && curl -fsSI --connect-timeout 5 https://example.com >/dev/null 2>&1; then
        echo "¡Hay conexión a Internet y se ha podido contactar con una web!"
    elif command -v ping >/dev/null 2>&1 && ping -c 1 -W 4 1.1.1.1 >/dev/null 2>&1; then
        echo "Hay conexión IP. No se ha podido confirmar el acceso web o el DNS."
    elif command -v getent >/dev/null 2>&1 && getent hosts example.com >/dev/null 2>&1; then
        echo "El DNS responde, pero no se ha podido confirmar el acceso a una web."
    else
        echo "No se ha podido comprobar la conexión. Revisa la red e inténtalo de nuevo."
    fi
}

# -------------------- ANIME --------------------
instalar_ani_es() {
    local temporal resultado

    echo "=================================================="
    echo "        INSTALACIÓN AUTOMÁTICA DE ANI-ES"
    echo "=================================================="
    echo "Aria hará la instalación completa por ti."
    echo "Solo tendrás que introducir tu contraseña cuando"
    echo "tu sistema la solicite para usar sudo."
    echo

    if [[ -z "$GESTOR_PAQUETES" ]]; then
        echo "No he podido detectar un gestor compatible."
        echo "Aria está preparada para Linux Mint (APT) y Fedora (DNF)."
        return 1
    fi

    if [[ "$GESTOR_PAQUETES" == "apt" ]]; then
        echo "Sistema detectado: Linux Mint/Ubuntu (APT)."
    else
        echo "Sistema detectado: Fedora (DNF)."
    fi
    echo "El instalador oficial de ani-es detectará también el gestor de paquetes."
    echo

    if ! confirmar "¿Quieres que Aria instale ani-es y sus dependencias automáticamente?"; then
        echo "Instalación cancelada."
        return 0
    fi

    # Git es necesario para descargar ani-es. Si no existe, Aria lo instala sola.
    if ! command -v git >/dev/null 2>&1; then
        echo
        echo "Git no está instalado. Aria lo instalará automáticamente."
        actualizar_lista_paquetes || return 1
        instalar_paquete git || {
            echo "No se pudo instalar Git."
            return 1
        }
    fi

    temporal="$(mktemp -d 2>/dev/null)" || {
        echo "No se pudo crear una carpeta temporal."
        return 1
    }

    echo
    echo "Descargando ani-es desde GitHub..."
    if git clone --depth 1 "$URL_ANI_ES.git" "$temporal/ani-es"; then
        echo "Descarga completada."
        echo
        echo "Ahora se ejecutará el instalador oficial de ani-es."
        echo "Este instalador instalará automáticamente las dependencias que necesite."
        echo "Puede volver a pedir tu contraseña de administrador."
        echo
        (
            cd "$temporal/ani-es" || exit 1
            chmod +x install.sh || exit 1
            ./install.sh
        )
        resultado=$?
    else
        echo "No se pudo descargar ani-es desde GitHub."
        resultado=1
    fi

    rm -rf -- "$temporal"

    if [[ "$resultado" -eq 0 ]] && command -v ani-es >/dev/null 2>&1; then
        echo
        echo "=================================================="
        echo "✅ ani-es se ha instalado correctamente."
        echo "=================================================="
        echo "Ya puedes entrar en el apartado de anime y elegir un anime."
    elif [[ "$resultado" -eq 0 ]]; then
        echo
        echo "El instalador terminó, pero Linux todavía no encuentra ani-es."
        echo "Cierra y vuelve a abrir la terminal y prueba de nuevo."
    else
        echo
        echo "La instalación no se completó."
        echo "Revisa el mensaje anterior para saber qué ocurrió."
    fi
}

menu_anime() {
    local opcion busqueda
    while true; do
        limpiar
        echo "=================================================="
        echo "              ANIME DESDE LA TERMINAL"
        echo "=================================================="
        if command -v ani-es >/dev/null 2>&1; then
            echo "ani-es está instalado."
            echo " 1) Abrir el buscador interactivo"
            echo " 2) Buscar un anime por nombre"
            echo " 3) Reinstalar / actualizar desde GitHub"
            echo " 4) Volver"
        else
            echo "ani-es todavía no está instalado."
            echo " 1) Instalar ani-es automáticamente"
            echo " 2) Ver el repositorio"
            echo " 3) Volver"
        fi
        echo "=================================================="
        printf "Elige una opción: "
        read -r opcion || return

        if command -v ani-es >/dev/null 2>&1; then
            case "$opcion" in
                1) ani-es; pausa ;;
                2)
                    printf "Escribe el nombre del anime (vacío para cancelar): "
                    read -r busqueda || return
                    [[ -n "$busqueda" ]] && ani-es "$busqueda"
                    pausa
                    ;;
                3) instalar_ani_es; pausa ;;
                4) return ;;
                *) echo "Opción no válida."; pausa ;;
            esac
        else
            case "$opcion" in
                1) instalar_ani_es; pausa ;;
                2) abrir_url "$URL_ANI_ES"; pausa ;;
                3) return ;;
                *) echo "Opción no válida."; pausa ;;
            esac
        fi
    done
}

# -------------------- TEMPORIZADOR Y CALCULADORA --------------------
notificar_fin() {
    printf '\a'
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "Aria" "¡Se ha terminado el temporizador!" >/dev/null 2>&1 || true
    fi
    echo "¡Tiempo terminado! 🌸"
}

temporizador() {
    local minutos
    printf "¿Cuántos minutos quieres? "
    read -r minutos || return
    if [[ ! "$minutos" =~ ^[0-9]+$ ]] || (( minutos < 1 )); then
        echo "Introduce un número entero de minutos mayor que cero."
        return
    fi
    echo "Temporizador iniciado: $minutos minuto(s)."
    sleep "${minutos}m"
    notificar_fin
}

pomodoro() {
    echo "Sesión de estudio: 25 minutos de concentración."
    echo "Puedes detenerla con Ctrl+C."
    sleep 25m
    notificar_fin
    echo
    if confirmar "¿Quieres iniciar ahora un descanso de 5 minutos?"; then
        sleep 5m
        notificar_fin
    fi
}

calculadora() {
    local expresion resultado
    if ! command -v bc >/dev/null 2>&1; then
        echo "La calculadora necesita 'bc'. Aria puede instalarlo automáticamente."
        if ! confirmar "¿Quieres instalar bc ahora?"; then
            echo "Instalación cancelada."
            return
        fi
        actualizar_lista_paquetes || return
        instalar_paquete bc || {
            echo "No se pudo instalar bc."
            return
        }
    fi
    echo "Escribe una operación (ejemplo: (12+8)/4). Solo se aceptan números y operadores básicos."
    printf "Operación: "
    read -r expresion || return
    if [[ ! "$expresion" =~ ^[0-9+*/().%[:space:]^-]+$ ]]; then
        echo "La operación contiene caracteres no permitidos."
        return
    fi
    resultado="$(printf '%s\n' "$expresion" | bc -l 2>&1)"
    if [[ $? -eq 0 ]]; then
        printf 'Resultado: %s\n' "$resultado"
    else
        echo "No se ha podido calcular: $resultado"
    fi
}

# -------------------- ESTUDIO: ANATOMÍA Y MEDICINA FORENSE --------------------
mostrar_modulos() {
    cat <<'TEXTO'
MÓDULOS DEL CICLO DE ANATOMÍA PATOLÓGICA Y CITODIAGNÓSTICO

PRIMER CURSO (según el documento curricular enlazado):
  • Gestión de muestras biológicas
  • Técnicas generales de laboratorio
  • Biología molecular y citogenética
  • Fisiopatología general
  • Formación y orientación laboral
  • Inglés técnico I

SEGUNDO CURSO (según el documento curricular enlazado):
  • Necropsias
  • Procesamiento citológico y tisular
  • Citología ginecológica
  • Citología general
  • Empresa e iniciativa emprendedora
  • Proyecto de Anatomía Patológica y Citodiagnóstico
  • Formación en centros de trabajo
  • Inglés técnico II

La organización puede cambiar según el plan de estudios y el centro. Comprueba
siempre la programación que le haya facilitado su instituto.
TEXTO
}

mostrar_ficha() {
    case "$1" in
        1)
            echo "CITOLOGÍA"
            echo "Estudia las células, su estructura y sus características. En el ámbito diagnóstico se valoran muestras celulares siguiendo los criterios y protocolos del laboratorio."
            ;;
        2)
            echo "HISTOLOGÍA"
            echo "Estudia los tejidos y la organización de sus células. La observación microscópica permite describir su arquitectura y sus características."
            ;;
        3)
            echo "FIJACIÓN"
            echo "Proceso que busca conservar las características de una muestra y limitar los cambios que aparecen después de obtenerla. El fijador y el procedimiento dependen de la prueba y del protocolo del laboratorio."
            ;;
        4)
            echo "BIOPSIA"
            echo "Muestra de tejido obtenida de un organismo vivo para su estudio. Su procesamiento y valoración dependen del tipo de muestra y de la indicación clínica."
            ;;
        5)
            echo "NECROPSIA"
            echo "Examen externo e interno sistemático de un cadáver para documentar hallazgos. El objetivo y el procedimiento concreto dependen del contexto clínico, académico o judicial y de las normas aplicables."
            ;;
        6)
            echo "CADENA DE CUSTODIA"
            echo "Registro documentado de la recogida, identificación, conservación, traslado y entrega de una evidencia. Ayuda a mantener su trazabilidad e integridad."
            ;;
        *) echo "Ficha no disponible." ;;
    esac
}

menu_fichas() {
    local opcion
    while true; do
        limpiar
        echo "================ FICHAS DE REPASO ================"
        echo " 1) Citología"
        echo " 2) Histología"
        echo " 3) Fijación"
        echo " 4) Biopsia"
        echo " 5) Necropsia"
        echo " 6) Cadena de custodia"
        echo " 7) Volver"
        echo "==================================================="
        printf "Elige una ficha: "
        read -r opcion || return
        case "$opcion" in
            1|2|3|4|5|6) echo; mostrar_ficha "$opcion"; pausa ;;
            7) return ;;
            *) echo "Opción no válida."; pausa ;;
        esac
    done
}

test_estudio() {
    local respuesta puntos=0
    echo "TEST DE REPASO — 5 preguntas"
    echo "Responde con a, b o c."
    echo

    echo "1) ¿Qué estudia principalmente la citología?"
    echo "   a) Las células   b) Los tejidos   c) Los órganos"
    printf "Respuesta: "; read -r respuesta || return
    [[ "${respuesta,,}" == "a" ]] && ((puntos+=1)) || echo "Correcta: a) Las células."

    echo
    echo "2) ¿Qué estudia principalmente la histología?"
    echo "   a) Los huesos   b) Los tejidos   c) Las hormonas"
    printf "Respuesta: "; read -r respuesta || return
    [[ "${respuesta,,}" == "b" ]] && ((puntos+=1)) || echo "Correcta: b) Los tejidos."

    echo
    echo "3) ¿Cuál es la finalidad general de la fijación de una muestra?"
    echo "   a) Conservar sus características   b) Cambiar su origen   c) Sustituir su etiquetado"
    printf "Respuesta: "; read -r respuesta || return
    [[ "${respuesta,,}" == "a" ]] && ((puntos+=1)) || echo "Correcta: a) Conservar sus características."

    echo
    echo "4) ¿Para qué sirve la cadena de custodia de una evidencia?"
    echo "   a) Acelerar el análisis   b) Documentar su trazabilidad   c) Evitar el registro"
    printf "Respuesta: "; read -r respuesta || return
    [[ "${respuesta,,}" == "b" ]] && ((puntos+=1)) || echo "Correcta: b) Documentar su trazabilidad."

    echo
    echo "5) ¿Qué describe una necropsia?"
    echo "   a) Un examen sistemático de un cadáver   b) Un cultivo celular   c) Una extracción de sangre"
    printf "Respuesta: "; read -r respuesta || return
    [[ "${respuesta,,}" == "a" ]] && ((puntos+=1)) || echo "Correcta: a) Un examen sistemático de un cadáver."

    echo
    echo "Resultado: $puntos de 5 respuestas correctas."
    echo "Este test es orientativo y sirve solo para repasar conceptos básicos."
}

introduccion_forense() {
    cat <<'TEXTO'
INTRODUCCIÓN A LA MEDICINA FORENSE

La medicina forense aplica conocimientos médicos a cuestiones de interés
judicial o legal. Dentro de este campo, la patología forense estudia, entre
otros aspectos, lesiones y hallazgos relacionados con la muerte.

Relación con su ciclo:
  • Anatomía patológica: estudia alteraciones de células y tejidos.
  • Citodiagnóstico: analiza características celulares en muestras.
  • Necropsias: permite aprender a documentar hallazgos de forma sistemática.
  • Medicina forense: incorpora además el contexto médico-legal y la
    documentación de evidencias cuando corresponde.

Ideas que conviene repasar:
  • Identificación y trazabilidad de las muestras.
  • Registro claro, objetivo y cronológico de los hallazgos.
  • Confidencialidad y respeto a las personas.
  • Imparcialidad: describir los datos sin añadir conclusiones no respaldadas.

Este apartado es educativo. No sustituye las clases, los protocolos del centro,
la supervisión profesional ni la normativa aplicable. No debe utilizarse para
interpretar muestras reales ni para realizar procedimientos.
TEXTO
}

apuntes_estudio() {
    local opcion carpeta archivo materia nota
    carpeta="$HOME/.local/share/aria"
    archivo="$carpeta/apuntes_estudio.txt"
    mkdir -p "$carpeta" || {
        echo "No se pudo crear la carpeta de apuntes."
        return
    }

    echo "1) Añadir un apunte rápido"
    echo "2) Leer mis apuntes"
    echo "3) Volver"
    printf "Elige una opción: "
    read -r opcion || return
    case "$opcion" in
        1)
            printf "Tema o módulo: "; read -r materia || return
            printf "Apunte (una línea): "; read -r nota || return
            if [[ -z "$materia" || -z "$nota" ]]; then
                echo "El tema y el apunte no pueden estar vacíos."
            else
                {
                    printf '\n[%s] %s\n' "$(date '+%Y-%m-%d %H:%M')" "$materia"
                    printf '%s\n' "$nota"
                } >> "$archivo" && echo "Apunte guardado en: $archivo"
            fi
            ;;
        2)
            if [[ -s "$archivo" ]]; then
                cat "$archivo"
            else
                echo "Todavía no hay apuntes guardados."
            fi
            ;;
        3) return ;;
        *) echo "Opción no válida." ;;
    esac
}

menu_estudio() {
    local opcion
    while true; do
        limpiar
        echo "=================================================="
        echo "       RINCÓN DE ESTUDIO DE ARIA 🌸"
        echo " Anatomía Patológica · Citodiagnóstico · Forense"
        echo "=================================================="
        echo " 1) Ver módulos del ciclo"
        echo " 2) Fichas de repaso"
        echo " 3) Test interactivo"
        echo " 4) Introducción a medicina forense"
        echo " 5) Añadir o leer apuntes"
        echo " 6) Temporizador de estudio (Pomodoro)"
        echo " 7) Abrir recursos oficiales del ciclo"
        echo " 8) Volver"
        echo "=================================================="
        printf "Elige una opción: "
        read -r opcion || return
        case "$opcion" in
            1) mostrar_modulos; pausa ;;
            2) menu_fichas ;;
            3) test_estudio; pausa ;;
            4) introduccion_forense; pausa ;;
            5) limpiar; apuntes_estudio; pausa ;;
            6) pomodoro; pausa ;;
            7) abrir_url "$URL_CICLO"; echo "Documento curricular: $URL_CURRICULO"; pausa ;;
            8) return ;;
            *) echo "Opción no válida."; pausa ;;
        esac
    done
}

# -------------------- GUÍAS Y MENÚ PRINCIPAL --------------------
mostrar_guias() {
    cat <<'TEXTO'
GUÍAS BÁSICAS DE LINUX

1. Abre el menú de aplicaciones para buscar tus programas.
2. Para instalar aplicaciones, usa el gestor de software de tu distribución.
3. Para tus archivos, abre el explorador de archivos.
4. Para actualizar, usa el actualizador de tu sistema o la función de mantenimiento de Aria.
5. Para abrir una terminal, busca «Terminal» o pulsa Ctrl+Alt+T.
6. Antes de apagar o reiniciar, guarda tus documentos abiertos.
7. Para ver anime en terminal, Aria puede instalar y abrir ani-es.

Aria reconoce automáticamente:
  • Linux Mint/Ubuntu → APT
  • Fedora → DNF
TEXTO
}

comandos_linux() {
    cat <<'TEXTO'
COMANDOS BÁSICOS DE LINUX

  pwd       Muestra la carpeta actual.
  ls        Lista los archivos de la carpeta.
  cd        Cambia de carpeta (ej.: cd Descargas).
  mkdir     Crea una carpeta (ej.: mkdir Apuntes).
  cp        Copia archivos o carpetas.
  mv        Mueve o cambia el nombre de archivos.
  rm        Borra archivos; úsalo con cuidado.
  sudo      Ejecuta una orden con permisos de administrador.
  man       Abre el manual de un comando (ej.: man ls).
  df -h     Muestra el espacio de los sistemas de archivos.
  free -h   Muestra el uso de la memoria RAM.

Consejo: revisa cualquier comando antes de ejecutarlo, especialmente si utiliza sudo o rm.
TEXTO
}

energia_equipo() {
    local energia
    echo "¿Qué quieres hacer? (apagar / reiniciar)"
    printf "Opción: "
    read -r energia || return
    energia="${energia,,}"
    case "$energia" in
        apagar)
            if confirmar "¿Seguro que quieres apagar el ordenador ahora? Guarda antes tus archivos."; then
                sudo shutdown -h now
            else
                echo "Apagado cancelado."
            fi
            ;;
        reiniciar)
            if confirmar "¿Seguro que quieres reiniciar el ordenador? Guarda antes tus archivos."; then
                sudo reboot
            else
                echo "Reinicio cancelado."
            fi
            ;;
        *) echo "Opción no válida. Escribe apagar o reiniciar." ;;
    esac
}

hermano_abel() {
    cat <<TEXTO
Mi hermano mayor es Abel, otro asistente.
Él está pensado para ayudar a su creador con tareas de programación y otras
funciones. Yo, Aria, tengo mi propio rincón para el estudio y el entretenimiento
y seguiré creciendo con nuevas funciones.

Usuario actual: $USUARIO
TEXTO
}

limpiar
echo "===================================================="
echo "Hola, soy 🌸 Aria 🌸, tu asistente personal."
printf "Bienvenid@, %s. Estoy iniciando...\n" "$USUARIO"
echo "===================================================="
echo "¿Cómo ha ido tu día hoy?"
sleep 1

while true; do
    limpiar
    echo "========================================================="
    echo "🌸 BIENVENID@ A LINUX | ¿EN QUÉ TE PUEDO AYUDAR? 🌸"
    echo "========================================================="
    echo " 1) Guías de Linux"
    echo " 2) Información de mi PC"
    echo " 3) Comprobar conexión a Internet"
    echo " 4) Comandos de Linux"
    echo " 5) Ver anime desde la terminal"
    echo " 6) Mantenimiento: actualizar y limpiar"
    echo " 7) Apagar o reiniciar el ordenador"
    echo " 8) Página del creador"
    echo " 9) Temporizador"
    echo "10) Calculadora"
    echo "11) Mi hermano Abel"
    echo "12) Salir"
    echo "13) Rincón de estudio: anatomía y medicina forense"
    echo "========================================================="
    printf "Elige una opción [1-13]: "
    read -r numero || {
        echo
        echo "Saliendo de Aria. ¡Hasta pronto!"
        exit 0
    }

    case "$numero" in
        1) limpiar; mostrar_guias; pausa ;;
        2) menu_pc ;;
        3) limpiar; comprobar_internet; pausa ;;
        4) limpiar; comandos_linux; pausa ;;
        5) menu_anime ;;
        6)
            limpiar
            texto="Aria detecta automáticamente tu distribución. En Linux Mint/Ubuntu usa APT y en Fedora usa DNF. El modo automático actualiza el sistema y puede pedir la contraseña de administrador."
            ensenar_o_hacer "$texto" actualizar_sistema "APT en Linux Mint/Ubuntu o DNF en Fedora"
            pausa
            ;;
        7) limpiar; energia_equipo; pausa ;;
        8) abrir_url "$URL_CREADOR"; pausa ;;
        9) limpiar; temporizador; pausa ;;
        10) limpiar; calculadora; pausa ;;
        11) limpiar; hermano_abel; pausa ;;
        12) echo; echo "¡Ha sido un placer ayudarte! Hasta pronto 🌸"; exit 0 ;;
        13) menu_estudio ;;
        *) echo "El número no es válido. Elige una opción del 1 al 13."; sleep 1 ;;
    esac
done
