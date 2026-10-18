#!/bin/sh
set -eu

# Instalación por usuario: no requiere root y no modifica config.fish.
if [ "$(id -u)" -eq 0 ]; then
    echo "Error: ejecutá este instalador como tu usuario normal, sin su ni sudo." >&2
    exit 1
fi

origen=$(CDPATH= cd "$(dirname "$0")" && pwd)
base=${XDG_CONFIG_HOME:-"$HOME/.config"}
destino="$base/fish/functions"
marca='# rotate-managed: agusc01/rotate'

# Detectar conflictos ANTES de copiar algo.
for nombre in rotar.fish r0.fish r90.fish r180.fish r270.fish; do
    archivo="$destino/$nombre"
    if [ ! -f "$origen/fish/functions/$nombre" ]; then
        echo "Error: falta el archivo del repositorio: fish/functions/$nombre" >&2
        exit 1
    fi
    if [ -L "$archivo" ]; then
        echo "Conflicto: $archivo es un enlace simbólico. No se modifica." >&2
        exit 1
    fi
    if [ -e "$archivo" ] && ! grep -Fq "$marca" "$archivo"; then
        echo "Conflicto: $archivo ya existe y no pertenece a rotate." >&2
        exit 1
    fi
done

mkdir -p "$destino"
for nombre in rotar.fish r0.fish r90.fish r180.fish r270.fish; do
    cp "$origen/fish/functions/$nombre" "$destino/$nombre"
    chmod 644 "$destino/$nombre"
done

echo "rotate instalado en $destino"
echo "Comandos Fish: r0, r90, r180, r270 (o rotar normal|derecha|invertida|izquierda)."
echo "Abrí una terminal Fish nueva o ejecutá los comandos directamente desde Fish."

for comando in fish xrandr xinput; do
    if ! command -v "$comando" >/dev/null 2>&1; then
        echo "Aviso: no se encontró $comando en PATH. Instalalo para utilizar rotate." >&2
    fi
done
