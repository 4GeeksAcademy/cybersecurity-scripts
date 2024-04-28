
os_codename=$(cat /etc/os-release | grep VERSION_CODENAME= | cut -d= -f2 | tr -d '"')

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $os_codename contrib"

wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg --dearmor

sudo apt-get update -y
sudo apt-get install -y virtualbox