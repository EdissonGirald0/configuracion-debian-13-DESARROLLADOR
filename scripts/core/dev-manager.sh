#!/bin/bash

############################################
# GESTOR INTEGRADO DE CONTENEDORES DE DESARROLLO
# Versión: 3.0 - Sistema Completamente Integrado
# Controla el ciclo de vida de los entornos
############################################

set -e

# Cargar configuración integrada si está disponible
if [ -f ~/.dev_config ]; then
    source ~/.dev_config
fi

if [ -f ~/.dev_logger ]; then
    source ~/.dev_logger
    # Usar sistema de logging integrado
    show_message() { dev_log "INFO" "$1"; }
    show_warning() { dev_log "WARN" "$1"; }
    show_error() { dev_log "ERROR" "$1"; }
    show_step() { dev_log "INFO" "PASO: $1"; }
    show_success() { dev_log "SUCCESS" "$1"; }
else
    # Funciones básicas si no está el sistema integrado
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
    
    show_message() { echo -e "${GREEN}[INFO]${NC} $1"; }
    show_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
    show_error() { echo -e "${RED}[ERROR]${NC} $1"; }
    show_step() { echo -e "${BLUE}[STEP]${NC} $1"; }
    show_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
fi

# Configuración integrada
CONTAINERS_DIR="${DEV_CONTAINERS:-$HOME/Development/containers}"
PROJECTS_DIR="${DEV_PROJECTS:-$HOME/Development/projects}"
TOOLS_DIR="${DEV_TOOLS:-$HOME/Development/tools}"
LOGS_DIR="${DEV_LOGS:-$HOME/Development/logs}"

NETWORK_NAME="dev-network"
NETWORK_SUBNET="172.20.0.0/16"

# Definir servicios con configuración extendida
SERVICES=(
    "python:python-dev-env:Python Development:${PYTHON_DEV_PORT:-8000}"
    "nodejs:nodejs-dev-env:Node.js Development:${NODEJS_DEV_PORT:-3000}" 
    "java:java-dev-env:Java Development:${JAVA_DEV_PORT:-8080}"
    "golang:golang-dev-env:Go Development:${GOLANG_DEV_PORT:-9000}"
    "databases:Database Stack:PostgreSQL, MySQL, Redis, MongoDB:multiple"
    "tools:Tools Stack:Traefik, MailHog, MinIO, Elasticsearch:multiple"
)

############################################
# FUNCIONES UTILITARIAS INTEGRADAS
############################################

# Verificar si un contenedor está corriendo
is_container_running() {
    docker ps --filter "name=$1" --format "{{.Names}}" | grep -q "^$1$"
}

# Verificar si un servicio existe
service_exists() {
    [ -d "$CONTAINERS_DIR/$1" ] && [ -f "$CONTAINERS_DIR/$1/docker-compose.yml" ]
}

# Obtener estado de un contenedor
get_container_status() {
    if is_container_running "$2"; then
        echo -e "${GREEN}🟢 Running${NC}"
    elif docker ps -a --filter "name=$2" --format "{{.Names}}" | grep -q "^$2$"; then
        echo -e "${RED}🔴 Stopped${NC}"
    else
        echo -e "${YELLOW}⚪ Not Created${NC}"
    fi
}

# Iniciar servicio
start_service() {
    local service=$1
    
    if ! service_exists "$service"; then
        show_error "Servicio '$service' no configurado. Ejecuta setup-dev-containers.sh primero."
        return 1
    fi
    
    show_step "Iniciando servicio $service..."
    cd "$CONTAINERS_DIR/$service"
    
    if docker-compose up -d; then
        show_success "Servicio $service iniciado exitosamente"
        
        # Mostrar información específica del servicio
        show_service_info "$service"
    else
        show_error "Error al iniciar servicio $service"
        return 1
    fi
}

# Parar servicio
stop_service() {
    local service=$1
    
    if ! service_exists "$service"; then
        show_error "Servicio '$service' no existe."
        return 1
    fi
    
    show_step "Parando servicio $service..."
    cd "$CONTAINERS_DIR/$service"
    
    if docker-compose down; then
        show_success "Servicio $service parado exitosamente"
    else
        show_error "Error al parar servicio $service"
        return 1
    fi
}

