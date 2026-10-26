#!/usr/bin/env bash
# Copia tus carpetas personales (Escritorio, Descargas...) desde la máquina ORIGINAL
# por SSH. Estos datos NO se suben a GitHub (VPNs, labs, certificados...).
#
# Uso (en la máquina NUEVA):  ./sync-personal.sh usuario@ip-maquina-original
# Requiere: openssh-server activo en la original (sudo systemctl start ssh)
set -euo pipefail

SRC="${1:?Uso: $0 usuario@ip-maquina-original}"
DIRS=(Escritorio Descargas Documentos Imágenes Proyectos Música Vídeos Plantillas Público)

command -v rsync >/dev/null || sudo apt-get install -y rsync

for d in "${DIRS[@]}"; do
  echo "[*] Sincronizando ~/$d ..."
  rsync -avh --info=progress2 "$SRC:~/$d/" "$HOME/$d/" || \
    echo "[!] Algunos ficheros de $d no se pudieron copiar (¿propiedad de root en la original?)"
done
sudo chown -R "$USER:$USER" "${DIRS[@]/#/$HOME/}" 2>/dev/null || true
echo "[+] Datos personales sincronizados"
