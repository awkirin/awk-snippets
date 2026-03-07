#!/bin/bash
set -Eeuo pipefail

TZ=${TZ:-"Europe/Moscow"}
USER_NAME=${USER_NAME:-"awkirin"}
USER_EMAIL=${USER_EMAIL:-"awkirin@gmail.com"}
USER_HOME=$(eval echo "~${USER_NAME}")
IS_WSL=$(grep -qiE "(Microsoft|WSL)" /proc/version && echo 1 || echo 0)

# Чтобы исключить зависание.
export DEBIAN_FRONTEND=noninteractive

function log_info() {
    local msg="$1"
    local timestamp
    timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    # Зеленый цвет для информации
    echo -e "\033[1;32m[INFO] [$timestamp]\033[0m $msg ================================================================="
}


#sudo tee /etc/apt/apt.conf.d/80-retries > /dev/null <<EOF
#Acquire::Retries "5";
#EOF


function add_apt_yandex_mirrors() {
  log_info "add apt yandex mirrors"
  sudo tee /etc/apt/sources.list.d/1000-yandex.list > /dev/null <<EOF
deb https://mirror.yandex.ru/ubuntu/ $(lsb_release -cs) main restricted universe multiverse
deb https://mirror.yandex.ru/ubuntu/ $(lsb_release -cs)-updates main restricted universe multiverse
deb https://mirror.yandex.ru/ubuntu/ $(lsb_release -cs)-backports main restricted universe multiverse
deb https://mirror.yandex.ru/ubuntu/ $(lsb_release -cs)-security main restricted universe multiverse
EOF
}

