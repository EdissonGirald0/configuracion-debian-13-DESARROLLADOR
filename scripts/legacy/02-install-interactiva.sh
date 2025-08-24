#!/bin/bash


#######################
#### Estoy probando este script
echo "Este script tiene errores por montones"

############################################
# Agosto de 2025
# Instalación y Configuración de DWM y Qtile
# En Linux Debian 13 Trixie
############################################
# Versión interactiva en que se puede seleccionar
# la instalación o no de algunos paquetes
# como flatpak - scrcpy - nerd fonts...

# Además se muestran mensajes de error
# Gracias a script enviado por Gabriel P.
############################################
# TL;DR  No todo es a pulso
############################################
# Esta configuración se probó en la segunda y tercera
# semana de Agosto de 2025 en el canal de YouTube:
# https://www.youtube.com/@LinuxenCasa
############################################



if [ "$(whoami)" == "root" ]; then
    echo "El script se debe ejecutar como el usuario normal, no como el root"
    echo "Aunque el usuario debe pertenecer al grupo sudo"
    echo "sorry..."
    exit 1
fi

# Verificar si el usuario tiene permisos para usar sudo
if ! command -v sudo >/dev/null 2>&1; then
    echo "Error: 'sudo' no está instalado o no tienes permisos. Instala sudo o ejecuta como usuario con permisos."
    exit 1
fi



echo "Instalar y Configurar DWM y Qtile WM"
echo "En Linux Debian 13 Trixie"
echo "Partiendo de una instalación mínima de Debian"
echo "Instalación Full - con flatpak - flathub"
echo "Nerd-fonts - virt-manager scrcpy"

sleep 15

############################################
# Actualizar el sistema
echo "Actualizando el sistema..."
sudo apt update || { echo "Error en apt update"; exit 1; }
sudo apt upgrade || { echo "Error en apt upgrade"; exit 1; }


############################################

# crear subdirectorios

xdg-user-dirs-update

if [ ! -d "$HOME/.config" ]; then
    mkdir -p "$HOME/.config"
fi

if [ ! -d "$HOME/.local" ]; then
    mkdir -p "$HOME/.local"
fi

if [ ! -d "$HOME/.local/share" ]; then
    mkdir -p "$HOME/.local/share"
fi

if [ ! -d "$HOME/.local/src" ]; then
    mkdir -p "$HOME/.local/src"
fi

if [ ! -d "/usr/share/wallpapers" ]; then
    sudo mkdir -p "/usr/share/wallpapers"
fi

if [ ! -d "/usr/share/xsessions" ]; then
    sudo mkdir -p "/usr/share/xsessions"
fi

if [ ! -d "/usr/local/bin" ]; then
    sudo mkdir -p "/usr/local/bin"
fi


############################################

# Instalar git si no está presente
if ! command -v git >/dev/null 2>&1; then
    echo "Instalando git..."
    sudo apt install -y git || { echo "Error al instalar git"; exit 1; }
fi

############################################

# descargar y copiar los dot-files de dwm y qtile

cd
git clone https://gitlab.com/linux-en-casa/dwm-qtile-trixie-ver-1.git

cd ~/dwm-qtile-trixie-ver-1/.config/
cp -r dwmbar/ nitrogen/ qtile/ rofi/ sxhkd/ picom.conf ~/.config/ || {
    echo "Error al copiar configuraciones a ~/.config"
    exit 1
}

cd ~/dwm-qtile-trixie-ver-1/.local/share/
cp -r dwm/ ~/.local/share/ || { echo "Error al copiar dwm"; exit 1; }

cd ~/dwm-qtile-trixie-ver-1/.local/src/
cp -r dwm/ st/ ~/.local/src/ || { echo "Error al copiar dwm y st"; exit 1; }

cd ~/dwm-qtile-trixie-ver-1/imagenes/
sudo cp debian-bg.png /usr/share/wallpapers/ || { echo "Error al copiar fondo de pantalla"; exit 1; }

cd ~/dwm-qtile-trixie-ver-1/usr/share/xsessions/
sudo cp dwm.desktop /usr/share/xsessions/ || { echo "Error al copiar dwm.desktop"; exit 1; }

cd ~/dwm-qtile-trixie-ver-1/usr/local/bin/
sudo cp powermenu-total /usr/local/bin/ || { echo "Error al copiar powermenu-total"; exit 1; }



############################################
# Instalación de paquetes .deb
############################################
# Divido la instalación en 4 partes
# 1 - Paquetes Básicos para que funcione DWM y Qtile
# 2 - Apps mínimas - firefox, thunar y otras
# 3 - Apps adicionales - libreoffice, gedit, vlc
# 4 - Bloatware con todo lo que yo uso.
############################################


# 1 - Paquetes Básicos para que funcione DWM y Qtile

