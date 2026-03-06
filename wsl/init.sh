sudo apt update -y && sudo apt upgrade -y

sudo apt install -y nautilus git curl wget zsh age

WSL2_SSH_AGENT_PATH="/usr/local/bin/wsl2-ssh-agent"
sudo curl -L -o "$WSL2_SSH_AGENT_PATH" https://github.com/mame/wsl2-ssh-agent/releases/latest/download/wsl2-ssh-agent
sudo chmod 755 "$WSL2_SSH_AGENT_PATH"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

cat << 'EOF' > "$HOME/.oh-my-zsh/custom/awkirin.zsh"
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