# Reiniciar servicio
restart_service() {
    local service=$1
    stop_service "$service"
    sleep 2
    start_service "$service"
}

# Mostrar logs de un servicio
show_logs() {
    local service=$1
    
    if ! service_exists "$service"; then
        show_error "Servicio '$service' no existe."
        return 1
    fi
    
    cd "$CONTAINERS_DIR/$service"
    docker-compose logs -f --tail=100
}

# Entrar en el contenedor
enter_container() {
    local container_name=$1
    
    if ! is_container_running "$container_name"; then
        show_error "Contenedor '$container_name' no está corriendo."
        return 1
    fi
    
    show_step "Conectando al contenedor $container_name..."
    docker exec -it "$container_name" /bin/bash
}

# Mostrar información específica del servicio
show_service_info() {
    local service=$1
    
    echo
    echo -e "${CYAN}=== Información del Servicio: $service ===${NC}"
    
    case $service in
        "python")
            echo "🐍 Python Development Environment"
            echo "   - Contenedor: python-dev-env"
            echo "   - Puertos: 8000 (Django/FastAPI), 5000 (Flask), 8888 (Jupyter)"
            echo "   - Conectar: dev-manager.sh connect python-dev-env"
            echo "   - Proyectos: ~/Development/projects/python"
            ;;
        "nodejs")
            echo "📦 Node.js Development Environment"  
            echo "   - Contenedor: nodejs-dev-env"
            echo "   - Puertos: 3000 (React/Next.js), 4200 (Angular), 8080 (Vue.js)"
            echo "   - Conectar: dev-manager.sh connect nodejs-dev-env"
            echo "   - Proyectos: ~/Development/projects/nodejs"
            ;;
        "java")
            echo "☕ Java Development Environment"
            echo "   - Contenedor: java-dev-env"
            echo "   - Puertos: 8080 (Spring Boot), 8090, 9090"
            echo "   - Conectar: dev-manager.sh connect java-dev-env"
            echo "   - Proyectos: ~/Development/projects/java"
            ;;
        "golang")
            echo "🐹 Go Development Environment"
            echo "   - Contenedor: golang-dev-env" 
            echo "   - Puertos: 8080, 3000, 9000"
            echo "   - Conectar: dev-manager.sh connect golang-dev-env"
            echo "   - Proyectos: ~/Development/projects/golang"
            ;;
        "databases")
            echo "🗄️ Database Stack"
            echo "   - PostgreSQL: localhost:5432 (user: developer, pass: devpass)"
            echo "   - MySQL: localhost:3306 (user: developer, pass: devpass)"
            echo "   - Redis: localhost:6379"
            echo "   - MongoDB: localhost:27017 (user: admin, pass: devpass)"
            echo "   - Adminer: http://localhost:8080"
            echo "   - Mongo Express: http://localhost:8081"
            echo "   - Redis Commander: http://localhost:8082"
            ;;
        "tools")
            echo "🛠️ Tools Stack"
            echo "   - Traefik Dashboard: http://localhost:8090"
            echo "   - MailHog: http://localhost:8025"
            echo "   - MinIO: http://localhost:9090"
            echo "   - Elasticsearch: http://localhost:9200"
            echo "   - Kibana: http://localhost:5601"
            ;;
    esac
    echo
}

# Mostrar estado de todos los servicios
show_status() {
    echo -e "${PURPLE}=== ESTADO DE SERVICIOS DE DESARROLLO ===${NC}"
    echo
    
    for service_info in "${SERVICES[@]}"; do
        IFS=':' read -r service container description <<< "$service_info"
        
        if [ "$service" = "databases" ] || [ "$service" = "tools" ]; then
            # Para stacks multi-contenedor, verificar si algún contenedor está corriendo
            cd "$CONTAINERS_DIR/$service" 2>/dev/null || continue
            if docker-compose ps | grep -q "Up"; then
                status="${GREEN}🟢 Running${NC}"
            else
                status="${RED}🔴 Stopped${NC}"
            fi
        else
            status=$(get_container_status "$service" "$container")
        fi
        
        printf "%-15s %-20s %s\n" "$service" "$status" "$description"
    done
    
    echo
    echo -e "${CYAN}Red de desarrollo:${NC}"
    if docker network ls | grep -q "$NETWORK_NAME"; then
        echo -e "  dev-network: ${GREEN}🟢 Activa${NC}"
    else
        echo -e "  dev-network: ${RED}🔴 No existe${NC}"
    fi
}

