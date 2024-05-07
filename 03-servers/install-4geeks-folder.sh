git clone  -C $HOME/cybersecurity-scripts https://github.com/4GeeksAcademy/cybersecurity-scripts.git

echo "@reboot bash $HOME/cybersecurity-scripts/update-folder.sh" | crontab -