# entornoTrabajo

Replica mi entorno de Kali Linux (bspwm + sxhkd + polybar + picom + kitty + zsh/p10k) en una máquina Kali nueva.

## Uso rápido

En una Kali recién instalada, **como tu usuario normal** (no root):

```bash
sudo apt update && sudo apt install -y git
git clone https://github.com/k6mui/entornoTrabajo.git   # o por SSH si tienes la clave
cd entornoTrabajo
./install.sh
```

Al terminar, cierra sesión y entra con la sesión **bspwm**.

Opciones:

```bash
SKIP_UPGRADE=1 ./install.sh   # no hace full-upgrade del sistema
./install.sh 03 05            # ejecuta solo los pasos 03 (fuentes) y 05 (dotfiles)
```

## Qué hace cada paso

| Script | Qué hace |
|---|---|
| `scripts/01-packages.sh` | `full-upgrade` + todos los paquetes instalados a mano en la máquina original (`packages/apt-manual.txt` + `packages/apt-extra.txt`): bspwm, sxhkd, polybar, kitty, rofi, feh, lsd, bat, neovim, docker, seclists, nuclei, aircrack-ng, mdk4, driver rtl88xxau... |
| `scripts/02-build.sh` | Compila **picom (fork de ibhagwan)** en `/usr/local/bin`, clona polybar en `~/github` e instala kitty 0.26.2 en `/opt/kitty` |
| `scripts/03-fonts.sh` | Nerd Fonts Hack, 3270 y Hurmit (v2.3.3) en `/usr/local/share/fonts` + fuentes de polybar |
| `scripts/04-shell.sh` | Powerlevel10k para usuario y root, plugin zsh-sudo, zsh como shell por defecto, `.zshrc` de root enlazada a la del usuario |
| `scripts/05-dotfiles.sh` | Copia `dotfiles/home` a tu `$HOME` (con backup en `~/.entornoTrabajo-backup/`) e instala `settarget`, `screenshot`, `kitty_start`, `whichSystem.py` en `/usr/local/bin` |
| `scripts/06-system.sh` | Teclado `es`, locale `es_ES.UTF-8`, sesión por defecto bspwm, grupo wireshark |

Las rutas `/home/<usuario>` de los configs están guardadas como `__HOME__` / `__USER__` y se sustituyen al instalar, así que funciona con cualquier nombre de usuario.

## Mantener el repo actualizado

Desde la máquina "buena", cuando cambies algo:

```bash
./export.sh
git add -A && git commit -m "Actualiza config" && git push
```

## Datos personales (no están en GitHub)

`Escritorio`, `Descargas`, etc. contienen VPNs de HTB, labs y certificados, así que **no se suben al repo**. Para copiarlos de la máquina original a la nueva por SSH:

```bash
# En la original:  sudo systemctl start ssh
# En la nueva:
./sync-personal.sh k6mui@IP_DE_LA_ORIGINAL
```

## Atajos principales (sxhkd)

| Atajo | Acción |
|---|---|
| `super + Enter` | kitty |
| `super + d` | rofi |
| `super + w` | cerrar ventana |
| `super + {1-0}` | cambiar de escritorio |
| `super + shift + f` / `b` | Firefox / Burp Suite |
| `super + alt + flechas` | redimensionar ventana |
| `super + alt + r` | reiniciar bspwm (y forzar 1920x1080) |
| `Print` | captura de pantalla (`~/ScreenShots`) |

## Funciones de zsh útiles

`settarget <IP> <nombre>` · `extractPorts <fichero>` · `mkt` · `fzf-lovely` · `rmk <fichero>`
