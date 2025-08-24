#!/bin/bash

############################################
# SCRIPT MAESTRO DE INTEGRACIÓN
# Coordina todos los scripts del sistema de desarrollo
# Versión: 1.0 - Sistema Unificado
############################################

set -e

# Cargar sistema integrado
if [ -f ~/.dev_config ]; then
    source ~/.dev_config
fi

if [ -f ~/.dev_logger ]; then
    source ~/.dev_logger
else
    # Logging básico
    dev_log() {
        local level="$1"
        local message="$2"
        case "$level" in
            "ERROR")   echo "❌ $message" ;;
            "WARN")    echo "⚠️  $message" ;;
            "INFO")    echo "ℹ️  $message" ;;
            "SUCCESS") echo "✅ $message" ;;
            *)         echo "$message" ;;
        esac
    }
fi

############################################
# CONFIGURACIÓN DEL SCRIPT MAESTRO
############################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_NAME=$(basename "$0")

# Scripts disponibles con dependencias
declare -A SCRIPTS
SCRIPTS["base"]="01-install-developer.sh:Instalación base del sistema:mandatory"
SCRIPTS["tools"]="03-config-dev-tools.sh:Configuración de herramientas:depends_on_base"
SCRIPTS["containers"]="setup-dev-containers.sh:Setup de contenedores:depends_on_tools"
SCRIPTS["manager"]="dev-manager.sh:Gestor de contenedores:depends_on_containers"

############################################
# FUNCIONES DE UTILIDAD
############################################

show_header() {
    echo "=============================================="
    echo "🚀 SISTEMA MAESTRO DE DESARROLLO INTEGRADO"
    echo "=============================================="
    echo "Coordina todos los scripts del sistema"
    echo
}

show_help() {
    cat << 'EOF'
📚 USO: master-dev [comando] [opciones]

🔧 COMANDOS PRINCIPALES:
  install [step]        Instalación completa o por pasos
  setup [service]       Configurar servicios específicos
  start [service]       Iniciar servicios
  stop [service]        Parar servicios
  restart [service]     Reiniciar servicios
  status               Ver estado completo
  logs [service]       Ver logs
  clean               Limpiar sistema
  backup              Crear backup completo
  update              Actualizar todo el sistema
  check               Verificar integridad del sistema
  repair              Reparar problemas automáticamente

📋 PASOS DE INSTALACIÓN:
  install base         Solo instalación base
  install tools        Solo configuración de herramientas
  install containers   Solo configuración de contenedores
  install all          Instalación completa (DEFAULT)

🔧 SERVICIOS DISPONIBLES:
  python              Entorno Python
  nodejs              Entorno Node.js
  java                Entorno Java
  golang              Entorno Go
  databases           Stack de bases de datos
  tools               Herramientas adicionales
  all                 Todos los servicios (DEFAULT)

💡 EJEMPLOS:
  master-dev install            # Instalación completa
  master-dev setup python       # Solo configurar Python
  master-dev start databases     # Solo iniciar BD
  master-dev status             # Ver estado
  master-dev logs python        # Ver logs de Python
  master-dev check              # Verificar sistema

🆘 AYUDA Y DEBUGGING:
  master-dev check              # Verificación completa
  master-dev repair             # Reparación automática
  master-dev logs system        # Logs del sistema completo
EOF
}

check_script_exists() {
    local script_name="$1"
    
    # Buscar script en nueva estructura organizada
    for script_path in "$SCRIPT_DIR/core/$script_name" "$SCRIPT_DIR/$script_name" "./$script_name" "~/.local/bin/$script_name"; do
        if [ -f "$script_path" ]; then
            echo "$script_path"
            return 0
        fi
    done
    
    return 1
}

