#!/bin/bash

# Agrega el alias al archivo .bashrc
echo "alias Psiphon='/Psiphon.sh'" >> ~/.bashrc

# Recarga el archivo .bashrc para que el alias sea efectivo
source ~/.bashrc

# Función para mostrar el título

show_title() {

    clear

    echo "————————————————————————————————————————————————————"

    echo "  MINI PSIPHON INSTALLER SERVER ENTRY By VICTOR GEEK "

    echo "————————————————————————————————————————————————————"
    
    echo " TO ACCESS THE SCRIPT USE THE COMMAND Psiphon.sh  "

    echo "————————————————————————————————————————————————————"

    echo

}

# Función para mostrar el menú

show_menu() {

    echo "OPTION MENU:"

    echo "1. INSTALL PSIPHON PORT REQUIRED (443)"

    echo "2. SHOW PSIPHON CODE IN HEXADECIMAL FORMAT"
    
    echo "3. SHOW PSIPHON CODE IN JSON FORMAT"

    echo "4. INSTALL BAD VPN 7300 (OPTIONAL)"
    
    echo "5. SEE RUNNING SERVICES"
    
    echo "6. RESTART PSIPHON"

    echo "7. UNINSTALL BAD VPN AND STOP SERVICE"
    
    echo "8. UNINSTALL PSIPHON AND STOP SERVICE"

    echo "9. EXIT"

    echo "————————————————————————————————————————————————————"

}

# Función para esperar una opción válida

wait_for_option() {

    local valid_options="1 2 3 4 5 6 7 8"

    read -p "ENTER AN OPTION: " option

    while [[ ! $valid_options =~ (^|[[:space:]])$option($|[[:space:]]) ]]; do

        read -p "INVALID OPTION. ENTER A VALID OPTION: " option

    done

}

# Función para limpiar la pantalla y esperar una entrada

wait_for_enter() {

    echo
    
    read -p "PRESS ENTER TO CONTINUE..." enter

}

# Función para instalar y ejecutar Psiphon

install_psiphon() {

    show_title

    echo "INSTALLING PSIPHON PLEASE WAIT..."
    
    echo "ONLY FREE IS NEEDED PORT 443  "
    
    echo "IT IS RECOMMENDED TO HAVE A MINIMUM OF UBUNTU 16 OR HIGHER"
    
    echo "————————————————————————————————————————————————————"

    echo "  FRONTED-MEEK-OSSH:443  "

    echo "————————————————————————————————————————————————————"
    
    echo

    ufw disable
    
    apt update

    pkg install screen -y

    pip install screen -y

    wget 'https://raw.githubusercontent.com/Psiphon-Labs/psiphon-tunnel-core-binaries/master/psiphond/psiphond' -O 'psiphond'

    chmod +x psiphond

    ./psiphond --ipaddress 0.0.0.0 --protocol FRONTED-MEEK-OSSH:443 generate

    chmod +x psiphond.config psiphond-traffic-rules.config psiphond-osl.config psiphond-tactics.config server-entry.dat

    screen -dmS psiserver ./psiphond run

    echo "————————————————————————————————————————————————————"

    echo "  🅿️INSTALLATION COMPLETE🅿️  "

    echo "————————————————————————————————————————————————————"
    
    echo
    
    cat server-entry.dat;echo ''
    
    wait_for_enter

}

# Función para instalar bad VPN 7300

install_badvpn() {

    show_title

    echo " INSTALLING BAD VPN 7300 IS NOT MANDATORY"

    echo

    wget https://raw.githubusercontent.com/powermx/badvpn/master/easyinstall && bash easyinstall

    badvpn start

    wait_for_enter

}

# Función para mostrar la configuración de Psiphon

show_psiphon_config() {

    show_title

    echo "Showing Psiphon configuration..."

    echo

    cat server-entry.dat|xxd -p -r|jq . > /root/server-entry.json
    
    nano server-entry.json;echo

    wait_for_enter

}

# Función para mostrar el código Psiphon en formato hexadecimal

show_psiphon_hex() {

    show_title

    echo "ATTENTION TO EDIT YOUR CODE YOU MUST FIRST DECODE IT"

    echo

    cat server-entry.dat;echo ''

    wait_for_enter

}

# Función para mostrar el código Psiphon en formato hexadecimal

show_services() {

    show_title

    echo "TO STOP A SERVICE"
    
    echo "ENTER KILL FOLLOWED BY SERVICE ID"
    
    echo "EXAMPLE (KILL 613651) AND ENTER"

    echo

    apt install net-tools
    
    netstat -tnpl

    wait_for_enter

}

# Función para mostrar el código Psiphon en formato hexadecimal

reboot_psiphon() {

    show_title

    echo "RESETTING PSIPHON..."
    
    echo " "
    
    echo "🆘FILLED🆘"

    echo

    cd psi-server-entry && screen -dmS PSI ./psiphond run

    wait_for_enter

}

# Función para desinstalar badvpn
    
stop_and_remove_badvpn() {

    show_title

    echo "⛔ UNINSTALLING BAD VPN STOPING PORT 7300 ⛔"

    echo

    badvpn stop

    badvpn uninstall

    wait_for_enter

}

# Función para detener los servicios de Psiphon y eliminar archivos

stop_and_remove_psiphon() {

    show_title

    echo "🔆YOUR CODE WAS PERMANENTLY REMOVED.. 🔆"

    echo

    screen -X -S psiserver quit

    rm -f psiphond psiphond.config psiphond-traffic-rules.config psiphond-osl.config psiphond-tactics.config server-entry.dat

    echo "🔆 PSIPHON SERVICES STOPPED AND FILES DELETED. 🔆"

    wait_for_enter

}

# Función principal para mostrar el menú y procesar las opciones

main() {

    local option

    while true; do

        show_title

        show_menu

        wait_for_option

        case $option in

            1)

                install_psiphon

                ;;

            2)

                show_psiphon_hex

                ;;
            3)

                show_psiphon_config

                ;;

            4)

                install_badvpn

                ;;
                
            5)

                show_services

                ;;
                
            6)

                reboot_psiphon

                ;;

            7)

                stop_and_remove_badvpn

                ;;

            8)

                stop_and_remove_psiphon

                ;;

            9)

                show_title

                echo "✅EXITTING THE PSIPHON INSTALLER.✅"

                echo

                exit 0

                ;;

        esac

    done

}

# Ejecutar la función principal

main
