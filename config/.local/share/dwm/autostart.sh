#!/bin/bash
# This file is for autostart programs

# disposición de las pantallas con script de arandr - xrandr
# ~/.screenlayout/resolucion-dwm.sh &

# fondo de pantalla
nitrogen --restore &

# para las notificaciones
dunst &

# transparencias
picom &

# el polkit para abrir apps gráficas que necesitan sudo
# ahora uso lxpolkit
lxpolkit &
# /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
# en trixie ya no está este archivo

#  lanzar sxhkd
# pgrep -x sxhkd > /dev/null || sxhkd -c ~/.config/sxhkd/sxhkdrc-dwm &

volumeicon &
bash ~/.config/dwmbar/bar.sh &
nm-applet




