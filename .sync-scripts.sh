#!/bin/bash

# Cambiar al directorio del proyecto
cd /home/deb/Escritorio/cybersecurity-scrpits

# Actualizar la rama local
git reset --hard origin/main
git pull --allow-unrelated-histories origin main >>/home/deb/.sync-scripts.log 2> /home/deb/.sync-scripts.error.log

if [[ $? -ne 0 ]]; then
  echo "Error: Script failed with exit code $?"
  exit 1  # Exit with a non-zero code to signal failure
fi

fecha_hora=$(date +"%Y-%m-%d %H:%M:%S")

# Agregar la marca temporal al script
echo "$fecha_hora:"

# Mostrar mensaje de éxito
echo "Pull realizado correctamente para la rama main"
echo "______________________________________________"
