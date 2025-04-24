#!/bin/bash

#Check if the ifstat command is installed
if ! command -v ifstat &> /dev/null; then
    echo "Para que el script funcione es necesario tener instalado ifstat"
    exit 1
fi

#Define reports directory
REPORTS_DIR="reports"

#Create reports directory if it doesn't exist
mkdir -p "$REPORTS_DIR"

#Define the function to monitor the network
function network_monitoring {
    local n=$1
    for ((i=1; i<=n; i++)); do
        ifstat 5 1
        sleep 5
    done
}

#Function to delete reports
function delete_reports {
    if [ -d "$REPORTS_DIR" ]; then
        rm -rf "$REPORTS_DIR"/*
        echo "Todos los reportes han sido eliminados."
    else
        echo "La carpeta de reportes no existe."
    fi
}

#Validate the input parameter
if [ "$1" = "-n" ]; then  
    if [ -z "$2" ]; then
        echo "Requiere la cantidad de veces que quiere ver el monitoreo."
        exit 1
    elif [[ ! "$2" =~ ^[0-9]+$ ]]; then
        echo "Requiere un valor numérico positivo."
        exit 1
    else
        network_monitoring "$2"
    fi
else
    echo "En caso de querer utilizar el script con parámetros de entrada es con -n cantidad,donde cantidad define las veces que se repite el monitoreo."
fi

#Function to display the menu
show_menu() {
    echo ""
    echo "======= MENÚ ======="
    echo "1- Monitorear la red en vivo."
    echo "2- Monitorear la red una cantidad predeterminada"
    echo "3- Generar un reporte"
    echo "4- Ver reportes existentes"
    echo "5- Borrar todos los reportes"
    echo "6- Salir"
}

#Validate the option chosen by the user
while true; do
    show_menu
    read -p "Elige una opción: " choice
    case $choice in
        1)
            #View monitoring indefinitely
            ifstat &
            PROCESS_PID=$!
            echo "Presiona ENTER para salir"          
            read -r userInput
            kill $PROCESS_PID
            ;;
        2)
            #View the monitoring a defined number of times
            read -p "Ingrese la cantidad de veces que quiere ver el monitoreo: " num
            network_monitoring $num
            ;;
        3)
            #Ask for the filename and the number of times
            read -p "Ingrese el nombre del reporte (sin extensión): " file
            read -p "Ingrese la cantidad de veces que quiere ver el monitoreo: " num
            #Redirect the output to a file in reports directory
            if ! network_monitoring $num > "$REPORTS_DIR/$file.txt"; then
                echo "Error: No se pudo generar el archivo"
                exit 1
            else
                echo "El reporte '$file.txt' ha sido generado en $REPORTS_DIR/"
            fi
            ;;
        4)
            #List existing reports
            echo "Reportes existentes:"
            ls -l "$REPORTS_DIR" 2>/dev/null || echo "No hay reportes disponibles."
            ;;
        5)
            #Delete all reports
            delete_reports
            ;;
        6)
            echo "Saliendo"
            exit 0
            ;;
        *)
            echo "Opción no válida, intenta de nuevo."
            ;;
    esac
done