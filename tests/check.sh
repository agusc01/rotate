#!/bin/sh
set -eu

origen=$(CDPATH= cd "$(dirname "$0")/.." && pwd)

sh -n "$origen/install.sh"
sh -n "$origen/uninstall.sh"

for nombre in rotar.fish r0.fish r90.fish r180.fish r270.fish; do
    archivo="$origen/fish/functions/$nombre"
    test -f "$archivo"
    grep -Fq '# rotate-managed: agusc01/rotate' "$archivo"
    if command -v fish >/dev/null 2>&1; then
        fish -n "$archivo"
    fi
done

echo 'OK: instaladores correctos, cinco funciones presentes y sintaxis comprobada cuando Fish está disponible.'
