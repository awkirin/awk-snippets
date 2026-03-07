#!/bin/bash

TZ=${TZ:-"Europe/Moscow"}

sudo apt update -y && sudo apt upgrade -y
sudo apt install -y git curl wget zsh age zip unzip gh htop jq nautilus build-essential ca-certificates net-tools openssh-client

sudo timedatectl set-timezone ${TZ}


sudo apt install ansible -y

#
#  - | # chezmoi
#    sudo -u awkirin sh -c "$(curl -fsSL get.chezmoi.io)" -- init --apply awkirin/awk-dotfiles-ubuntu


  # - | # vagrant
  # wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  # echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  # sudo apt update
  # sudo apt install vagrant

#  - | # docker
#    sudo sh -c "$(curl -fsSL get.docker.com)"
#    systemctl enable docker
#    systemctl start docker

#  - | # lando
#    sudo -u awkirin /bin/bash -c "$(curl -fsSL get.lando.dev/setup-lando.sh) --yes"

  # - | # google chrome
  # wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  # sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
  # sudo apt-get update
  # sudo apt-get install google-chrome-stable


#  - | # keepassxc
#    sudo add-apt-repository ppa:phoerious/keepassxc
#    sudo apt update
#    sudo apt install keepassxc -y



sudo tee "/etc/wsl.conf" > /dev/null << 'EOF'
[boot]
systemd = true

[user]
default = awkirin

[interop]
appendWindowsPath = false

[automount]
enabled = true
root = /mnt
options = "metadata,umask=22,fmask=11"
#mountFsTab = true
EOF

WSL2_SSH_AGENT_PATH="/usr/local/bin/wsl2-ssh-agent"
sudo curl -L -o "$WSL2_SSH_AGENT_PATH" https://github.com/mame/wsl2-ssh-agent/releases/latest/download/wsl2-ssh-agent
sudo chmod 755 "$WSL2_SSH_AGENT_PATH"


# ohmyzsh
sudo apt install -y zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then 
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi
#  - | # oh-my-zsh
#    sudo apt install zsh -y
#    sudo -u awkirin sh -c "$(curl -fsSL install.ohmyz.sh) --unattended"


#  - | # git
#    sudo apt install git -y
#    sudo -u awkirin tee /home/awkirin/.gitconfig > /dev/null <<EOF
#    [user]
#        name = awkirin
#        email = awkirin@yandex.ru
#    [init]
#        defaultBranch = main
#    [core]
#        autocrlf = input
#        quotepath = false
#    [pull]
#        rebase = false
#    [push]
#        default = simple
#        autoSetupRemote = true
#    [color]
#        ui = auto
#    EOF

tee "$HOME/.oh-my-zsh/custom/awkirin.zsh" > /dev/null << 'EOF'
eval $(wsl2-ssh-agent)
EOF

mkdir -p "$HOME/.ssh"
cp "/mnt/c/Users/$USER/.ssh/config" "$HOME/.ssh/config" 2>/dev/null || true
chmod 700 "$HOME/.ssh"
chmod 600 "$HOME/.ssh/config" 2>/dev/null || true

mkdir -p "$HOME/.config/sops/age"
cp "/mnt/c/Users/$USER/.config/sops/age/keys.txt" "$HOME/.config/sops/age/keys.txt" 2>/dev/null || true
chmod 700 "$HOME/.config/sops"
chmod 600 "$HOME/.config/sops/age/keys.txt" 2>/dev/null || true

