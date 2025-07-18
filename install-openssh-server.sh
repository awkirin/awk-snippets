#!/bin/bash
#
# This script should be run via curl:
#   sudo apt -y update && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/awkirin/awk-snippets/HEAD/install-openssh-server.sh)"
#
# repo: https://github.com/awkirin/awk-snippets

set -euo pipefail


sudo apt -y install openssh-server

sudo systemctl enable ssh

sudo tee /etc/ssh/sshd_config.d/1000-awkirin-security.conf > /dev/null <<EOF
# base
PasswordAuthentication no
PermitRootLogin no
UsePAM no

# additional
PermitEmptyPasswords no
MaxAuthTries 3
IgnoreRhosts yes
StrictModes yes
UseDNS no
PermitUserEnvironment no

# strange
#X11Forwarding no
#AllowTcpForwarding no
#AllowAgentForwarding no
EOF

sudo systemctl reload ssh