check_dependencies() {
    dev_log "INFO" "Verificando dependencias del sistema..."
    
    local missing_deps=()
    
    # Verificar herramientas esenciales
    for cmd in "bash" "curl" "wget" "git"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        dev_log "ERROR" "Dependencias críticas faltantes: ${missing_deps[*]}"
        return 1
    fi
    
    dev_log "SUCCESS" "Dependencias básicas verificadas"
    return 0
}

############################################
# FUNCIONES DE INSTALACIÓN
############################################

install_base() {
    dev_log "INFO" "Ejecutando instalación base del sistema..."
    
    local script_path=$(check_script_exists "01-install-developer.sh")
    if [ $? -eq 0 ]; then
        dev_log "INFO" "Ejecutando: $script_path"
        chmod +x "$script_path"
        bash "$script_path"
        dev_log "SUCCESS" "Instalación base completada"
        
        # Marcar progreso
        echo "base_completed:$(date)" > ~/.dev_install_progress
        
        dev_log "WARN" "REINICIA TU SESIÓN para aplicar cambios de Docker"
        dev_log "INFO" "Después del reinicio ejecuta: master-dev install continue"
    else
        dev_log "ERROR" "Script 01-install-developer.sh no encontrado en $SCRIPT_DIR"
        return 1
    fi
}

install_tools() {
    dev_log "INFO" "Ejecutando configuración de herramientas..."
    
    local script_path=$(check_script_exists "03-config-dev-tools.sh")
    if [ $? -eq 0 ]; then
        dev_log "INFO" "Ejecutando: $script_path"
        chmod +x "$script_path"
        bash "$script_path"
        dev_log "SUCCESS" "Configuración de herramientas completada"
        
        # Marcar progreso
        echo "tools_completed:$(date)" >> ~/.dev_install_progress
    else
        dev_log "ERROR" "Script 03-config-dev-tools.sh no encontrado"
        return 1
    fi
}

install_containers() {
    dev_log "INFO" "Ejecutando configuración de contenedores..."
    
    local script_path=$(check_script_exists "setup-dev-containers.sh")
    if [ $? -eq 0 ]; then
        dev_log "INFO" "Ejecutando: $script_path all"
        chmod +x "$script_path"
        bash "$script_path" all
        dev_log "SUCCESS" "Configuración de contenedores completada"
        
        # Marcar progreso
        echo "containers_completed:$(date)" >> ~/.dev_install_progress
    else
        dev_log "ERROR" "Script setup-dev-containers.sh no encontrado"
        return 1
    fi
}

install_manager() {
    dev_log "INFO" "Configurando gestor de contenedores..."
    
    local script_path=$(check_script_exists "dev-manager.sh")
    if [ $? -eq 0 ]; then
        dev_log "INFO" "Instalando gestor: $script_path"
        chmod +x "$script_path"
        cp "$script_path" ~/.local/bin/dev-manager
        
        # Crear enlaces simbólicos
        for cmd in "dev-start" "dev-stop" "dev-status" "dev-logs" "dev-restart"; do
            ln -sf ~/.local/bin/dev-manager ~/.local/bin/$cmd
        done
        
        dev_log "SUCCESS" "Gestor de contenedores configurado"
        
        # Marcar progreso
        echo "manager_completed:$(date)" >> ~/.dev_install_progress
    else
        dev_log "ERROR" "Script dev-manager.sh no encontrado"
        return 1
    fi
}

