#!/bin/bash
#
# This script should be run via curl:
#   sudo apt-get -y update && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/awkirin/awk-snippets/HEAD/install-openssh-server.sh)"
#
# repo: https://github.com/awkirin/awk-snippets

set -euo pipefail


sudo apt-get -y install openssh-server

sudo tee /etc/ssh/sshd_config.d/1000-awkirin-security.conf > /dev/null <<EOF
# base
PasswordAuthentication no
PermitRootLogin no
UsePAM no
EOF

# additional
#PermitEmptyPasswords no
#MaxAuthTries 3
#IgnoreRhosts yes
#StrictModes yes
#UseDNS no
#PermitUserEnvironment no

# strange
#X11Forwarding no
#AllowTcpForwarding no
#AllowAgentForwarding no


sudo systemctl enable ssh
sudo systemctl reload ssh