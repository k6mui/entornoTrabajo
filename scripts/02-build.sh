#!/usr/bin/env bash
# Compila picom (fork de ibhagwan, con esquinas redondeadas) e instala kitty en /opt
set -euo pipefail
source "$(dirname "$0")/lib.sh"

PICOM_REPO="https://github.com/ibhagwan/picom.git"
PICOM_COMMIT="c4107bb"
POLYBAR_REPO="https://github.com/polybar/polybar"
KITTY_OPT_VERSION="0.26.2"

mkdir -p "$BUILD_DIR"

# ---------- picom (ibhagwan) -> /usr/local/bin/picom ----------
step "picom (ibhagwan fork)"
if [[ ! -d "$BUILD_DIR/picom/.git" ]]; then
  git clone "$PICOM_REPO" "$BUILD_DIR/picom"
fi
cd "$BUILD_DIR/picom"
git fetch --all -q || true
git checkout -q "$PICOM_COMMIT"
git submodule update --init --recursive
meson setup --buildtype=release --wipe build . 2>/dev/null || meson setup --buildtype=release build .
ninja -C build
sudo ninja -C build install
ok "picom instalado en $(command -v picom)"

# ---------- polybar (clon de referencia, se usa el paquete apt) ----------
step "polybar (clon de referencia)"
if [[ ! -d "$BUILD_DIR/polybar/.git" ]]; then
  git clone --recursive "$POLYBAR_REPO" "$BUILD_DIR/polybar"
fi
ok "polybar clonado en $BUILD_DIR/polybar (binario desde apt)"

# ---------- kitty binario oficial en /opt/kitty ----------
step "kitty $KITTY_OPT_VERSION en /opt/kitty"
if [[ ! -x /opt/kitty/bin/kitty ]]; then
  tmp="$(mktemp -d)"
  wget -q --show-progress -O "$tmp/kitty.txz" \
    "https://github.com/kovidgoyal/kitty/releases/download/v${KITTY_OPT_VERSION}/kitty-${KITTY_OPT_VERSION}-x86_64.txz"
  sudo mkdir -p /opt/kitty
  sudo tar -xJf "$tmp/kitty.txz" -C /opt/kitty
  rm -rf "$tmp"
fi
ok "kitty en /opt/kitty (el de apt sigue siendo /usr/bin/kitty)"
