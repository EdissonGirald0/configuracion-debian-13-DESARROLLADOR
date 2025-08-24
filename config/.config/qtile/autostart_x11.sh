#!/bin/bash

# disposición de las pantallas con script de arandr - xrandr
~/.screenlayout/resolucion.sh &

# fondo de pantalla
nitrogen --restore &

# picom para las transparencias
picom  &

# el polkit para abrir apps gráficas que necesitan sudo
# /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
# en trixie ya no está este archivo
# ahora uso lxpolkit
lxpolkit &

# nm applet para ver conexión de red
nm-applet &

