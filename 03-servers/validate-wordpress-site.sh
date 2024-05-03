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

$command="cat /var/www/html/wordpress/wp-config.php| grep DB"
db_config=$(generar_arreglo_json "$comando");

$command="systemctl status apache2|grep active"
apache_status=$($comando);

$command="systemctl status mariadb|grep active"
mariadb_status=$($comando);

$command="curl http://localhost/wordpress/index.php/wp-json/wp-site-health/v1"
site_data=$($comando);

url=$1
if [ -z $1 ];then
  # URL de la petición POST (reemplaza con la URL de tu servidor)
  echo "Ingrese la dirección de learnpack"
  echo "Type learnpack address"
  read url
fi

data='{"databaseConfig":'$db_config',"apacheStatus":"'$apache_status'","databaseStatus":"'$mariadb_status'","siteData":'$site_data'}'


cabeceras="Content-Type: application/json"
# Enviar la petición POST usando curl
curl -X POST --json "$data" -H "$cabeceras" $url

# Verificar la respuesta del servidor
if [ $? -ne 0 ]; then
  echo "Error: La petición POST falló."
  exit 1
else
  echo "Data enviada correctamente."
fi
