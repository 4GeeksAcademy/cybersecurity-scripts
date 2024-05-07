cd $$HOME

git clone https://github.com/4GeeksAcademy/cybersecurity-scripts.git

cd cybersecurity-scripts

echo "@reboot bash $HOME/cybersecurity-scripts/update-folder.sh" | crontab -