install_all() {
    dev_log "INFO" "Iniciando instalación completa del sistema de desarrollo..."
    
    echo "🚀 INSTALACIÓN COMPLETA - SISTEMA DE DESARROLLO INTEGRADO"
    echo "=========================================================="
    echo
    echo "Este proceso instalará:"
    echo "1. 🏗️  Sistema base con todas las herramientas"
    echo "2. ⚙️  Configuración de herramientas de desarrollo"
    echo "3. 🐳 Contenedores Docker para todos los lenguajes"
    echo "4. 🎮 Gestor unificado de contenedores"
    echo "5. ✅ Verificación completa del sistema"
    echo
    
    read -p "¿Continuar con la instalación completa? (y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        dev_log "INFO" "Instalación cancelada"
        return 0
    fi
    
    # Paso 1: Instalación base
    if ! install_base; then
        dev_log "ERROR" "Falló la instalación base"
        return 1
    fi
    
    # Verificar si necesita reinicio
    if ! groups $USER | grep -q docker; then
        dev_log "WARN" "REINICIO REQUERIDO"
        echo "=============================================="
        echo "⚠️  REINICIO DE SESIÓN NECESARIO"
        echo "=============================================="
        echo
        echo "Para continuar:"
        echo "1. Cierra completamente tu sesión"
        echo "2. Vuelve a iniciar sesión"
        echo "3. Ejecuta: master-dev install continue"
        echo
        return 0
    fi
    
    # Si no necesita reinicio, continuar
    if ! install_tools; then
        dev_log "ERROR" "Falló la configuración de herramientas"
        return 1
    fi
    
    if ! install_containers; then
        dev_log "ERROR" "Falló la configuración de contenedores"
        return 1
    fi
    
    if ! install_manager; then
        dev_log "ERROR" "Falló la configuración del gestor"
        return 1
    fi
    
    # Verificación final
    system_final_check
    
    echo "=============================================="
    echo "🎉 INSTALACIÓN COMPLETA EXITOSA"
    echo "=============================================="
    echo
    echo "Sistema listo para desarrollo. Comandos disponibles:"
    echo "• master-dev status      - Ver estado completo"
    echo "• master-dev start all   - Iniciar todos los servicios"
    echo "• master-dev logs system - Ver logs del sistema"
    echo "• dev-init              - Inicializar proyecto nuevo"
    echo "• opencode              - Abrir VS Code con proyecto"
    echo
    dev_log "SUCCESS" "Sistema de desarrollo completamente instalado y listo"
}

install_continue() {
    if [ ! -f ~/.dev_install_progress ]; then
        dev_log "ERROR" "No hay instalación en progreso"
        dev_log "INFO" "Para instalación completa ejecuta: master-dev install all"
        return 1
    fi
    
    dev_log "INFO" "Continuando instalación después del reinicio..."
    
    # Verificar que el usuario está en grupo docker
    if ! groups $USER | grep -q docker; then
        dev_log "ERROR" "Usuario aún no está en grupo docker"
        dev_log "INFO" "Asegúrate de haber reiniciado completamente la sesión"
        return 1
    fi
    
    # Verificar que Docker funciona
    if ! docker info &> /dev/null; then
        dev_log "ERROR" "Docker no está funcionando correctamente"
        dev_log "INFO" "Ejecuta: sudo systemctl start docker"
        return 1
    fi
    
    dev_log "SUCCESS" "Verificación post-reinicio completada"
    
    # Continuar con los pasos restantes
    install_tools
    install_containers
    install_manager
    
    # Ejecutar verificación final completa
    system_final_check
    
    # Limpiar archivo de progreso
    rm ~/.dev_install_progress
    
    dev_log "SUCCESS" "Instalación completa finalizada exitosamente"
}

############################################
# FUNCIONES DE GESTIÓN DE SERVICIOS
############################################

setup_service() {
    local service="$1"
    
    if [ -z "$service" ]; then
        service="all"
    fi
    
    dev_log "INFO" "Configurando servicio: $service"
    
    if command -v dev-setup &> /dev/null; then
        dev-setup "$service"
    else
        local script_path=$(check_script_exists "setup-dev-containers.sh")
        if [ $? -eq 0 ]; then
            bash "$script_path" "$service"
        else
            dev_log "ERROR" "No se puede configurar $service - script no encontrado"
            return 1
        fi
    fi
}

