#!/usr/bin/env bash
# =====================================================================
#  entornoTrabajo - Replica el entorno Kali + bspwm de k6mui
#  Uso:  ./install.sh            (instalación completa)
#        ./install.sh 03 05      (solo los pasos indicados)
#  Variables: SKIP_UPGRADE=1 para no hacer full-upgrade
# =====================================================================
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$REPO_DIR/scripts/lib.sh"

if [[ $EUID -eq 0 ]]; then
  error "Ejecuta el script como tu usuario normal (no root). Pedirá sudo cuando haga falta."
  exit 1
fi

if ! grep -qi kali /etc/os-release; then
  warn "Esta máquina no parece Kali Linux. Continúo igualmente en 5s (Ctrl+C para cancelar)..."
  sleep 5
fi

# Pide sudo una vez y lo mantiene vivo durante la instalación
sudo -v
( while true; do sudo -n true; sleep 50; kill -0 "$$" 2>/dev/null || exit; done ) 2>/dev/null &
SUDO_KEEPALIVE=$!
trap 'kill $SUDO_KEEPALIVE 2>/dev/null || true' EXIT

STEPS=("$REPO_DIR"/scripts/0*.sh)
if (( $# )); then
  STEPS=()
  for n in "$@"; do STEPS+=("$REPO_DIR"/scripts/"$n"-*.sh); done
fi

for s in "${STEPS[@]}"; do
  bash "$s"
done

step "¡Listo!"
ok "Entorno replicado. Cierra sesión y entra con la sesión 'bspwm' (o reinicia)."
warn "Si estás en VMware y la resolución no es 1920x1080: super+alt+r la fuerza (xrandr Virtual-1)."
