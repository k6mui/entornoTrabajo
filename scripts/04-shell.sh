#!/usr/bin/env bash
# Zsh + Powerlevel10k + plugins para el usuario y para root
set -euo pipefail
source "$(dirname "$0")/lib.sh"

step "Zsh / Powerlevel10k"

# Powerlevel10k para el usuario y root
if [[ ! -d "$TARGET_HOME/.powerlevel10k" ]]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$TARGET_HOME/.powerlevel10k"
fi
if ! sudo test -d /root/.powerlevel10k; then
  sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.powerlevel10k
fi

# Plugin zsh-sudo (doble ESC antepone sudo)
sudo mkdir -p /usr/share/zsh-sudo
sudo install -m 644 "$REPO_DIR/system/usr/share/zsh-sudo/sudo.plugin.zsh" /usr/share/zsh-sudo/

# Root comparte la .zshrc del usuario y tiene su propia copia de .p10k.zsh
sudo ln -sfn "$TARGET_HOME/.zshrc" /root/.zshrc
sudo install -m 644 "$REPO_DIR/dotfiles/home/.p10k.zsh" /root/.p10k.zsh

# Shell por defecto zsh
sudo chsh -s /usr/bin/zsh "$TARGET_USER"
sudo chsh -s /usr/bin/zsh root

ok "Zsh configurado (usuario y root)"