start_service() {
    local service="$1"
    
    if [ -z "$service" ]; then
        service="all"
    fi
    
    dev_log "INFO" "Iniciando servicio: $service"
    
    if command -v dev-start &> /dev/null && [ "$service" = "all" ]; then
        dev-start
    elif command -v dev &> /dev/null; then
        dev start "$service"
    else
        # Backup: usar docker-compose directamente
        if [ "$service" = "all" ]; then
            for svc in python nodejs java golang databases tools; do
                start_service_direct "$svc"
            done
        else
            start_service_direct "$service"
        fi
    fi
}

start_service_direct() {
    local service="$1"
    local service_dir="$CONTAINERS_DIR/$service"
    
    if [ -d "$service_dir" ] && [ -f "$service_dir/docker-compose.yml" ]; then
        cd "$service_dir"
        docker-compose up -d
        dev_log "SUCCESS" "Servicio $service iniciado"
    else
        dev_log "ERROR" "Servicio $service no configurado"
        return 1
    fi
}

stop_service() {
    local service="$1"
    
    if [ -z "$service" ]; then
        service="all"
    fi
    
    dev_log "INFO" "Parando servicio: $service"
    
    if command -v dev-stop &> /dev/null && [ "$service" = "all" ]; then
        dev-stop
    elif command -v dev &> /dev/null; then
        dev stop "$service"
    else
        # Backup: usar docker-compose directamente
        if [ "$service" = "all" ]; then
            for svc in python nodejs java golang databases tools; do
                stop_service_direct "$svc"
            done
        else
            stop_service_direct "$service"
        fi
    fi
}

stop_service_direct() {
    local service="$1"
    local service_dir="$CONTAINERS_DIR/$service"
    
    if [ -d "$service_dir" ] && [ -f "$service_dir/docker-compose.yml" ]; then
        cd "$service_dir"
        docker-compose down
        dev_log "SUCCESS" "Servicio $service parado"
    else
        dev_log "WARN" "Servicio $service no encontrado o no configurado"
    fi
}

restart_service() {
    local service="$1"
    
    dev_log "INFO" "Reiniciando servicio: $service"
    stop_service "$service"
    sleep 2
    start_service "$service"
}

############################################
# FUNCIONES DE ESTADO Y MONITOREO
############################################

