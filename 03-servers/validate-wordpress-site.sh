#!/bin/bash

apache_status=$(eval "systemctl status apache2|grep active");

mariadb_status=$(eval "systemctl status mariadb|grep active");

site_data=$(eval "curl -s http://localhost/wordpress/index.php/wp-json/wp-site-health/v1");

url=$1
if [ -z $1 ];then
  # URL de la petición POST (reemplaza con la URL de tu servidor)
  echo "Ingrese la dirección de learnpack"
  echo "Type learnpack address"
  read url
fi

data='{"apacheStatus":"'$apache_status'","databaseStatus":"'$mariadb_status'","siteData":'$site_data'}'

#echo $data

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