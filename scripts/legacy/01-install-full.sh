#!/bin/bash

############################################
# Agosto de 2025
# Instalación y Configuración de DWM y Qtile
# En Linux Debian 13 Trixie
# En esta versión se instala casi todo sin preguntar
# Están disponibles la instalación de otros paquetes
# como flatpak - scrcpy - nerd fonts...
# pero se debe descomentar las líneas
############################################
# TL;DR  Todo es a pulso
############################################
# Esta configuración se probó en la segunda y tercera
# semana de Agosto de 2025 en el canal de YouTube:
# https://www.youtube.com/@LinuxenCasa
############################################



if [ "$(whoami)" == "root" ]; then
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
sudo apt update
sudo apt upgrade

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


# descargar y copiar los dot-files de dwm y qtile
cd
git clone https://gitlab.com/linux-en-casa/dwm-qtile-trixie-ver-1.git

cd ~/dwm-qtile-trixie-ver-1/.config/
cp -r dwmbar/ nitrogen/ qtile/ rofi/ sxhkd/ picom.conf ~/.config/

cd ~/dwm-qtile-trixie-ver-1/.local/share/
cp -r dwm/ ~/.local/share/

cd ~/dwm-qtile-trixie-ver-1/.local/src/
cp -r dwm/ ~/.local/src/
cp -r st/ ~/.local/src/

cd ~/dwm-qtile-trixie-ver-1/imagenes/
sudo cp debian-bg.png /usr/share/wallpapers/

cd ~/dwm-qtile-trixie-ver-1/usr/share/xsessions/
sudo cp dwm.desktop /usr/share/xsessions/

cd ~/dwm-qtile-trixie-ver-1/usr/local/bin/
sudo cp powermenu-total /usr/local/bin/


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
                 xterm


############################################


# 2 - Apps mínimas - firefox, thunar y otras
# están configuradas en algunos atajos de teclado de los WM

sudo apt install -y \
                 arandr \
                 firefox-esr \
                 gdebi \
                 inxi \
                 sox \
                 synaptic \
                 thunar \
                 xfce4-screenshooter \
                 xfce4-terminal

############################################


# 3 - Apps adicionales - libreoffice, gedit, mpv

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
                 wget

############################################


# 4 - Bloatware con todo lo que yo uso.

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
                 vlc

############################################
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


############################################

# instalar y configurar DWM

cd ~/.local/src/dwm
sudo make clean install
cd ~/.local/src/st
sudo make clean install
cd

############################################


# fin de instalación

echo "DWM y Qtile Instalados y Configurados"
echo "..."
echo "..."
sleep 10
echo "fin de instalación"
echo "Cerrar Sesión o Reiniciar"

############################################


