#!/usr/bin/env bash
# Ajustes de sistema: teclado, idioma, sesión bspwm, grupos
set -euo pipefail
source "$(dirname "$0")/lib.sh"

step "Ajustes de sistema"

# Teclado español
sudo sed -i 's/^XKBLAYOUT=.*/XKBLAYOUT="es"/; s/^XKBMODEL=.*/XKBMODEL="pc105"/' /etc/default/keyboard
sudo setupcon -k --force 2>/dev/null || true

# Idioma es_ES.UTF-8
sudo sed -i 's/^# *es_ES.UTF-8 UTF-8/es_ES.UTF-8 UTF-8/' /etc/locale.gen
sudo locale-gen >/dev/null
sudo update-locale LANG=es_ES.UTF-8

# Sesión por defecto bspwm en LightDM
if [[ -d /var/lib/AccountsService/users ]]; then
  sudo tee "/var/lib/AccountsService/users/$TARGET_USER" >/dev/null <<EOF
[User]
Session=bspwm
XSession=bspwm
SystemAccount=false
EOF
fi

# Grupos
for g in wireshark; do
  if getent group "$g" >/dev/null; then sudo usermod -aG "$g" "$TARGET_USER"; fi
done

sudo updatedb 2>/dev/null || true
ok "Sistema configurado"
