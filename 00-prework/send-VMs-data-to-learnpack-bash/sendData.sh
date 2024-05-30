#!/bin/bash

echo "Paste here your learnpack url:"
read url
echo "---------">data.txt

while read -r line; do
  # Tomar el nombre de la maquina de la linea
  vm_name=$(echo $line | awk '{print $1}')
  vm_name=${vm_name//\"/}

  # Ejecutar el comando para la máquina virtual y volcar la salida a data.txt
  VBoxManage showvminfo $vm_name --machinereadable >> data.txt
  echo "---------">>data.txt

  #echo "Información de la máquina virtual $vm_name:"

done < <(VBoxManage list vms)

curl -X POST \
  -F "file=@data.txt" \
  "$url"

rm -f data.txt