show_status() {
    dev_log "INFO" "Mostrando estado completo del sistema..."
    
    echo "=============================================="
    echo "📊 ESTADO COMPLETO DEL SISTEMA DE DESARROLLO"
    echo "=============================================="
    echo
    
    # Estado del sistema base
    echo "🖥️  SISTEMA BASE:"
    echo "   OS: $(lsb_release -d 2>/dev/null | cut -f2 || echo 'Linux')"
    echo "   Usuario: $USER"
    echo "   Shell: $SHELL"
    echo "   Directorio: $PWD"
    echo
    
    # Estado de Docker
    echo "🐳 DOCKER:"
    if systemctl is-active --quiet docker; then
        echo "   Estado: 🟢 Activo"
        local version=$(docker --version 2>/dev/null | cut -d' ' -f3 | cut -d',' -f1 || echo "desconocido")
        echo "   Versión: $version"
        
        if groups $USER | grep -q docker; then
            echo "   Permisos: 🟢 Usuario en grupo docker"
        else
            echo "   Permisos: 🔴 Usuario NO está en grupo docker"
        fi
        
        # Contenedores activos
        local containers=$(docker ps --format "{{.Names}}" | wc -l)
        echo "   Contenedores activos: $containers"
        
        if [ $containers -gt 0 ]; then
            echo "   Lista de contenedores:"
            docker ps --format "     {{.Names}}: {{.Status}}" | head -10
        fi
    else
        echo "   Estado: 🔴 Inactivo"
    fi
    echo
    
    # Estado de servicios de desarrollo
    echo "🔧 SERVICIOS DE DESARROLLO:"
    if command -v dev-status &> /dev/null; then
        dev-status
    else
        for service in python nodejs java golang databases tools; do
            if [ -d "$CONTAINERS_DIR/$service" ]; then
                if docker-compose -f "$CONTAINERS_DIR/$service/docker-compose.yml" ps | grep -q "Up"; then
                    echo "   $service: 🟢 Activo"
                else
                    echo "   $service: 🔴 Inactivo"
                fi
            else
                echo "   $service: ⚫ No configurado"
            fi
        done
    fi
    echo
    
    # Estado de recursos
    echo "💾 RECURSOS DEL SISTEMA:"
    df -h / | tail -1 | awk '{print "   Disco: " $3 "/" $2 " (" $5 " usado)"}'
    free -h | grep Mem | awk '{print "   RAM: " $3 "/" $2 " (" int($3/$2*100) "% usado)"}'
    if command -v docker &> /dev/null && docker info &> /dev/null; then
        echo "   Docker: $(docker system df --format "table {{.Type}}\t{{.Size}}" | tail -n +2 | awk '{sum+=$2} END {print sum " containers/images"}')"
    fi
    echo
    
    # Estado de proyectos
    echo "📂 PROYECTOS:"
    if [ -d "$DEV_PROJECTS" ]; then
        for lang in python nodejs java golang; do
            local lang_dir="$DEV_PROJECTS/$lang"
            if [ -d "$lang_dir" ]; then
                local count=$(find "$lang_dir" -maxdepth 1 -type d | tail -n +2 | wc -l)
                echo "   $lang: $count proyectos"
            fi
        done
    else
        echo "   Directorio de proyectos no existe: $DEV_PROJECTS"
    fi
    echo
    
    # Estado de herramientas
    echo "🛠️  HERRAMIENTAS INSTALADAS:"
    command -v python3 &>/dev/null && echo "   ✅ Python $(python3 --version | cut -d' ' -f2)"
    command -v node &>/dev/null && echo "   ✅ Node.js $(node --version)"
    command -v java &>/dev/null && echo "   ✅ Java $(java --version 2>&1 | head -1 | cut -d' ' -f2)"
    command -v go &>/dev/null && echo "   ✅ Go $(go version | cut -d' ' -f3)"
    command -v code &>/dev/null && echo "   ✅ VS Code"
    command -v docker &>/dev/null && echo "   ✅ Docker"
    command -v docker-compose &>/dev/null && echo "   ✅ Docker Compose"
    command -v git &>/dev/null && echo "   ✅ Git $(git --version | cut -d' ' -f3)"
    echo
}

show_logs() {
    local service="$1"
    
    if [ -z "$service" ]; then
        dev_log "INFO" "Servicios disponibles para logs: python, nodejs, java, golang, databases, tools, system"
        return 0
    fi
    
    case "$service" in
        "system")
            if [ -f "${DEV_LOG_FILE:-$HOME/Development/logs/development.log}" ]; then
                tail -f "${DEV_LOG_FILE:-$HOME/Development/logs/development.log}"
            else
                journalctl -f | grep -E "(docker|dev-)"
            fi
            ;;
        *)
            if command -v dev &> /dev/null; then
                dev logs "$service"
            else
                # Backup directo
                local service_dir="$CONTAINERS_DIR/$service"
                if [ -d "$service_dir" ]; then
                    cd "$service_dir"
                    docker-compose logs -f
                else
                    dev_log "ERROR" "Servicio $service no encontrado"
                fi
            fi
            ;;
    esac
}

############################################
# FUNCIONES DE MANTENIMIENTO
############################################

