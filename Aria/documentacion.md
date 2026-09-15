1. Comandos del Script
                        whoami: Devuelve el nombre del usuario 

                        clear y sleep: limpia la terminal  y sleep  pausa la ejecución del script durante segundos

                        echo: Muestra texto en pantalla El parámetro -e permite usar caracteres especiales como \n (salto de línea), y -n quita el salto de línea final para que el usuario escriba en la misma línea de la pregunta

                        read -r variable: Pausa el script y guarda lo que el usuario escriba en una variable. El parámetro -r es una buena práctica porque evita que las barras invertidas (\) causen errores de lectura

                        eval: Fuerza al intérprete de Bash a evaluar y ejecutar una cadena de texto (guardada en una variable) como si fuera un comando real de la terminal

                        Case: Lo que hace es que es ir direcctaqmente a la opcion correcta 
                    

                        -e en echo, es para que reconozca los caracteres especiales como \n



2. Comandos de Hardware e Información
                                    neofetch: Es una herramienta de línea de comandos que muestra información del sistema operativo, kernel y hardware junto a un logo ASCII de la distribución

                                    free -h: Muestra la memoria RAM total, usada y libre. El parámetro -h (human-readable) convierte los valores a Megabytes y Gigabytes para que sean comprensibles

                                    lscpu | grep 'Model name': lscpu extrae la arquitectura del procesador. Usamos la tubería (|) para pasar ese resultado a grep, que filtra el texto y muestra únicamente la línea del modelo de la CPU.

                                    df -h /: Muestra el espacio en disco usado y disponible. La barra / indica que solo queremos ver la partición raíz del sistema, y -h lo pone en formato legible


3. Redes, Mantenimiento y Otros
                                ping -c 1 8.8.8.8: Envía un único paquete ICMP (-c 1) a los servidores DNS de Google. Si responde, sabemos que hay salida a Internet.

                                &> /dev/null: Redirige tanto la salida estándar como los errores al dispositivo nulo (un "agujero negro" en Linux). Se usa para que los comandos (como ping) trabajen en silencio sin ensuciar la pantalla.

                                xdg-open: Comando fundamental en entornos gráficos de Linux. Abre un archivo o una URL utilizando la aplicación predeterminada del sistema del usuario 