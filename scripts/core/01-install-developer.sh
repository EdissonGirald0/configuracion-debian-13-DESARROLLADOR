#!/bin/bash

############################################
# Agosto de 2025
# Instalación y Configuración de DWM y Qtile
# ADAPTADO PARA DESARROLLADORES/INGENIEROS DE SOFTWARE
# En Linux Debian 13 Trixie
############################################
# Incluye herramientas específicas de desarrollo:
# - IDEs y editores avanzados
# - Herramientas de control de versiones
# - Contenedores y virtualización
# - Herramientas de debugging y profiling
# - Múltiples lenguajes de programación
# - Herramientas de bases de datos
# - Herramientas de red y monitoreo
############################################

if [ "$(whoami)" == "root" ]; then
    echo "El script debe ejecutarse como usuario normal con permisos sudo"
    exit 1
fi

echo "==================================================="
echo "DWM + Qtile para DESARROLLADORES DE SOFTWARE"
echo "Instalación optimizada para desarrollo"
echo "==================================================="

sleep 10

############################################
# Actualizar el sistema
sudo apt update
sudo apt upgrade -y

############################################
# Crear estructura completa de directorios para desarrollo
echo "📁 Creando estructura de directorios..."

# Directorios principales de desarrollo
mkdir -p "$HOME/Development"
mkdir -p "$HOME/Development/projects"
mkdir -p "$HOME/Development/projects/python"
mkdir -p "$HOME/Development/projects/nodejs" 
mkdir -p "$HOME/Development/projects/java"
mkdir -p "$HOME/Development/projects/golang"
mkdir -p "$HOME/Development/projects/shared"
mkdir -p "$HOME/Development/tools"
mkdir -p "$HOME/Development/containers"
mkdir -p "$HOME/Development/databases"
mkdir -p "$HOME/Development/backups"
mkdir -p "$HOME/Development/logs"

# Directorios de configuración
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share"

# Directorios para entornos virtuales
mkdir -p "$HOME/Development/python-envs"
mkdir -p "$HOME/Development/node-envs"

# Directorio para plantillas y templates
mkdir -p "$HOME/Development/templates"
mkdir -p "$HOME/Development/scripts"

echo "✅ Estructura de directorios creada"

############################################
# Copiar configuraciones base (heredadas del proyecto original)
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
# PAQUETES BASE PARA WM + HERRAMIENTAS DE DESARROLLO
############################################

echo "📦 Instalando paquetes base del sistema..."

sudo apt install -y \
                 # WM Base packages (heredados)
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
                 # Herramientas de desarrollo base adicionales
                 software-properties-common \
                 apt-transport-https \
                 ca-certificates \
                 gnupg \
                 lsb-release \
                 wget \
                 unzip \
                 zip \
                 tree \
                 htop \
                 ncdu \
                 jq \
                 yq \
                 ripgrep \
                 fd-find \
                 bat \
                 exa \
                 tmux \
                 screen \
                 openssh-client \
                 openssh-server \
                 # Herramientas de red y monitoreo
                 net-tools \
                 netstat-nat \
                 nmap \
                 tcpdump \
                 wireshark-cli \
                 iftop \
                 iotop \
                 # Herramientas de texto y archivos
                 vim \
                 nano \
                 micro \
                 gedit \
                 meld \
                 diff-so-fancy \
                 # Compiladores y herramientas de build
                 gcc \
                 g++ \
                 make \
                 cmake \
                 autoconf \
                 automake \
                 libtool \
                 pkg-config \
                 # Librerías de desarrollo
                 libssl-dev \
                 libffi-dev \
                 libbz2-dev \
                 libreadline-dev \
                 libsqlite3-dev \
                 libncursesw5-dev \
                 xz-utils \
                 tk-dev \
                 libxml2-dev \
                 libxmlsec1-dev \
                 libffi-dev \
                 # Herramientas de imagen y multimedia
                 imagemagick \
                 graphicsmagick \
                 # Herramientas de archivo y compresión
                 p7zip-full \
                 rar \
                 unrar \
                 # Herramientas de terminal mejoradas
                 zsh \
                 fish \
                 fzf \
                 silversearcher-ag \
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
# HERRAMIENTAS DE DESARROLLO ESENCIALES (HOST)
############################################

