sudo apt install -y unattended-upgrades

sudo systemctl enable apt-daily.timer apt-daily-upgrade.timer
sudo systemctl start apt-daily.timer apt-daily-upgrade.timer

#sudo dpkg-reconfigure -plow unattended-upgrades