cd
echo "Instalando paquetes necesarios..."
sudo apt install -y \
                 adwaita-icon-theme-legacy \
                 alsa-utils \
                 build-essential \
                 curl \
                 dmenu \
                 dunst \
                 fastfetch \
                 feh \
                 ffmpeg \
                 git \
                 gvfs \
                 gvfs-backends \
                 gvfs-fuse \
                 libx11-dev \
                 libxft-dev \
                 libxinerama-dev \
                 lightdm \
                 lightdm-gtk-greeter \
                 lxappearance \
                 lxpolkit \
                 mtp-tools \
                 network-manager-applet \
                 nitrogen \
                 pavucontrol \
                 picom \
                 picom-conf \
                 pipewire \
                 pipewire-pulse \
                 pipewire-alsa \
                 playerctl \
                 qtile \
                 rofi \
                 sxhkd \
                 terminator \
                 unrar-free \
                 volumeicon-alsa \
                 wireplumber \
                 wlogout \
                 xdg-user-dirs \
                 xorg \
                 xterm    || { echo "Error al instalar paquetes necesarios"; exit 1; }


############################################


# 2 - Apps mínimas - firefox, thunar y otras
# están configuradas en algunos atajos de teclado de los WM


sudo apt install \
                 arandr \
                 firefox-esr \
                 gdebi \
                 inxi \
                 sox \
                 synaptic \
                 thunar \
                 xfce4-screenshooter \
                 xfce4-terminal     || { echo "Error al instalar Apps mínimas" }


############################################


# 3 - Apps adicionales - libreoffice, gedit, mpv

# Consultar al usuario si desea instalarlas
echo "Ya se instalaron las apps básicas para que funcionen tanto Qtile como DWM"
echo "Pero, si lo desea, puede instalar más apps, bloatware al poder"

echo "Empecemos con btop, btm, gedit, htop, libreoffice,"
echo "mpv, ristreto, sayonara player, transmission, vim" 
echo "..."
read -p "¿Desea instalar estas apps? (s/N): " install_apps_adicionales
if [ "$install_apps_adicionales" = "s" ] || [ "$install_apps_adicionales" = "S" ]; then
    echo "Instalando ..."
    sudo apt install -y \
                     btop \
                     btm \
                     gedit \
                     htop \
                     hunspell-es \
                     libreoffice \
                     libreoffice-l10n-es \
                     libreoffice-gtk3 \
                     libreoffice-gtk4 \
                     nuspell \
                     mpv \
                     ristretto \
                     sayonara \
                     transmission \
                     vim \
                     wget   ||   { echo "Error al instalar apps adiconales" }


fi



############################################


# 4 - Bloatware con todo lo que yo uso.


echo "Sigo preguntando,  desea instalar todo el bloatware"
echo "que usa el autor de este script"
echo "audacity, cava, cmatrix, cockpit,devscripts, gimp,"
echo "gnumeric, gparted, inkscape, mediainfo, remmina,"
echo "screenkey, ssr, virt-manager...  y otras más"

read -p "¿Desea instalar bloatware? (s/N): " install_bloatware
if [ "$install_bloatware" = "s" ] || [ "$install_bloatware" = "S" ]; then
    echo "Instalando bloatware..."

    sudo apt install -y \
                 audacity \
                 cava \
                 cmatrix \
                 cockpit \
                 cockpit-machines \ 
                 devscripts \
                 fonts-roboto \
                 fonts-font-awesome
                 gimp \
                 gnumeric \
                 gparted \
                 inkscape \
                 mediainfo \
                 neovim \
                 openshot-qt \
                 remmina \
                 remmina-plugin-spice \ 
                 screenkey \
                 simplescreenrecorder \
                 qemu-system \
                 virt-manager \
                             libvirt-daemon-system \
                             virt-viewer \
                 vlc      || { echo "Error al instalar bloatware" }

fi


############################################
############################################


# instalar y configurar DWM

echo "Instalando dwm y st..."
cd ~/.local/src/dwm
sudo make clean install || { echo "Error al instalar dwm"; exit 1; }
cd ~/.local/src/st
sudo make clean install || { echo "Error al instalar st"; exit 1; }
cd

############################################


# descargar las fuentes de JetBrainsMono Nerd Fonts
# se usan en dwm.
cd /tmp
git clone --depth 1 https://github.com/JetBrains/JetBrainsMono.git
cd JetBrainsMono/
ls
./install_manual.sh 
cd

############################################

# o si se desea descargar todas todas todas la fuentes
# advertencia - son más de 1.2 GB

# cd /tmp
# git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
# cd nerd-fonts/
# ./install.sh
# cd

############################################

# instalar flatpak y apps de flathub

# sudo apt install flatpak
# flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# flatpak install flathub com.obsproject.Studio
# flatpak install flathub com.discordapp.Discord
# flatpak install flathub com.google.Chrome
# flatpak install flathub md.obsidian.Obsidian
# flatpak install flathub org.kde.kdenlive
# flatpak install flathub org.jitsi.jitsi-meet
# flatpak install flathub org.telegram.desktop


############################################

# instalar y configurar  scrcpy
# para usar el celular como webcam

# sudo apt install -y \
# libsdl2-2.0-0 adb wget gcc git pkg-config \ 
# meson ninja-build libsdl2-dev libavcodec-dev \
# libavdevice-dev libavformat-dev libavutil-dev \
# libswresample-dev libusb-1.0-0 libusb-1.0-0-dev

# cd
# cd .local/src/
# git clone https://github.com/Genymobile/scrcpy
# cd scrcpy/

#### echo "instalar scrcpy"
# sleep 10
# ./install_release.sh




# fin de instalación

echo "DWM y Qtile Instalados y Configurados"
echo "..."
echo "..."
sleep 10
echo "fin de instalación"
echo "Cerrar Sesión o Reiniciar"