echo "📱 Instalando herramientas esenciales en el HOST..."
echo "Los entornos de desarrollo estarán en contenedores Docker"

sudo apt install -y \
                 # Control de versiones avanzado
                 git \
                 git-flow \
                 git-lfs \
                 gitk \
                 git-gui \
                 tig \
                 gh \
                 # Herramientas básicas del sistema mejoradas
                 curl \
                 wget \
                 vim \
                 neovim \
                 # Clientes de bases de datos (para conectar a contenedores)
                 postgresql-client \
                 mysql-client \
                 redis-tools \
                 mongodb-clients \
                 # Herramientas de sistema y monitoreo
                 htop \
                 btop \
                 iotop \
                 sysstat \
                 lsof \
                 tree \
                 jq \
                 yq \
                 # Network tools
                 netcat-openbsd \
                 telnet \
                 nmap \
                 tcpdump \
                 wireshark-cli \
                 # Archivos y compresión
                 zip \
                 unzip \
                 tar \
                 gzip \
                 # Development utilities
                 make \
                 cmake \
                 autoconf \
                 automake \
                 pkg-config \
                 # Shell improvements  
                 zsh \
                 fish \
                 tmux \
                 screen \
                 fzf \
                 # Modern CLI tools
                 exa \
                 bat \
                 fd-find \
                 ripgrep \
                 du-dust \
                 # Text processing
                 sed \
                 awk \
                 grep \
                 # Network and security
                 openssh-client \
                 openssh-server \
                 gnupg \
                 # Performance tools
                 strace \
                 ltrace \
                 gdb \
                 valgrind \
                 p7zip-full \
                 # Herramientas de red
                 netcat-openbsd \
                 nmap \
                 tcpdump

############################################
# CONTENEDORES Y VIRTUALIZACIÓN
############################################

echo "Instalando Docker y herramientas de contenedores..."

# Docker (instalación oficial)
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Docker Compose standalone (por si acaso)
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "✅ Docker instalado - REINICIA la sesión para usar Docker sin sudo"

############################################
# BASES DE DATOS DE DESARROLLO
############################################

echo "NOTA: Las bases de datos se ejecutarán en contenedores Docker"
echo "Instalando solo clientes para conectar desde el HOST..."

# Ya instalados arriba: postgresql-client, mysql-client, redis-tools

# Instalar SQLite para desarrollo local ligero
sudo apt install -y sqlite3 sqlitebrowser

echo "✅ Clientes de BD instalados. Las BD estarán en contenedores."

############################################
# HERRAMIENTAS DE MONITOREO Y PROFILING
############################################

sudo apt install -y \
                 # Monitoring
                 htop \
                 btop \
                 iotop \
                 nethogs \
                 nmon \
                 # Profiling
                 perf-tools-unstable \
                 linux-perf \
                 # Log analysis
                 multitail \
                 glogg

############################################
# TERMINAL MEJORADA Y HERRAMIENTAS CLI
############################################

# Instalar Alacritty (terminal GPU-accelerated)
sudo apt install -y alacritty

# Zsh y Oh My Zsh
sudo apt install -y zsh
# Oh My Zsh se instalará después

# Herramientas CLI modernas
sudo apt install -y \
                 # Mejor ls
                 exa \
                 # Mejor cat
                 bat \
                 # Mejor find
                 fd-find \
                 # Mejor grep
                 ripgrep \
                 # Mejor du
                 du-dust \
                 # File manager CLI
                 ranger \
                 # JSON processor
                 jq \
                 # YAML processor
                 yq \
                 # HTTP client
                 httpie

############################################
# FUENTES PARA DESARROLLO
############################################

echo "Instalando fuentes para desarrollo..."

