#!/usr/bin/env bash
# Vuelca la configuración ACTUAL de esta máquina al repo (para mantenerlo al día).
# Uso: ./export.sh && git add -A && git commit -m "Actualiza config" && git push
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOT="$REPO_DIR/dotfiles/home"
CONFIG_DIRS=(bspwm sxhkd kitty polybar picom rofi bin Wallpaper fastfetch nvim cherrytree wfuzz
             powershell qterminal.org wireshark xfce4 gtk-3.0 Mousepad)

for d in "${CONFIG_DIRS[@]}"; do
  [[ -d "$HOME/.config/$d" ]] || continue
  rm -rf "$DOT/.config/$d"
  cp -r "$HOME/.config/$d" "$DOT/.config/"
done
cp "$HOME"/.config/user-dirs.{dirs,locale} "$DOT/.config/"
cp "$HOME"/{.zshrc,.p10k.zsh,.fehbg,.dmrc} "$DOT/"
rm -rf "$DOT/Wallpaper" && cp -r "$HOME/Wallpaper" "$DOT/Wallpaper"
mkdir -p "$DOT/.BurpSuite" && cp "$HOME/.BurpSuite/UserConfig.json" "$DOT/.BurpSuite/"
: > "$DOT/.config/bin/target"

for f in settarget screenshot kitty_start whichSystem.py; do
  cp "/usr/local/bin/$f" "$REPO_DIR/system/usr/local/bin/"
done
cp /usr/share/zsh-sudo/sudo.plugin.zsh "$REPO_DIR/system/usr/share/zsh-sudo/"

apt-mark showmanual | grep -vE '^linux-(headers|image)-[0-9]' > "$REPO_DIR/packages/apt-manual.txt"

# Rutas del usuario -> marcadores genéricos
grep -rIl "$HOME" "$DOT" "$REPO_DIR/system" | xargs -r sed -i "s#$HOME#__HOME__#g"
sed -i "s#chown $USER:$USER#chown __USER__:__USER__#" "$REPO_DIR/system/usr/local/bin/settarget"

echo "[+] Exportado. Revisa con: git -C '$REPO_DIR' status"
