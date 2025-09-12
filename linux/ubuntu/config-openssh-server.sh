#!/bin/bash
#
# This script should be run via curl:
#   sudo apt-get -y update && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/awkirin/awk-snippets/main/linux/ubuntu/config-openssh-server.sh)"

set -euo pipefail

sudo tee /etc/ssh/sshd_config.d/1000-awkirin-security.conf > /dev/null <<EOF
# ========== Базовые настройки ==========
# Вход только по ключам, без пароля
PasswordAuthentication no
PermitRootLogin no

# PAM оставляем включённым для совместимости с системой
UsePAM yes

# ========== Дополнительная безопасность ==========
PermitEmptyPasswords no          # запрет пустых паролей
MaxAuthTries 3                   # максимум попыток логина
IgnoreRhosts yes                 # игнорирование .rhosts
# StrictModes yes                  # проверка прав на файлы пользователя
UseDNS no                        # ускоряет логин, не проверяя DNS
PermitUserEnvironment no         # отключаем переменные окружения

# ========== Ограничение форвардинга ==========
X11Forwarding no
AllowTcpForwarding no
# AllowAgentForwarding no

# ========== Логирование ==========
# LogLevel VERBOSE
EOF


sudo systemctl enable ssh
sudo systemctl reload ssh
