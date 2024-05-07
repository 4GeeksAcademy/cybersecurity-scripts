#!/bin/bash

function generar_arreglo_json() {
  # Verificar si se proporcionó un comando
  if [ $# -eq 0 ]; then
    echo "Error: Se debe especificar un comando."
    return 1
  fi

  # Ejecutar el comando y capturar la salida
  comando="$1"
  salida=$(eval "$comando")

  # Inicializar el arreglo JSON
  array=()

  # Convertir cada línea de salida en un objeto JSON y agregarlo al arreglo
  while read -r line; do
    array+=("\"$line\"")
  done <<< "$salida"

  # Imprimir el arreglo JSON
  echo "[$(IFS=','; echo "${array[*]}")]"
}

comando="dpkg -l |grep virtualbox-guest"
virtualboxGuest=$(generar_arreglo_json "$comando");

comando="cat /etc/os-release | sed 's/\"//g' "
osData=$(generar_arreglo_json "$comando");

fecha_hora=$(date +"%Y-%m-%d %H:%M:%S")

data='{"virtualboxExtension":'$virtualboxGuest',"osData":'$osData',"timestamp":"'$fecha_hora'"}'

# Parametros de la petición
cabeceras="Content-Type: application/json"
if [ ! -z "$2" ]; then
  echo "Data:"
  echo "$data"
fi
echo "_______________________________________________________"

url=$1
if [ -z $1 ];then
  # URL de la petición POST (reemplaza con la URL de tu servidor)
  echo "Ingrese la dirección de learnpack"
  echo "Type learnpack address"
  read url
fi

curl -X POST --json "$data" -H "$cabeceras" $url

# Verificar la respuesta del servidor
if [ $? -ne 0 ]; then
  echo "Error: La petición POST falló."
  exit 1
else
  echo "Archivo enviado correctamente."
fi
