#!/usr/bin/env bash
# Funciones comunes para los scripts de instalación

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_USER="${TARGET_USER:-$(id -un)}"
TARGET_HOME="${TARGET_HOME:-$(getent passwd "$TARGET_USER" | cut -d: -f6)}"
BUILD_DIR="$TARGET_HOME/github"
BACKUP_DIR="$TARGET_HOME/.entornoTrabajo-backup/$(date +%F-%H%M%S)"

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'

info()  { echo -e "${BLUE}[*]${NC} $*"; }
ok()    { echo -e "${GREEN}[+]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
error() { echo -e "${RED}[x]${NC} $*" >&2; }
step()  { echo -e "\n${GREEN}==================== $* ====================${NC}"; }

# Sustituye los marcadores __HOME__ / __USER__ en un fichero de texto
render_placeholders() {
  local f="$1"
  if grep -Iq . "$f" 2>/dev/null && grep -qE '__HOME__|__USER__' "$f"; then
    sed -i "s#__HOME__#${TARGET_HOME}#g; s#__USER__#${TARGET_USER}#g" "$f"
  fi
}

# Hace copia de seguridad de un fichero/directorio existente antes de sobrescribirlo
backup_path() {
  local p="$1"
  if [[ -e "$p" && ! -L "$p" ]]; then
    local rel="${p#"$TARGET_HOME"/}"
    mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
    cp -a "$p" "$BACKUP_DIR/$rel"
  fi
}
