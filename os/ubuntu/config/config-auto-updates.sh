sudo apt install -y unattended-upgrades distro-info-data powermgmt-base

sudo tee /etc/apt/apt.conf.d/1000awkirin-unattended-upgrades > /dev/null <<EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-WithUsers "true";
Unattended-Upgrade::Automatic-Reboot-Time "03:00";
EOF

sudo systemctl enable apt-daily.timer apt-daily-upgrade.timer
sudo systemctl start apt-daily.timer apt-daily-upgrade.timer