clean_system() {
    dev_log "INFO" "Iniciando limpieza completa del sistema..."
    
    # Limpiar Docker
    if command -v docker &> /dev/null; then
        dev_log "INFO" "Limpiando containers y cache de Docker..."
        docker container prune -f
        docker image prune -f
        docker volume prune -f
        docker network prune -f
        docker system prune -f
    fi
    
    # Limpiar cache de herramientas
    if command -v npm &> /dev/null; then
        dev_log "INFO" "Limpiando cache de npm..."
        npm cache clean --force
    fi
    
    if command -v pip3 &> /dev/null; then
        dev_log "INFO" "Limpiando cache de pip..."
        pip3 cache purge
    fi
    
    # Limpiar logs antiguos
    if [ -d "${DEV_LOGS:-$HOME/Development/logs}" ]; then
        dev_log "INFO" "Limpiando logs antiguos..."
        find "${DEV_LOGS:-$HOME/Development/logs}" -name "*.log" -mtime +7 -delete
    fi
    
    # Limpiar archivos temporales
    rm -rf /tmp/dev-* 2>/dev/null || true
    
    dev_log "SUCCESS" "Limpieza del sistema completada"
}

backup_system() {
    dev_log "INFO" "Creando backup completo del sistema..."
    
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local backup_dir="${DEV_BACKUPS:-$HOME/Development/backups}"
    mkdir -p "$backup_dir"
    
    # Backup de proyectos
    if [ -d "$DEV_PROJECTS" ]; then
        dev_log "INFO" "Backing up projects..."
        tar -czf "$backup_dir/projects-$timestamp.tar.gz" -C "$(dirname "$DEV_PROJECTS")" "$(basename "$DEV_PROJECTS")"
    fi
    
    # Backup de configuraciones
    dev_log "INFO" "Backing up configurations..."
    tar -czf "$backup_dir/configs-$timestamp.tar.gz" ~/.dev_config ~/.dev_logger ~/.dev_functions ~/.config/Code 2>/dev/null || true
    
    # Backup de containers config
    if [ -d "$DEV_CONTAINERS" ]; then
        dev_log "INFO" "Backing up container configurations..."
        tar -czf "$backup_dir/containers-$timestamp.tar.gz" -C "$(dirname "$DEV_CONTAINERS")" "$(basename "$DEV_CONTAINERS")"
    fi
    
    # Backup de base de datos
    if command -v dev &> /dev/null; then
        dev_log "INFO" "Backing up databases..."
        dev backup 2>/dev/null || true
    fi
    
    dev_log "SUCCESS" "Backup completo creado en $backup_dir"
}