# JetBrains Mono (ya incluida en el script original pero la mejoramos)
cd /tmp
git clone --depth 1 https://github.com/JetBrains/JetBrainsMono.git
cd JetBrainsMono/
./install_manual.sh 
cd

# Fira Code
sudo apt install -y fonts-firacode

# Cascadia Code de Microsoft
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/microsoft/cascadia-code/releases/download/v2111.01/CascadiaCode-2111.01.zip
unzip CascadiaCode-2111.01.zip
fc-cache -fv
cd

############################################
# APLICACIONES DE DESARROLLO GRÁFICAS
############################################

sudo apt install -y \
                 # Navegadores para desarrollo
                 firefox-esr \
                 chromium \
                 # Editores de texto/código
                 gedit \
                 mousepad \
                 # Herramientas de diseño
                 gimp \
                 inkscape \
                 # Cliente Git gráfico
                 gitg \
                 # Diff/merge tools
                 meld \
                 # Terminal multiplexor
                 tmux \
                 screen \
                 # FTP/SFTP
                 filezilla \
                 # API testing
                 # postman se instalará vía snap o flatpak
                 
############################################
# FLATPAK Y APLICACIONES ADICIONALES
############################################

echo "Instalando Flatpak y aplicaciones adicionales..."

sudo apt install -y flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# IDEs y editores
flatpak install flathub -y com.visualstudio.code
flatpak install flathub -y org.jetbrains.PyCharm-Community
flatpak install flathub -y com.jetbrains.IntelliJ-IDEA-Community
flatpak install flathub -y rest.insomnia.Insomnia
flatpak install flathub -y io.postman.Postman
#flatpak install flathub -y com.sublimetext.three

# Bases de datos GUI
flatpak install flathub -y org.dbeaver.DBeaverCommunity
flatpak install flathub -y com.github.wwmm.easyeffects

# Herramientas de comunicación para equipos
#flatpak install flathub -y com.discordapp.Discord
#flatpak install flathub -y com.slack.Slack
flatpak install flathub -y us.zoom.Zoom

############################################
# CONFIGURAR ENTORNOS DE DESARROLLO CONTAINERIZADOS
############################################

echo "📦 Configurando entornos de desarrollo en contenedores..."

# Copiar scripts de gestión de contenedores
cp setup-dev-containers.sh ~/.local/bin/
cp dev-manager.sh ~/.local/bin/
chmod +x ~/.local/bin/setup-dev-containers.sh
chmod +x ~/.local/bin/dev-manager.sh

# Crear aliases útiles
cat >> ~/.bashrc << 'EOF'

# === ALIASES PARA DESARROLLO CONTAINERIZADO ===

# Gestión de contenedores de desarrollo
alias dev-setup='setup-dev-containers.sh'
alias dev='dev-manager.sh'
alias dev-status='dev-manager.sh status'
alias dev-start='dev-manager.sh start-all'
alias dev-stop='dev-manager.sh stop-all'

# Conexiones rápidas a contenedores
alias py-dev='dev-manager.sh connect python-dev-env'
alias node-dev='dev-manager.sh connect nodejs-dev-env'
alias java-dev='dev-manager.sh connect java-dev-env'
alias go-dev='dev-manager.sh connect golang-dev-env'

# Shortcuts para servicios específicos
alias start-db='dev-manager.sh start databases'
alias start-py='dev-manager.sh start python'
alias start-node='dev-manager.sh start nodejs'
alias start-java='dev-manager.sh start java'
alias start-go='dev-manager.sh start golang'

# Directorios de desarrollo
alias dev-dir='cd ~/Development'
alias projects='cd ~/Development/projects'
alias containers='cd ~/Development/containers'

EOF

echo "✅ Scripts de contenedores configurados"
echo ""
echo "🔧 Aliases creados:"
echo "   dev-setup    - Configurar contenedores"
echo "   dev          - Gestionar contenedores"
echo "   dev-start    - Iniciar todos los entornos"
echo "   py-dev       - Conectar a contenedor Python"
echo "   node-dev     - Conectar a contenedor Node.js"
echo "   start-db     - Iniciar bases de datos"
echo ""