function install_common() {
  log_info "common"
  # add_apt_yandex_mirrors
  sudo timedatectl set-timezone ${TZ}
  sudo apt update -y && sudo apt upgrade -y #&& sudo apt full-upgrade -y
  sudo apt install -y \
  coreutils \
  dnsutils \
  curl \
  wget \
  zsh \
  age \
  zip \
  unzip \
  gh \
  htop \
  jq \
  build-essential \
  ca-certificates \
  net-tools
}
function install_sops(){
  log_info "sops"
  SOPS_LATEST_VERSION=$(curl -s https://api.github.com/repos/getsops/sops/releases/latest | jq -r ".tag_name")
  sudo curl -L -o /usr/local/bin/sops "https://github.com/getsops/sops/releases/download/$SOPS_LATEST_VERSION/sops-$SOPS_LATEST_VERSION.linux.amd64"
  sudo chmod +x /usr/local/bin/sops

  if [[ "$IS_WSL" -eq 1 ]]; then
    if [[ -f "/mnt/c/Users/$USER_NAME/.config/sops/age/keys.txt" ]]; then
      mkdir -p "$USER_HOME/.config/sops/age"
      cp "/mnt/c/Users/$USER_NAME/.config/sops/age/keys.txt" "$USER_HOME/.config/sops/age/keys.txt" 2>/dev/null || true
      chmod 700 "$USER_HOME/.config/sops"
      chmod 600 "$USER_HOME/.config/sops/age/keys.txt" 2>/dev/null || true
    fi
  fi
}
function install_ohmyzsh() {
  log_info "oh-my-zsh"
  sudo apt install zsh -y
  sudo -u ${USER_NAME} sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  sudo chsh -s $(which zsh) ${USER_NAME}

  if [[ "$IS_WSL" -eq 1 ]]; then
    sudo -u ${USER_NAME} tee "$USER_HOME/.oh-my-zsh/custom/wsl2-ssh-agent.zsh" > /dev/null <<EOF
eval $(wsl2-ssh-agent)
EOF
  fi
}
function install_docker() {
  if [[ "$IS_WSL" -eq 0 ]]; then
    log_info "docker"
    sudo sh -c "$(curl -fsSL get.docker.com)"
    sudo usermod -aG docker ${USER_NAME}
    systemctl enable docker
    systemctl start docker
  fi
}
function install_lando() {
  if [[ "$IS_WSL" -eq 0 ]]; then
    log_info "lando"
    sudo -u ${USER_NAME} /bin/bash -c "$(curl -fsSL get.lando.dev/setup-lando.sh) --yes"
  fi
}
function install_google_chrome() {
  log_info "google chrome"
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
  sudo apt update -y
  sudo apt install -y google-chrome-stable
}
function install_keepassxc() {
  log_info "keepass-xc"
  sudo add-apt-repository -y ppa:phoerious/keepassxc
  sudo apt update -y
  sudo apt install -y keepassxc
}
function install_vagrant() {
  log_info "vagrant"
  wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  sudo apt update
  sudo apt install vagrant
}
function install_git() {
  log_info "git"
  sudo apt install git -y
  sudo -u ${USER_NAME} tee ${USER_HOME}/.gitconfig > /dev/null <<EOF
[user]
  name = ${USER_NAME}
  email = ${USER_EMAIL}
[init]
  defaultBranch = main
[core]
  autocrlf = input
  quotepath = false
[pull]
  rebase = false
[push]
  default = simple
  autoSetupRemote = true
[color]
  ui = auto
EOF
}
function install_openssh_client() {
  sudo apt install -y openssh-client

  if [[ "$IS_WSL" -eq 1 ]]; then
    log_info "wsl"
    log_info "ssh-agent"
    WSL2_SSH_AGENT_PATH="/usr/local/bin/wsl2-ssh-agent"
    sudo curl -L -o "$WSL2_SSH_AGENT_PATH" https://github.com/mame/wsl2-ssh-agent/releases/latest/download/wsl2-ssh-agent
    sudo chmod 755 "$WSL2_SSH_AGENT_PATH"

    if [[ -f "/mnt/c/Users/$USER_NAME/.ssh/config" ]]; then
      log_info "ssh config"
      mkdir -p "$USER_HOME/.ssh"
      cp "/mnt/c/Users/$USER_NAME/.ssh/config" "$USER_HOME/.ssh/config" 2>/dev/null || true
      chmod 700 "$USER_HOME/.ssh"
      chmod 600 "$USER_HOME/.ssh/config" 2>/dev/null || true
    fi
  fi
}
function config_wsl() {
  if [[ "$IS_WSL" -eq 1 ]]; then
    log_info "wsl config"
    sudo tee "/etc/wsl.conf" > /dev/null <<EOF
[boot]
systemd = true

[user]
default = ${USER_NAME}

[interop]
appendWindowsPath = false

[automount]
enabled = true
root = /mnt
options = "metadata,umask=22,fmask=11"
#mountFsTab = true
EOF
  fi
}
function install_xrdp() {
  sudo apt install xrdp -y

  if [[ "$IS_WSL" -eq 1 ]]; then
    if [[ ! -f "/etc/xrdp/xrdp.ini.bak" ]]; then
      sudo cp /etc/xrdp/xrdp.ini /etc/xrdp/xrdp.ini.bak
    fi
    sudo sed -i 's/3389/3390/g' /etc/xrdp/xrdp.ini
    sudo sed -i 's/max_bpp=32/#max_bpp=32\nmax_bpp=128/g' /etc/xrdp/xrdp.ini
    sudo sed -i 's/xserverbpp=24/#xserverbpp=24\nxserverbpp=128/g' /etc/xrdp/xrdp.ini

    # sudo apt install ubuntu-desktop -y
    sudo tee ~/.xsessionrc > /dev/null <<EOF
export GNOME_SHELL_SESSION_MODE=ubuntu
export XDG_CURRENT_DESKTOP=ubuntu:GNOME
export XDG_DATA_DIRS=/usr/share/ubuntu:/usr/local/share:/usr/share:/var/lib/snapd/desktop
export WAYLAND_DISPLAY=
export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg
EOF

    sudo systemctl restart xrdp
  fi
}

install_common
install_openssh_client
install_git
install_ohmyzsh
install_sops
install_docker
install_lando
install_google_chrome
install_keepassxc
install_vagrant
sudo apt install -y ansible nautilus
#install_xrdp



log_info "end"
sudo apt autoremove -y && sudo apt autoclean -y && sudo apt clean && exit