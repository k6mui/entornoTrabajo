#!/usr/bin/env bash
# Copia los dotfiles al home y los scripts de sistema a /usr/local/bin
set -euo pipefail
source "$(dirname "$0")/lib.sh"

step "Dotfiles"

SRC="$REPO_DIR/dotfiles/home"

# Copia fichero a fichero (con backup del original) y sustituye marcadores
while IFS= read -r -d '' f; do
  rel="${f#"$SRC"/}"
  dest="$TARGET_HOME/$rel"
  backup_path "$dest"
  mkdir -p "$(dirname "$dest")"
  cp -f --preserve=mode "$f" "$dest"
  render_placeholders "$dest"
done < <(find "$SRC" -type f -print0)

# Permisos de ejecución de scripts
chmod +x "$TARGET_HOME/.config/bspwm/bspwmrc" \
         "$TARGET_HOME/.config/bspwm/scripts/"* \
         "$TARGET_HOME/.config/polybar/launch.sh" \
         "$TARGET_HOME/.config/polybar/scripts/"{launcher,powermenu,powermenu_alt} \
         "$TARGET_HOME/.config/bin/"*.sh \
         "$TARGET_HOME/.fehbg"
chmod 600 "$TARGET_HOME/.BurpSuite/UserConfig.json" "$TARGET_HOME/.config/user-dirs.dirs"

# Directorios de trabajo
xdg-user-dirs-update || true
mkdir -p "$TARGET_HOME"/{ScreenShots,github,Proyectos}

[[ -d "$BACKUP_DIR" ]] && info "Ficheros originales respaldados en $BACKUP_DIR"
ok "Dotfiles copiados"

step "Scripts de sistema (/usr/local/bin)"
for f in "$REPO_DIR"/system/usr/local/bin/*; do
  name="$(basename "$f")"
  tmp="$(mktemp)"
  cp "$f" "$tmp"
  render_placeholders "$tmp"
  sudo install -m 755 "$tmp" "/usr/local/bin/$name"
  rm -f "$tmp"
done
ok "settarget, screenshot, kitty_start y whichSystem.py instalados"