# Iniciar todos los servicios
start_all() {
    show_step "Iniciando todos los servicios de desarrollo..."
    
    # Iniciar servicios en orden específico
    for service in databases tools python nodejs java golang; do
        if service_exists "$service"; then
            start_service "$service"
            sleep 3  # Esperar entre inicios
        fi
    done
    
    show_success "Todos los servicios disponibles han sido iniciados"
}

# Parar todos los servicios
stop_all() {
    show_step "Parando todos los servicios de desarrollo..."
    
    for service_info in "${SERVICES[@]}"; do
        IFS=':' read -r service container description <<< "$service_info"
        if service_exists "$service"; then
            stop_service "$service"
        fi
    done
    
    show_success "Todos los servicios han sido parados"
}

# Limpiar contenedores no utilizados
cleanup() {
    show_step "Limpiando contenedores y volúmenes no utilizados..."
    
    read -p "¿Estás seguro de querer limpiar? (y/N): " confirm
    if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
        docker container prune -f
        docker image prune -f
        docker volume prune -f
        docker network prune -f
        show_success "Limpieza completada"
    else
        show_message "Limpieza cancelada"
    fi
}

# Actualizar imágenes
update_images() {
    show_step "Actualizando imágenes de contenedores..."
    
    for service_info in "${SERVICES[@]}"; do
        IFS=':' read -r service container description <<< "$service_info"
        if service_exists "$service"; then
            cd "$CONTAINERS_DIR/$service"
            docker-compose pull
        fi
    done
    
    show_success "Imágenes actualizadas"
}

# Backup de volúmenes
backup_volumes() {
    show_step "Creando backup de volúmenes de datos..."
    
    local backup_dir="$HOME/Development/backups/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"
    
    # Backup de volúmenes de bases de datos
    if service_exists "databases"; then
        docker run --rm -v dev_postgres-data:/data -v "$backup_dir":/backup alpine tar czf /backup/postgres-data.tar.gz -C / data
        docker run --rm -v dev_mysql-data:/data -v "$backup_dir":/backup alpine tar czf /backup/mysql-data.tar.gz -C / data
        docker run --rm -v dev_redis-data:/data -v "$backup_dir":/backup alpine tar czf /backup/redis-data.tar.gz -C / data
        docker run --rm -v dev_mongodb-data:/data -v "$backup_dir":/backup alpine tar czf /backup/mongodb-data.tar.gz -C / data
    fi
    
    show_success "Backup creado en: $backup_dir"
}

############################################
# MENÚ PRINCIPAL
############################################

show_menu() {
    echo
    echo -e "${PURPLE}=== GESTOR DE CONTENEDORES DE DESARROLLO ===${NC}"
    echo -e "${CYAN}Servicios:${NC}"
    echo -e "  ${CYAN}start <servicio>${NC}     - Iniciar servicio específico"
    echo -e "  ${CYAN}stop <servicio>${NC}      - Parar servicio específico"
    echo -e "  ${CYAN}restart <servicio>${NC}   - Reiniciar servicio específico"
    echo -e "  ${CYAN}logs <servicio>${NC}      - Mostrar logs de servicio"
    echo -e "  ${CYAN}connect <contenedor>${NC} - Conectar a contenedor"
    echo
    echo -e "${CYAN}Gestión Global:${NC}"
    echo -e "  ${CYAN}status${NC}               - Estado de todos los servicios"
    echo -e "  ${CYAN}start-all${NC}            - Iniciar todos los servicios"
    echo -e "  ${CYAN}stop-all${NC}             - Parar todos los servicios"
    echo -e "  ${CYAN}update${NC}               - Actualizar imágenes"
    echo -e "  ${CYAN}cleanup${NC}              - Limpiar contenedores no utilizados"
    echo -e "  ${CYAN}backup${NC}               - Backup de volúmenes de datos"
    echo
    echo -e "${CYAN}Servicios disponibles:${NC}"
    echo -e "  python, nodejs, java, golang, databases, tools"
    echo
}