############################################
# COMPILAR E INSTALAR DWM Y ST
############################################

cd ~/.local/src/dwm
sudo make clean install

cd ~/.local/src/st
sudo make clean install

cd

############################################
# CONFIGURACIONES ADICIONALES PARA DESARROLLO
############################################

# Crear alias útiles para desarrollo
cat >> ~/.bashrc << 'EOF'

# Aliases para desarrollo
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph'
alias gco='git checkout'
alias gb='git branch'

# Development shortcuts
alias py='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias penv='python3 -m venv'

# Docker shortcuts
alias d='docker'
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'
alias dex='docker exec -it'

# Directory shortcuts
alias dev='cd ~/Development'
alias proj='cd ~/Development/projects'

# Modern CLI tools
alias cat='bat'
alias ls='exa'
alias find='fd'
alias grep='rg'
alias du='dust'

EOF

############################################
# CONFIGURACIÓN DE INTEGRACIÓN ENTRE SCRIPTS
############################################

echo "🔗 Configurando integración entre scripts..."

# Crear archivo de configuración global
cat > ~/.dev_config << 'EOF'
# Configuración global para entornos de desarrollo
export DEV_HOME="$HOME/Development"
export DEV_PROJECTS="$HOME/Development/projects"
export DEV_CONTAINERS="$HOME/Development/containers"
export DEV_TOOLS="$HOME/Development/tools"
export DEV_LOGS="$HOME/Development/logs"
export DEV_BACKUPS="$HOME/Development/backups"

# Configuración de Docker
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1

# Configuración de desarrollo
export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1
export NODE_ENV=development

# Configuración de bases de datos para desarrollo
export DB_HOST=localhost
export DB_USER=developer
export DB_PASS=devpass
export POSTGRES_DB=devdb
export MYSQL_DB=devdb
export MONGO_DB=devdb

# Puertos por defecto para servicios
export POSTGRES_PORT=5432
export MYSQL_PORT=3306
export REDIS_PORT=6379
export MONGO_PORT=27017

# Puertos para aplicaciones de desarrollo
export PYTHON_DEV_PORT=8000
export NODEJS_DEV_PORT=3000
export JAVA_DEV_PORT=8080
export GOLANG_DEV_PORT=9000

# Configuración de IDEs
export VSCODE_EXTENSIONS_DIR="$HOME/.vscode/extensions"
export JETBRAINS_CONFIG="$HOME/.config/JetBrains"

# Logging
export DEV_LOG_LEVEL=INFO
export DEV_LOG_FILE="$DEV_LOGS/development.log"
EOF

# Agregar configuración a shell profiles
echo "source ~/.dev_config" >> ~/.bashrc
if [ -f ~/.zshrc ]; then
    echo "source ~/.dev_config" >> ~/.zshrc
fi

# Crear función de logging para scripts
cat > ~/.dev_logger << 'EOF'
#!/bin/bash

# Función de logging para scripts de desarrollo
dev_log() {
    local level="$1"
    local message="$2"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local script_name=$(basename "$0")
    
    # Crear directorio de logs si no existe
    mkdir -p "$(dirname "$DEV_LOG_FILE")"
    
    # Escribir al log
    echo "[$timestamp] [$level] [$script_name] $message" >> "$DEV_LOG_FILE"
    
    # También mostrar en consola
    case "$level" in
        "ERROR")   echo "❌ $message" ;;
        "WARN")    echo "⚠️  $message" ;;
        "INFO")    echo "ℹ️  $message" ;;
        "SUCCESS") echo "✅ $message" ;;
        *)         echo "$message" ;;
    esac
}

# Función para verificar dependencias
check_dependency() {
    local cmd="$1"
    local package="$2"
    
    if ! command -v "$cmd" &> /dev/null; then
        dev_log "ERROR" "$cmd no está instalado. Instalar con: sudo apt install $package"
        return 1
    fi
    return 0
}

