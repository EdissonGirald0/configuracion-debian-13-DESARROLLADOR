#!/bin/bash

####################################################
# Autostart para entorno de desarrollo
# Se ejecuta al iniciar Qtile
####################################################

# Establecer variables de entorno para desarrollo
export EDITOR="code"
export BROWSER="firefox"
export TERMINAL="alacritty"

# Crear directorios de desarrollo si no existen
mkdir -p ~/Development/{projects,tools,containers,databases,scripts}
mkdir -p ~/Development/projects/{web,mobile,desktop,scripts}
mkdir -p ~/.local/bin

####################################################
# Aplicaciones de sistema básicas
####################################################

# Compositor para efectos visuales
picom --daemon &

# Gestor de archivos como daemon
thunar --daemon &

# Administrador de redes
nm-applet &

# Control de volumen en systray  
volumeicon &

# Administrador de Bluetooth
blueman-applet &

# Establecer wallpaper
nitrogen --restore &

# Iniciar agente SSH
eval "$(ssh-agent -s)" &

####################################################
# Aplicaciones específicas de desarrollo
####################################################

# Iniciar Docker (si no está iniciado)
sudo systemctl start docker &

# Git credential helper timeout (8 horas)
git config --global credential.helper 'cache --timeout=28800' &

# Iniciar PostgreSQL local si está instalado
if systemctl is-enabled postgresql &>/dev/null; then
    sudo systemctl start postgresql &
fi

# Iniciar Redis local si está instalado  
if systemctl is-enabled redis-server &>/dev/null; then
    sudo systemctl start redis-server &
fi

####################################################
# Herramientas de monitoreo y productividad
####################################################

# Activar numlock
numlockx on &

# Configurar teclado (cambiar según necesidades)
setxkbmap -layout us -variant altgr-intl &

# Desactivar beep del sistema
xset -b &

# Configurar rate de repetición del teclado (más rápido para programar)
xset r rate 200 30 &

# Configurar DPI si es necesario (para pantallas HiDPI)
# xrandr --dpi 144 &

####################################################
# Scripts personalizados
####################################################

# Script de barra de estado para DWM (si se usa DWM)
if [ -f ~/.config/dwmbar/bar.sh ]; then
    ~/.config/dwmbar/bar.sh &
fi

# Sincronizar repositorios de desarrollo cada hora
(while true; do 
    sleep 3600
    if [ -d ~/Development/projects ]; then
        find ~/Development/projects -name ".git" -type d | while read repo; do
            cd "$(dirname "$repo")"
            if git status &>/dev/null; then
                git fetch --all &>/dev/null || true
            fi
        done
    fi
done) &

####################################################
# Shortcuts y alias personalizados
####################################################

# Crear archivo de aliases para desarrollo si no existe
if [ ! -f ~/.bash_aliases ]; then
    cat > ~/.bash_aliases << 'EOF'
# Development aliases
alias ll='ls -alF'
alias la='ls -A' 
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# Git shortcuts
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gpl='git pull'

# Development shortcuts
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

# Docker shortcuts  
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'
alias dex='docker exec -it'
alias dlog='docker logs -f'

# Kubernetes shortcuts
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kde='kubectl describe'
alias kaf='kubectl apply -f'

# Navigation shortcuts
alias dev='cd ~/Development'
alias proj='cd ~/Development/projects'
alias tools='cd ~/Development/tools'

# System monitoring
alias cpu='grep "cpu " /proc/stat | awk '"'"'{usage=($2+$4)*100/($2+$3+$4+$5)} END {print usage "%"}'"'"''
alias meminfo='free -m -l -t'
alias ports='netstat -tulanp'

# Modern CLI tools (si están instalados)
if command -v bat &> /dev/null; then
    alias cat='bat'
fi

if command -v exa &> /dev/null; then
    alias ls='exa --icons'
    alias ll='exa -alF --icons'
fi

if command -v fd &> /dev/null; then
    alias find='fd'
fi

if command -v rg &> /dev/null; then
    alias grep='rg'
fi
EOF
fi

####################################################  
# Configurar Git globalmente si no está configurado
####################################################

if [ ! "$(git config --global user.name)" ]; then
    echo "Configurando Git..."
    read -p "Ingresa tu nombre para Git: " git_name
    read -p "Ingresa tu email para Git: " git_email
    
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.editor "code --wait"
    
    echo "Git configurado correctamente"
fi

####################################################
# Verificar conexiones de desarrollo
####################################################

# Función para verificar servicios
check_service() {
    if systemctl is-active --quiet $1; then
        echo "✅ $1 está funcionando"
    else
        echo "❌ $1 no está activo"
    fi
}

# Log de inicio
echo "=== Autostart Development Environment ===" >> ~/.config/qtile/startup.log
date >> ~/.config/qtile/startup.log

# Verificar servicios importantes
echo "Verificando servicios de desarrollo..." >> ~/.config/qtile/startup.log
check_service docker >> ~/.config/qtile/startup.log 2>&1
check_service postgresql >> ~/.config/qtile/startup.log 2>&1
check_service redis-server >> ~/.config/qtile/startup.log 2>&1

# Verificar conexión a internet (importante para APIs)
if ping -c 1 google.com &>/dev/null; then
    echo "✅ Conexión a internet OK" >> ~/.config/qtile/startup.log
else
    echo "❌ Sin conexión a internet" >> ~/.config/qtile/startup.log
fi

echo "Autostart completado: $(date)" >> ~/.config/qtile/startup.log
echo "=========================================" >> ~/.config/qtile/startup.log

####################################################
# Aplicaciones específicas según el día/hora
####################################################

# Solo en horario laboral, abrir herramientas de trabajo
hour=$(date +%H)
if [ $hour -ge 9 ] && [ $hour -le 18 ]; then
    # Esperar un poco para que el WM esté completamente cargado
    sleep 5
    
    # Abrir terminal en directorio de proyectos
    alacritty --working-directory ~/Development/projects &
    
    # Si es lunes, mostrar resumen de la semana
    if [ $(date +%u) -eq 1 ]; then
        sleep 2
        notify-send "¡Buen lunes!" "Recuerda revisar los proyectos pendientes" &
    fi
fi

####################################################
# Limpieza automática de archivos temporales
####################################################

# Limpiar cache de npm, pip, etc. semanalmente
if [ $(date +%u) -eq 1 ] && [ $hour -eq 9 ]; then
    # Limpiar npm cache
    if command -v npm &> /dev/null; then
        npm cache clean --force &>/dev/null &
    fi
    
    # Limpiar pip cache  
    if command -v pip &> /dev/null; then
        pip cache purge &>/dev/null &
    fi
    
    # Limpiar Docker images no utilizadas
    if command -v docker &> /dev/null; then
        docker image prune -f &>/dev/null &
    fi
fi

echo "Entorno de desarrollo inicializado correctamente"
