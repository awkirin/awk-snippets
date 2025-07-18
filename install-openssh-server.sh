#!/bin/bash
#
# This script should be run via curl:
#   sudo apt -y update && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/awkirin/awk-scripts/main/install-openssh-server.sh)"
#
# repo: https://github.com/awkirin/awk-scripts

set -euo pipefail


sudo apt -y install openssh-server

if [[ ! -f "/etc/ssh/sshd_config.original" ]]; then
    sudo cp "/etc/ssh/sshd_config" ""/etc/ssh/sshd_config.original"
fi

sudo systemctl enable ssh
sudo systemctl restart ssh


#PasswordAuthentication yes -> PasswordAuthentication no

PermitRootLogin no
UsePAM no