# Función para verificar servicio systemd
check_service() {
    local service="$1"
    
    if systemctl is-active --quiet "$service"; then
        dev_log "SUCCESS" "Servicio $service está activo"
        return 0
    else
        dev_log "WARN" "Servicio $service no está activo"
        return 1
    fi
}

# Función para verificar puerto disponible
check_port() {
    local port="$1"
    
    if ss -tulnp | grep -q ":$port "; then
        dev_log "WARN" "Puerto $port está en uso"
        return 1
    else
        dev_log "INFO" "Puerto $port está disponible"
        return 0
    fi
}

# Función para crear backup automático
create_backup() {
    local source_dir="$1"
    local backup_name="$2"
    local backup_file="$DEV_BACKUPS/${backup_name}-$(date +%Y%m%d-%H%M%S).tar.gz"
    
    mkdir -p "$DEV_BACKUPS"
    
    if tar -czf "$backup_file" -C "$(dirname "$source_dir")" "$(basename "$source_dir")"; then
        dev_log "SUCCESS" "Backup creado: $backup_file"
        return 0
    else
        dev_log "ERROR" "Error creando backup de $source_dir"
        return 1
    fi
}

# Función para verificar sistema completo
system_health_check() {
    dev_log "INFO" "Iniciando verificación del sistema..."
    
    # Verificar Docker
    check_dependency "docker" "docker.io"
    check_dependency "docker-compose" "docker-compose"
    
    # Verificar herramientas de desarrollo
    check_dependency "git" "git"
    check_dependency "code" "code"
    check_dependency "python3" "python3"
    check_dependency "node" "nodejs"
    
    # Verificar clientes de BD
    check_dependency "psql" "postgresql-client"
    check_dependency "mysql" "mysql-client"
    check_dependency "redis-cli" "redis-tools"
    
    # Verificar puertos clave
    check_port 5432  # PostgreSQL
    check_port 3306  # MySQL
    check_port 6379  # Redis
    check_port 27017 # MongoDB
    
    dev_log "SUCCESS" "Verificación del sistema completada"
}
EOF

# Hacer funciones de logging disponibles globalmente
echo "source ~/.dev_logger" >> ~/.bashrc
if [ -f ~/.zshrc ]; then
    echo "source ~/.dev_logger" >> ~/.zshrc
fi

# Crear script de verificación del sistema
cat > ~/.local/bin/dev-check << 'EOF'
#!/bin/bash
source ~/.dev_config
source ~/.dev_logger

echo "🔍 Verificación del Sistema de Desarrollo"
echo "========================================="
system_health_check
EOF

chmod +x ~/.local/bin/dev-check

# Crear script de inicialización del entorno
cat > ~/.local/bin/dev-init << 'EOF'
#!/bin/bash
source ~/.dev_config
source ~/.dev_logger

dev_log "INFO" "Inicializando entorno de desarrollo..."

# Crear directorios si no existen
mkdir -p "$DEV_PROJECTS"/{python,nodejs,java,golang,shared}
mkdir -p "$DEV_CONTAINERS"
mkdir -p "$DEV_TOOLS"
mkdir -p "$DEV_LOGS"
mkdir -p "$DEV_BACKUPS"

# Verificar que Docker está corriendo
if ! systemctl is-active --quiet docker; then
    dev_log "WARN" "Docker no está activo, iniciando..."
    sudo systemctl start docker
fi

# Crear red de desarrollo si no existe
if ! docker network ls | grep -q dev-network; then
    dev_log "INFO" "Creando red de desarrollo..."
    docker network create --driver bridge --subnet=172.20.0.0/16 dev-network
fi

dev_log "SUCCESS" "Entorno de desarrollo inicializado"
EOF

chmod +x ~/.local/bin/dev-init

# Crear script para setup completo automático
cat > ~/.local/bin/dev-setup-complete << 'EOF'
#!/bin/bash
source ~/.dev_config
source ~/.dev_logger

echo "🚀 Setup Completo del Entorno de Desarrollo"
echo "============================================="

