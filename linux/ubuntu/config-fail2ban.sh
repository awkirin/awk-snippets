#!/bin/bash
#
# This script should be run via curl:
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/awkirin/awk-snippets/main/linux/ubuntu/config-fail2ban.sh)"

set -euo pipefail

sudo tee /etc/fail2ban/jail.d/1000-awkirin.conf > /dev/null <<EOF
[sshd]
enabled   = true
port      = ssh
logpath   = %(sshd_log)s
backend   = systemd
maxretry  = 3
bantime   = 60m
findtime  = 10m
EOF


sudo systemctl restart fail2ban
