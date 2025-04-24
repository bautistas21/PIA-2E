# Descripción
Este entregable consiste en 2 scripts que realizan tareas de ciberseguridad, fueron realizados en Bash : 
- *network_monitoring.sh:* Escanea los puertos abiertos de algún dominio o ip deseado, para después indicar si están cerrados o abiertos, también es posible generar un reporte.
- *port_scanner.sh:* Monitorea el uso de la red, puedes hacerlo mendiante un tiempo indefinido o cierta cantidad de veces, al igual que el script anterior, también genera reportes.
# Requisitos
Para poder hacer uso de los scripts es necesario:
- Contar con una bash shell
- Tener instalado *ifstat* y *nmap*
## Instalación de ifstat y nmap
```
sudo apt update && sudo apt install ifstat nmap -y
```
Para verificar que se hayan instalado correctamente
```
ifstat --version
nmap --version
```
# Uso de los scripts
Para hacer uso de los scripts después de haber verificado que cumples con los requisitos, solo es necesario ejectuarlos.
```
./network_monitoring.sh
```

```
./port_scanner.sh
```
En caso de no poder ejecutarlos, tenemos que asignarles permisos de ejecución con los siguientes comandos:

```
chmod +x network_monitoring.sh
chmod +x port_scanner.sh
```
## Parámetros
En caso de querer utilizar los script con parámetros, podemos hacer uso de ellos dependiendo el script:
- Network_monitoring.sh:
  ```
  ./network_monitoring.sh -n #
  ```
  En este caso el parámetro -n indica la cantidad de veces que se repetirá el escaneo de la red, por lo que se tiene que reemplazar el # con el número deseado de veces.
- Port_scanner.sh
  ```
  ./port_scanner.sh -p 1-500 -i google.com
  ```
  *Parámetros:*
  - -p: Indica el rango de puertos que se escanearán.
  - -i: Indica la IP o el dominio cuyos puertos se escanearán.
  - -r: Indica que se generará un reporte automaticamente al terminar el escaneo de puertos.
  - -u: Indica que el escaneo será de puertos UDP (En caso de no indicarlo será un escaneo de puertos TCP).
  **Es importante que en caso de realizar un escaneo de puertos UDP con el parámetro -u, ejecutar el script con sudo.**
