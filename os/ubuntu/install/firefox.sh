# удалить snap
#sudo apt autoremove --purge snapd
#sudo apt purge snapd
#sudo rm -rf ~/snap /snap /var/snap /var/lib/snapd

sudo apt install extrepo -y
sudo extrepo enable mozilla -y
sudo apt update -y

sudo tee /etc/apt/preferences.d/firefox <<EOF
Package: firefox
Pin: origin packages.mozilla.org
Pin-Priority: 1001
EOF

sudo snap remove firefox -y
sudo apt install firefox -y
