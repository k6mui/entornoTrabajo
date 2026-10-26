#!/usr/bin/env bash
# Instala las Nerd Fonts (Hack, 3270, Hurmit) y las fuentes de polybar
set -euo pipefail
source "$(dirname "$0")/lib.sh"

NERD_VERSION="v2.3.3"
NERD_FONTS=(Hack 3270 Hermit)

step "Fuentes"

# Nerd Fonts -> /usr/local/share/fonts (versión 2.x: nombres "Nerd Font Complete")
tmp="$(mktemp -d)"
for font in "${NERD_FONTS[@]}"; do
  info "Descargando $font Nerd Font ($NERD_VERSION)..."
  wget -q --show-progress -O "$tmp/$font.zip" \
    "https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_VERSION}/${font}.zip"
  sudo unzip -oq "$tmp/$font.zip" -d /usr/local/share/fonts
done
rm -rf "$tmp"

# Fuentes de polybar -> /usr/share/fonts/truetype
sudo cp -f "$REPO_DIR"/dotfiles/home/.config/polybar/fonts/* /usr/share/fonts/truetype/

sudo fc-cache -f >/dev/null
ok "Fuentes instaladas"
