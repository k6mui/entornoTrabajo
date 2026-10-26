#!/usr/bin/env bash
# Instala todos los paquetes apt instalados manualmente en la máquina original
set -euo pipefail
source "$(dirname "$0")/lib.sh"

step "Paquetes APT"

export DEBIAN_FRONTEND=noninteractive
sudo apt-get update

if [[ "${SKIP_UPGRADE:-0}" != "1" ]]; then
  info "Actualizando el sistema (full-upgrade)..."
  sudo apt-get -y full-upgrade
fi

# Lista de paquetes: apt-manual.txt + extras (cabeceras del kernel actual, ninja para picom...)
mapfile -t PKGS < <(grep -vE '^\s*(#|$)' "$REPO_DIR/packages/apt-manual.txt"; \
                    grep -vE '^\s*(#|$)' "$REPO_DIR/packages/apt-extra.txt")
PKGS+=("linux-headers-$(uname -r)")

# Filtra los que no existen en los repos para que apt no aborte
AVAILABLE=(); MISSING=()
for p in "${PKGS[@]}"; do
  if apt-cache show "$p" >/dev/null 2>&1; then AVAILABLE+=("$p"); else MISSING+=("$p"); fi
done

info "Instalando ${#AVAILABLE[@]} paquetes..."
if ! sudo apt-get install -y "${AVAILABLE[@]}"; then
  warn "La instalación en bloque falló, instalando uno a uno..."
  for p in "${AVAILABLE[@]}"; do
    sudo apt-get install -y "$p" || MISSING+=("$p")
  done
fi

if (( ${#MISSING[@]} )); then
  warn "Paquetes no instalados: ${MISSING[*]}"
fi
ok "Paquetes APT instalados"