# 1. Verificar sistema
dev_log "INFO" "Paso 1/5: Verificando sistema..."
dev-check

# 2. Inicializar entorno
dev_log "INFO" "Paso 2/5: Inicializando entorno..."
dev-init

# 3. Configurar herramientas post-instalación
if [ -f "$(dirname "$0")/../03-config-dev-tools.sh" ]; then
    dev_log "INFO" "Paso 3/5: Ejecutando configuración de herramientas..."
    bash "$(dirname "$0")/../03-config-dev-tools.sh"
elif [ -f "./03-config-dev-tools.sh" ]; then
    dev_log "INFO" "Paso 3/5: Ejecutando configuración de herramientas..."
    bash "./03-config-dev-tools.sh"
else
    dev_log "WARN" "Script 03-config-dev-tools.sh no encontrado, saltando..."
fi

# 4. Configurar contenedores de desarrollo
if [ -f "$(dirname "$0")/../setup-dev-containers.sh" ]; then
    dev_log "INFO" "Paso 4/5: Configurando contenedores de desarrollo..."
    bash "$(dirname "$0")/../setup-dev-containers.sh" all
elif [ -f "./setup-dev-containers.sh" ]; then
    dev_log "INFO" "Paso 4/5: Configurando contenedores de desarrollo..."
    bash "./setup-dev-containers.sh" all
else
    dev_log "WARN" "Script setup-dev-containers.sh no encontrado, saltando..."
fi

# 5. Configurar gestión de contenedores
if [ -f "$(dirname "$0")/../dev-manager.sh" ]; then
    dev_log "INFO" "Paso 5/5: Configurando gestión de contenedores..."
    cp "$(dirname "$0")/../dev-manager.sh" ~/.local/bin/dev-manager
    chmod +x ~/.local/bin/dev-manager
    
    # Crear enlaces simbólicos para comandos rápidos
    ln -sf ~/.local/bin/dev-manager ~/.local/bin/dev-start
    ln -sf ~/.local/bin/dev-manager ~/.local/bin/dev-stop  
    ln -sf ~/.local/bin/dev-manager ~/.local/bin/dev-status
    ln -sf ~/.local/bin/dev-manager ~/.local/bin/dev-logs
elif [ -f "./dev-manager.sh" ]; then
    dev_log "INFO" "Paso 5/5: Configurando gestión de contenedores..."
    cp "./dev-manager.sh" ~/.local/bin/dev-manager
    chmod +x ~/.local/bin/dev-manager
    
    # Crear enlaces simbólicos para comandos rápidos
    ln -sf ~/.local/bin/dev-manager ~/.local/bin/dev-start
    ln -sf ~/.local/bin/dev-manager ~/.local/bin/dev-stop
    ln -sf ~/.local/bin/dev-manager ~/.local/bin/dev-status  
    ln -sf ~/.local/bin/dev-manager ~/.local/bin/dev-logs
else
    dev_log "WARN" "Script dev-manager.sh no encontrado, saltando..."
fi

dev_log "SUCCESS" "Setup completo finalizado!"
echo
echo "🎯 Próximos pasos:"
echo "  1. Reiniciar sesión para aplicar cambios de Docker"
echo "  2. Ejecutar: dev-check (verificar sistema)"
echo "  3. Ejecutar: dev-start (iniciar contenedores)"
echo "  4. Usar: py-dev, node-dev, etc. para desarrollo"
EOF

chmod +x ~/.local/bin/dev-setup-complete

dev_log "SUCCESS" "Scripts de integración configurados"

############################################
# MENSAJE FINAL
############################################

