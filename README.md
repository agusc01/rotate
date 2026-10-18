# rotate

Rotación de **pantalla y táctil** en Xorg/dwm mediante comandos cortos de **Fish**. Pensado para Alpine Linux y la pantalla táctil `Goodix Capacitive TouchScreen`.

## Instalación

Ejecutar **como usuario normal**, desde una terminal abierta en dwm (no usar `su -` ni `sudo` para instalar):

```sh
git clone https://github.com/agusc01/rotate.git
cd rotate
sh install.sh
```

El instalador copia cinco funciones Fish a `~/.config/fish/functions/`. **No modifica** `config.fish`, `.xinitrc` ni archivos del sistema, y puede ejecutarse nuevamente para actualizar. Fish carga automáticamente las funciones cuando se invocan.

Necesitás `fish`, `xrandr` y `xinput`. En Alpine se pueden instalar con `apk add fish xrandr xinput` si están habilitados los repositorios correspondientes. En particular, `xinput` puede requerir `community`. La instalación de rotate no instala paquetes ni exige permisos de root.

## Uso

| Comando | Pantalla | Táctil |
| --- | --- | --- |
| `r0` | Normal (0°) | Normal |
| `r90` | Derecha (90°) | Derecha |
| `r180` | Invertida (180°) | Invertida |
| `r270` | Izquierda (270°) | Izquierda |

También se puede llamar a `rotar normal`, `rotar derecha`, `rotar invertida` o `rotar izquierda`.

Abrí un **nuevo `st` con Fish** después de instalar o ejecutá `fish` desde la terminal actual. Si ya estás en Fish, las funciones normalmente se podrán cargar de inmediato. No necesitás reiniciar dwm.

## Detección automática

- Pantalla: selecciona primero una salida conectada interna (`eDP`, `LVDS` o `DSI`); después la primaria o la primera conectada.
- Táctil: busca `pointer:Goodix Capacitive TouchScreen` y obtiene su **ID actual** cada vez. Evita confundirlo con la entrada de teclado del mismo nombre.
- Si falta `xinput` o el táctil, gira la imagen y avisa que no pudo sincronizar el táctil.
- Solo funciona en una sesión **Xorg/X11** activa.

Para elegir una salida distinta, configurá variables de entorno en Fish:

```fish
set -gx ROTATE_OUTPUT eDP-1
set -gx ROTATE_TOUCH "Goodix Capacitive TouchScreen"
r90
```

Revisá nombres con `xrandr --query` y `xinput list`. Si querés guardar esos valores entre sesiones, agregá los dos `set -gx` a `~/.config/fish/config.fish`. **No uses un ID numérico fijo** para el táctil.

## Girar automáticamente al iniciar dwm

Después de instalar las funciones, agregá esto **antes** de `exec /usr/local/bin/dwm` en `~/.xinitrc`:

```sh
fish -c 'r90'
exec /usr/local/bin/dwm
```

Reemplazá `r90` por la orientación que prefieras. **No** dupliques `exec dwm` si ya lo tenés: conservá una única línea al final.

Si anteriormente agregaste alias `r0`/`r90`/`r180`/`r270` de forma manual a `config.fish`, quitálos para evitar que reemplacen las funciones instaladas.

## Actualización y desinstalación

```sh
cd rotate
git pull
sh install.sh
```

Para desinstalar:

```sh
sh uninstall.sh
```

Solo se borran los archivos que pertenecen a rotate. Los archivos de otros programas o creados por vos no se sobrescriben ni se eliminan.

## Comprobaciones

```sh
sh tests/check.sh
```

Verifica sintaxis de los instaladores y, si `fish` está disponible, la sintaxis de las cinco funciones. La prueba no rota la pantalla.
