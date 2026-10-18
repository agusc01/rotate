#!/bin/sh
set -eu

if [ "$(id -u)" -eq 0 ]; then
    echo "Error: ejecutá este desinstalador como tu usuario normal, sin su ni sudo." >&2
    exit 1
fi

base=${XDG_CONFIG_HOME:-"$HOME/.config"}
destino="$base/fish/functions"
marca='# rotate-managed: agusc01/rotate'

for nombre in rotar.fish r0.fish r90.fish r180.fish r270.fish; do
    archivo="$destino/$nombre"
    if [ -L "$archivo" ]; then
        echo "Omitido (enlace simbólico): $archivo"
    elif [ -f "$archivo" ] && grep -Fq "$marca" "$archivo"; then
        rm "$archivo"
        echo "Eliminado: $archivo"
    elif [ -e "$archivo" ]; then
        echo "Omitido (no pertenece a rotate): $archivo"
    fi
done

echo "Desinstalación terminada. Abrí una terminal Fish nueva."