update_system() {
    dev_log "INFO" "Actualizando sistema completo..."
    
    # Actualizar sistema base
    dev_log "INFO" "Actualizando sistema base..."
    sudo apt update && sudo apt upgrade -y
    
    # Actualizar herramientas si el script está disponible
    if command -v update-dev-tools-integrated &> /dev/null; then
        dev_log "INFO" "Actualizando herramientas integradas..."
        update-dev-tools-integrated
    elif command -v update-dev-tools &> /dev/null; then
        dev_log "INFO" "Actualizando herramientas..."
        update-dev-tools
    fi
    
    # Actualizar contenedores
    if [ -d "$DEV_CONTAINERS" ]; then
        dev_log "INFO" "Actualizando contenedores Docker..."
        for service_dir in "$DEV_CONTAINERS"/*; do
            if [ -d "$service_dir" ] && [ -f "$service_dir/docker-compose.yml" ]; then
                dev_log "INFO" "Actualizando $(basename "$service_dir")..."
                cd "$service_dir"
                docker-compose pull
                docker-compose up -d
            fi
        done
    fi
    
    dev_log "SUCCESS" "Actualización del sistema completada"
}

############################################
# FUNCIONES DE VERIFICACIÓN Y REPARACIÓN
############################################

system_check() {
    dev_log "INFO" "Ejecutando verificación completa del sistema..."
    
    local issues=0
    
    echo "🔍 VERIFICACIÓN COMPLETA DEL SISTEMA"
    echo "====================================="
    echo
    
    # Verificar herramientas básicas
    echo "1. 🛠️  Herramientas básicas:"
    for tool in "bash" "git" "curl" "wget" "docker" "docker-compose"; do
        if command -v "$tool" &> /dev/null; then
            echo "   ✅ $tool"
        else
            echo "   ❌ $tool (faltante)"
            ((issues++))
        fi
    done
    echo
    
    # Verificar Docker específicamente
    echo "2. 🐳 Docker:"
    if systemctl is-active --quiet docker; then
        echo "   ✅ Servicio activo"
        if groups $USER | grep -q docker; then
            echo "   ✅ Usuario en grupo docker"
        else
            echo "   ❌ Usuario NO en grupo docker"
            ((issues++))
        fi
        if docker info &> /dev/null; then
            echo "   ✅ Docker funcional"
        else
            echo "   ❌ Docker no responde"
            ((issues++))
        fi
    else
        echo "   ❌ Servicio inactivo"
        ((issues++))
    fi
    echo
    
    # Verificar estructura de directorios
    echo "3. 📁 Estructura de directorios:"
    for dir in "$DEV_HOME" "$DEV_PROJECTS" "$DEV_CONTAINERS" "$DEV_TOOLS" "$DEV_LOGS"; do
        if [ -d "$dir" ]; then
            echo "   ✅ $dir"
        else
            echo "   ❌ $dir (faltante)"
            ((issues++))
        fi
    done
    echo
    
    # Verificar scripts integrados
    echo "4. 📜 Scripts del sistema:"
    for script in "dev-check" "dev-init" "dev-setup-complete" "tools-check"; do
        if command -v "$script" &> /dev/null; then
            echo "   ✅ $script"
        else
            echo "   ❌ $script (faltante)"
            ((issues++))
        fi
    done
    echo
    
    # Verificar configuración integrada
    echo "5. ⚙️  Configuración integrada:"
    if [ -f ~/.dev_config ]; then
        echo "   ✅ Archivo de configuración global"
    else
        echo "   ❌ Configuración global faltante"
        ((issues++))
    fi
    
    if [ -f ~/.dev_logger ]; then
        echo "   ✅ Sistema de logging"
    else
        echo "   ❌ Sistema de logging faltante"
        ((issues++))
    fi
    
    if [ -f ~/.dev_functions ]; then
        echo "   ✅ Funciones de desarrollo"
    else
        echo "   ❌ Funciones de desarrollo faltantes"
        ((issues++))
    fi
    echo
    
    # Resultado final
    if [ $issues -eq 0 ]; then
        dev_log "SUCCESS" "Sistema completamente verificado - 0 problemas encontrados"
        echo "🎉 Sistema perfecto para desarrollo!"
        return 0
    else
        dev_log "WARN" "$issues problemas encontrados"
        echo "🔧 Ejecuta 'master-dev repair' para reparar automáticamente"
        return 1
    fi
}

repair_system() {
    dev_log "INFO" "Iniciando reparación automática del sistema..."
    
    local repairs=0
    
    # Reparar Docker si no está activo
    if ! systemctl is-active --quiet docker; then
        dev_log "INFO" "Reparando Docker..."
        sudo systemctl start docker
        sudo systemctl enable docker
        ((repairs++))
    fi
    
    # Reparar grupo docker
    if ! groups $USER | grep -q docker; then
        dev_log "INFO" "Agregando usuario al grupo docker..."
        sudo usermod -aG docker $USER
        dev_log "WARN" "Reinicia sesión para aplicar cambios de grupo"
        ((repairs++))
    fi
    
    # Reparar estructura de directorios
    for dir in "$DEV_HOME" "$DEV_PROJECTS" "$DEV_CONTAINERS" "$DEV_TOOLS" "$DEV_LOGS" "$DEV_BACKUPS"; do
        if [ ! -d "$dir" ]; then
            dev_log "INFO" "Creando directorio faltante: $dir"
            mkdir -p "$dir"
            ((repairs++))
        fi
    done
    
    # Reparar red de Docker
    if ! docker network ls | grep -q "$NETWORK_NAME"; then
        dev_log "INFO" "Creando red de desarrollo..."
        docker network create --driver bridge --subnet=172.20.0.0/16 "$NETWORK_NAME"
        ((repairs++))
    fi
    
    # Reparar scripts faltantes
    if ! command -v dev-check &> /dev/null; then
        dev_log "INFO" "Reparando scripts de verificación..."
        if command -v dev-setup-complete &> /dev/null; then
            dev-setup-complete
        fi
        ((repairs++))
    fi
    
    if [ $repairs -eq 0 ]; then
        dev_log "SUCCESS" "No se necesitaron reparaciones"
    else
        dev_log "SUCCESS" "$repairs reparaciones completadas"
        dev_log "INFO" "Ejecuta 'master-dev check' para verificar"
    fi
}

system_final_check() {
    dev_log "INFO" "Ejecutando verificación final post-instalación..."
    
    sleep 2
    
    echo "🎯 VERIFICACIÓN FINAL"
    echo "===================="
    
    # Verificar cada componente crítico
    local all_good=true
    
    # Docker
    if systemctl is-active --quiet docker && groups $USER | grep -q docker; then
        echo "✅ Docker: Configurado correctamente"
    else
        echo "❌ Docker: Requiere atención"
        all_good=false
    fi
    
    # Estructura de directorios
    if [ -d "$DEV_HOME" ] && [ -d "$DEV_PROJECTS" ] && [ -d "$DEV_CONTAINERS" ]; then
        echo "✅ Directorios: Estructura completa"
    else
        echo "❌ Directorios: Estructura incompleta"
        all_good=false
    fi
    
    # Configuración integrada
    if [ -f ~/.dev_config ] && [ -f ~/.dev_logger ] && [ -f ~/.dev_functions ]; then
        echo "✅ Configuración: Sistema integrado"
    else
        echo "❌ Configuración: Sistema no integrado"
        all_good=false
    fi
    
    # Scripts de gestión
    if command -v dev-check &> /dev/null && command -v dev-init &> /dev/null; then
        echo "✅ Scripts: Gestión disponible"
    else
        echo "❌ Scripts: Gestión incompleta"
        all_good=false
    fi
    
    echo
    if [ "$all_good" = true ]; then
        dev_log "SUCCESS" "SISTEMA COMPLETAMENTE LISTO PARA DESARROLLO"
        echo "🚀 Ejecuta: master-dev start all"
        echo "📚 Lee: INDEX.md para documentación completa"
    else
        dev_log "WARN" "Sistema parcialmente configurado"
        echo "🔧 Ejecuta: master-dev repair"
    fi
}

############################################
# FUNCIÓN PRINCIPAL
############################################

main() {
    local command="${1:-help}"
    local param="${2:-all}"
    
    # Verificar dependencias básicas al inicio
    if [ "$command" != "help" ] && [ "$command" != "check" ]; then
        check_dependencies || exit 1
    fi
    
    case "$command" in
        "install")
            show_header
            case "$param" in
                "base")      install_base ;;
                "tools")     install_tools ;;
                "containers") install_containers ;;
                "manager")   install_manager ;;
                "continue")  install_continue ;;
                "all"|*)     install_all ;;
            esac
            ;;
        "setup")
            setup_service "$param"
            ;;
        "start")
            start_service "$param"
            ;;
        "stop")
            stop_service "$param"
            ;;
        "restart")
            restart_service "$param"
            ;;
        "status")
            show_status
            ;;
        "logs")
            show_logs "$param"
            ;;
        "clean")
            clean_system
            ;;
        "backup")
            backup_system
            ;;
        "update")
            update_system
            ;;
        "check")
            system_check
            ;;
        "repair")
            repair_system
            ;;
        "help"|*)
            show_help
            ;;
    esac
}

# Ejecutar función principal con todos los parámetros
main "$@"
