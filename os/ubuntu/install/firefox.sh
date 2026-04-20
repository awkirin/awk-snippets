# удалить snap
#sudo apt autoremove --purge snapd
#sudo apt purge snapd
#sudo rm -rf ~/snap /snap /var/snap /var/lib/snapd

sudo snap remove firefox

sudo tee /etc/apt/preferences.d/firefox <<EOF
Package: firefox
Pin: origin packages.mozilla.org
Pin-Priority: 1001
EOF

sudo apt install extrepo
sudo extrepo enable mozilla

sudo apt update
sudo apt install firefox
