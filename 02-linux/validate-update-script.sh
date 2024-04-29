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

# Crontab Info
comando="crontab -l | grep -v \#"
crontab_data=$(generar_arreglo_json "$comando");

if [ ! -z "$3" ]; then
  echo "Crontab data: $crontab_data"
fi

archivo=$1
if [ -z $1 ];then
  # Solicitar la dirección del archivo al usuario
  echo "Ingrese el nombre del script inluyendo la ruta completa"
  echo "Type the file name including the full path "
  read archivo
  if [ ! -z "$3" ]; then
    echo "Ruta archivo: $archivo"
  fi
fi

# Verificar si el archivo existe
if [ ! -f "$archivo" ]; then
  echo "Error: The script '$archivo' doesn't exists."
  exit 1
fi

# Leer el contenido del archivo
contenido_archivo=$(base64 "$archivo")
if [ ! -z "$3" ]; then
  echo $contenido_archivo
fi
echo "_______________________________________________________"

url=$2
if [ -z $2 ];then
  # URL de la petición POST (reemplaza con la URL de tu servidor)
  echo "Ingrese la dirección de learnpack"
  echo "Type learnpack address"
  read url
fi

fecha_hora=$(date +"%Y-%m-%d %H:%M:%S")

# Update data
comando="stat /var/cache/apt/pkgcache.bin | head -n 6 | tail -n 2"
update_data=$(generar_arreglo_json "$comando");


# Parametros de la petición
cabeceras="Content-Type: application/json"
data='{"scriptText":"'$contenido_archivo'","crontabData":'$crontab_data', "scriptFile":"'$archivo'","timestamp":"'$fecha_hora'","updateData":'$update_data'}'
if [ ! -z "$3" ]; then
  echo "Data:"
  echo "$data"
fi
echo "_______________________________________________________"

# Enviar la petición POST usando curl
curl -X POST --json "$data" -H "$cabeceras" $url

# Verificar la respuesta del servidor
if [ $? -ne 0 ]; then
  echo "Error: La petición POST falló."
  exit 1
else
  echo "Archivo enviado correctamente."
fi