echo "=========================================="
echo "🎉 SISTEMA BASE DE DESARROLLO COMPLETADO"
echo "=========================================="
echo ""
echo "�️ SISTEMA HÍBRIDO CONFIGURADO:"
echo "• Sistema base con TODAS las herramientas de desarrollo - HOST"
echo "• Entornos de ejecución independientes - CONTAINERS"
echo "• Integración completa entre scripts y servicios"
echo "• Logging centralizado y verificación automática"
echo ""
echo "📦 HERRAMIENTAS INSTALADAS EN HOST:"
echo "• IDEs: VS Code (con extensiones), PyCharm, IntelliJ disponibles"
echo "• Clientes BD: PostgreSQL, MySQL, Redis, MongoDB"
echo "• Herramientas CLI: Docker, Git, Modern CLI tools (bat, exa, fd, rg)"
echo "• Monitoring: htop, btop, iotop, netstat, tcpdump"
echo "• Development: make, cmake, gcc, g++, gdb, valgrind"
echo ""
echo "🐳 CONTENEDORES PREPARADOS PARA:"
echo "• Python 3.11 + Poetry + Django/FastAPI + Data Science"
echo "• Node.js 18 + npm/yarn + React/Vue/Angular + TypeScript"
echo "• Java 17 + Maven + Gradle + Spring Boot"
echo "• Go 1.21 + air + debugging tools"
echo "• Databases: PostgreSQL 15, MySQL 8, Redis 7, MongoDB 7"
echo "• Tools: Traefik, MailHog, MinIO, Elasticsearch, Kibana"
echo ""
echo "🔗 SCRIPTS DE INTEGRACIÓN:"
echo "• dev-check           - Verificar estado del sistema completo"
echo "• dev-init            - Inicializar entorno de desarrollo"
echo "• dev-setup-complete  - Setup automático de todo el stack"
echo "• backup-projects     - Backup automático de proyectos"
echo "• update-dev-tools    - Actualizar todas las herramientas"
echo ""
echo "📁 Estructura organizada:"
echo "• ~/Development/projects/{python,nodejs,java,golang,shared}"
echo "• ~/Development/containers/{python,nodejs,java,golang,databases,tools}"
echo "• ~/Development/{tools,logs,backups,templates,scripts}"
echo ""
echo "🚀 INICIALIZACIÓN RÁPIDA:"
echo ""
echo "1. OBLIGATORIO - Reiniciar sesión (para Docker):"
echo "   logout && login"
echo ""
echo "2. Setup automático completo:"
echo "   dev-setup-complete"
echo ""
echo "3. O paso a paso:"
echo "   dev-check                    # Verificar sistema"
echo "   dev-setup all               # Configurar contenedores"
echo "   dev-start                   # Iniciar todos los servicios"
echo ""
echo "4. Desarrollo diario:"
echo "   dev-status                  # Ver estado"
echo "   py-dev                      # Conectar a Python"
echo "   node-dev                    # Conectar a Node.js"
echo "   java-dev                    # Conectar a Java"
echo "   go-dev                      # Conectar a Go"
echo ""
echo "� DOCUMENTACIÓN:"
echo "• INDEX.md              - Índice de toda la documentación"
echo "• QUICKSTART.md         - Setup en 5 minutos"
echo "• README_CONTAINERS.md  - Guía completa de contenedores"
echo "• TROUBLESHOOTING.md    - Solución de problemas"
echo ""
echo "🎯 FUNCIONES NUEVAS DISPONIBLES:"
echo "• newpy <proyecto>      - Crear proyecto Python completo"
echo "• newnode <proyecto>    - Crear proyecto Node.js completo"
echo "• opencode [proyecto]   - Abrir proyecto en VS Code"
echo "• devup/devdown         - Gestión rápida de servicios"
echo "• devstatus            - Estado completo del sistema"
echo "• devclean             - Limpiar cache y contenedores"
echo ""
echo "⚡ VENTAJAS DE ESTE SISTEMA:"
echo "✅ Sistema base completo con todas las herramientas"
echo "✅ Contenedores independientes e interconectados"
echo "✅ Scripts integrados entre sí"
echo "✅ Logging centralizado y verificación automática"
echo "✅ Backup automático y gestión de proyectos"
echo "✅ IDEs locales + desarrollo containerizado"
echo "✅ Workflow optimizado para desarrolladores"
echo ""
echo "🔥 ¡El sistema más completo para desarrollo!"
echo "=========================================="

sleep 10