# Mostrar ayuda con ejemplos
show_help() {
    echo -e "${GREEN}=== AYUDA - GESTOR DE CONTENEDORES ===${NC}"
    echo
    echo -e "${YELLOW}Ejemplos de uso:${NC}"
    echo
    echo -e "${CYAN}# Iniciar entorno Python${NC}"
    echo "  ./dev-manager.sh start python"
    echo
    echo -e "${CYAN}# Conectar al contenedor Python${NC}"
    echo "  ./dev-manager.sh connect python-dev-env"
    echo
    echo -e "${CYAN}# Iniciar stack completo de bases de datos${NC}"
    echo "  ./dev-manager.sh start databases"
    echo
    echo -e "${CYAN}# Ver logs de Node.js${NC}"
    echo "  ./dev-manager.sh logs nodejs"
    echo
    echo -e "${CYAN}# Estado de todos los servicios${NC}"
    echo "  ./dev-manager.sh status"
    echo
    echo -e "${CYAN}# Iniciar todo el entorno de desarrollo${NC}"
    echo "  ./dev-manager.sh start-all"
    echo
    echo -e "${YELLOW}Estructura de proyectos:${NC}"
    echo "  ~/Development/projects/python/    - Proyectos Python"
    echo "  ~/Development/projects/nodejs/    - Proyectos Node.js"
    echo "  ~/Development/projects/java/      - Proyectos Java"
    echo "  ~/Development/projects/golang/    - Proyectos Go"
    echo "  ~/Development/projects/shared/    - Archivos compartidos"
    echo
    echo -e "${YELLOW}Conexiones a bases de datos desde IDEs locales:${NC}"
    echo "  PostgreSQL: localhost:5432 (user: developer, pass: devpass)"
    echo "  MySQL:      localhost:3306 (user: developer, pass: devpass)"
    echo "  Redis:      localhost:6379"
    echo "  MongoDB:    localhost:27017 (user: admin, pass: devpass)"
    echo
}

############################################
# MAIN
############################################

main() {
    # Verificar que Docker esté disponible
    if ! command -v docker &> /dev/null; then
        show_error "Docker no está instalado"
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        show_error "Docker no está corriendo"
        exit 1
    fi
    
    # Si no hay argumentos, mostrar menú
    if [ "$#" -eq 0 ]; then
        show_menu
        exit 0
    fi
    
    # Procesar comandos
    case "$1" in
        "start")
            if [ -z "$2" ]; then
                show_error "Especifica un servicio: python, nodejs, java, golang, databases, tools"
                exit 1
            fi
            start_service "$2"
            ;;
        "stop")
            if [ -z "$2" ]; then
                show_error "Especifica un servicio: python, nodejs, java, golang, databases, tools"
                exit 1
            fi
            stop_service "$2"
            ;;
        "restart")
            if [ -z "$2" ]; then
                show_error "Especifica un servicio"
                exit 1
            fi
            restart_service "$2"
            ;;
        "logs")
            if [ -z "$2" ]; then
                show_error "Especifica un servicio"
                exit 1
            fi
            show_logs "$2"
            ;;
        "connect")
            if [ -z "$2" ]; then
                show_error "Especifica un contenedor: python-dev-env, nodejs-dev-env, java-dev-env, golang-dev-env"
                exit 1
            fi
            enter_container "$2"
            ;;
        "status")
            show_status
            ;;
        "start-all")
            start_all
            ;;
        "stop-all")
            stop_all
            ;;
        "update")
            update_images
            ;;
        "cleanup")
            cleanup
            ;;
        "backup")
            backup_volumes
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            show_error "Comando desconocido: $1"
            show_menu
            exit 1
            ;;
    esac
}

# Ejecutar función principal
main "$@"
