#!/bin/bash
#
# This script should be run via curl:
#   sudo apt-get -y update && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/awkirin/awk-scripts/main/install-wsl-xrdp-xfce4.sh)"
#
# repo: https://github.com/awkirin/awk-scripts

set -euo pipefail


sudo apt-get -y install xrdp xfce4 xfce4-goodies

if [[ ! -f "/etc/xrdp/xrdp.ini.bak" ]]; then
    sudo cp /etc/xrdp/xrdp.ini /etc/xrdp/xrdp.ini.bak
fi

sudo sed -i 's/3389/3390/g' /etc/xrdp/xrdp.ini
sudo sed -i 's/max_bpp=32/#max_bpp=32\nmax_bpp=128/g' /etc/xrdp/xrdp.ini
sudo sed -i 's/xserverbpp=24/#xserverbpp=24\nxserverbpp=128/g' /etc/xrdp/xrdp.ini
echo xfce4-session > ~/.xsession

sudo sed -i 's|^test -x /etc/X11/Xsession && exec /etc/X11/Xsession|# &|' /etc/xrdp/startwm.sh
sudo sed -i 's|^exec /bin/sh /etc/X11/Xsession|# &|' /etc/xrdp/startwm.sh

sudo /etc/init.d/xrdp start
