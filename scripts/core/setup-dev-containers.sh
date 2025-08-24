#!/bin/bash

############################################
# GESTOR INTEGRADO DE ENTORNOS DE DESARROLLO
# Versión: 3.0 - Completamente Integrado
# Autor: Sistema Unificado para Desarrolladores
# Fecha: Agosto 2025
############################################
# Este script crea y gestiona entornos de desarrollo
# completamente containerizados con Docker.
# 
# CARACTERÍSTICAS:
# - Integrado con sistema de logging y configuración
# - Soporte completo para todas las herramientas
# - Interconexión inteligente entre contenedores
# - Gestión automática de dependencias
############################################

set -e  # Salir si hay algún error

# Cargar configuración integrada
if [ -f ~/.dev_config ]; then
    source ~/.dev_config
    show_message() {
        dev_log "INFO" "$1"
    }
    show_warning() {
        dev_log "WARN" "$1"
    }
    show_error() {
        dev_log "ERROR" "$1"
    }
    show_step() {
        dev_log "INFO" "PASO: $1"
    }
else
    # Funciones básicas si no está la configuración integrada
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m'
    
    show_message() {
        echo -e "${GREEN}[INFO]${NC} $1"
    }
    show_warning() {
        echo -e "${YELLOW}[WARNING]${NC} $1"
    }
    show_error() {
        echo -e "${RED}[ERROR]${NC} $1"
    }
    show_step() {
        echo -e "${BLUE}[STEP]${NC} $1"
    }
fi

############################################
# CONFIGURACIÓN GLOBAL INTEGRADA
############################################

# Usar configuración global si está disponible, sino usar defaults
CONTAINERS_DIR="${DEV_CONTAINERS:-$HOME/Development/containers}"
PROJECTS_DIR="${DEV_PROJECTS:-$HOME/Development/projects}"
TOOLS_DIR="${DEV_TOOLS:-$HOME/Development/tools}"
LOGS_DIR="${DEV_LOGS:-$HOME/Development/logs}"
BACKUPS_DIR="${DEV_BACKUPS:-$HOME/Development/backups}"

NETWORK_NAME="dev-network"
NETWORK_SUBNET="172.20.0.0/16"

# Configuración de base de datos desde archivo de configuración
DB_USER="${DB_USER:-developer}"
DB_PASS="${DB_PASS:-devpass}"
POSTGRES_DB="${POSTGRES_DB:-devdb}"
MYSQL_DB="${MYSQL_DB:-devdb}"
MONGO_DB="${MONGO_DB:-devdb}"
COMPOSE_PROJECT="devenv"

# Crear directorios base
mkdir -p "$CONTAINERS_DIR"/{python,nodejs,java,golang,php,databases,tools}
mkdir -p "$PROJECTS_DIR"/{python,nodejs,java,golang,php,shared}

############################################
# FUNCIONES DE GESTIÓN DE RED
############################################

create_dev_network() {
    show_step "Creando red de desarrollo..."
    
    if ! docker network ls | grep -q "$NETWORK_NAME"; then
        docker network create \
            --driver bridge \
            --subnet=172.20.0.0/16 \
            --gateway=172.20.0.1 \
            "$NETWORK_NAME"
        show_message "Red '$NETWORK_NAME' creada exitosamente"
    else
        show_message "Red '$NETWORK_NAME' ya existe"
    fi
}

############################################
# CONTENEDOR PYTHON
############################################

create_python_container() {
    show_step "Configurando entorno Python..."
    
    cat > "$CONTAINERS_DIR/python/Dockerfile" << 'EOF'
FROM python:3.11-slim

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    nano \
    build-essential \
    libpq-dev \
    default-libmysqlclient-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Instalar Poetry para gestión de dependencias
RUN pip install poetry

# Configurar Poetry
RUN poetry config virtualenvs.create false

# Instalar herramientas de desarrollo Python
RUN pip install --upgrade pip && \
    pip install \
    # Web frameworks
    flask \
    django \
    fastapi \
    uvicorn[standard] \
    # Data science
    pandas \
    numpy \
    matplotlib \
    seaborn \
    jupyter \
    # Database clients
    psycopg2-binary \
    pymongo \
    redis \
    sqlalchemy \
    # Development tools
    black \
    flake8 \
    pytest \
    pytest-cov \
    mypy \
    # Utilities
    requests \
    python-dotenv \
    click \
    pydantic

# Crear usuario de desarrollo
RUN useradd -m -s /bin/bash developer && \
    echo "developer:devpass" | chpasswd && \
    usermod -aG sudo developer

# Configurar directorio de trabajo
WORKDIR /workspace

# Cambiar a usuario developer
USER developer

# Configurar Git (se sobrescribirá con volúmenes)
RUN git config --global user.name "Developer" && \
    git config --global user.email "dev@example.com"

EXPOSE 8000 5000 8080

CMD ["/bin/bash"]
EOF

    cat > "$CONTAINERS_DIR/python/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  python-dev:
    build: .
    container_name: python-dev-env
    hostname: python-dev
    networks:
      - dev-network
    volumes:
      - ../../projects/python:/workspace/projects
      - ../../projects/shared:/workspace/shared
      - python-venvs:/home/developer/.local/share/virtualenvs
      - ~/.gitconfig:/home/developer/.gitconfig:ro
      - ~/.ssh:/home/developer/.ssh:ro
    ports:
      - "8000:8000"   # Django/FastAPI
      - "5000:5000"   # Flask
      - "8888:8888"   # Jupyter
    environment:
      - PYTHONPATH=/workspace
      - PYTHONDONTWRITEBYTECODE=1
      - PYTHONUNBUFFERED=1
    stdin_open: true
    tty: true
    restart: unless-stopped

volumes:
  python-venvs:

networks:
  dev-network:
    external: true
EOF

    show_message "Contenedor Python configurado"
}

############################################
# CONTENEDOR NODE.JS
############################################

create_nodejs_container() {
    show_step "Configurando entorno Node.js..."
    
    cat > "$CONTAINERS_DIR/nodejs/Dockerfile" << 'EOF'
FROM node:18-slim

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    nano \
    python3 \
    python3-pip \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Instalar herramientas globales de Node.js
RUN npm install -g \
    nodemon \
    pm2 \
    live-server \
    http-server \
    create-react-app \
    @vue/cli \
    @angular/cli \
    next \
    nuxt \
    eslint \
    prettier \
    typescript \
    ts-node \
    @nestjs/cli \
    express-generator

# Instalar Yarn
RUN npm install -g yarn

# Crear usuario de desarrollo
RUN useradd -m -s /bin/bash developer && \
    echo "developer:devpass" | chpasswd && \
    usermod -aG sudo developer

# Configurar directorio de trabajo
WORKDIR /workspace

# Cambiar a usuario developer
USER developer

# Configurar Git
RUN git config --global user.name "Developer" && \
    git config --global user.email "dev@example.com"

EXPOSE 3000 3001 4200 8080 9000

CMD ["/bin/bash"]
EOF

    cat > "$CONTAINERS_DIR/nodejs/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  nodejs-dev:
    build: .
    container_name: nodejs-dev-env
    hostname: nodejs-dev
    networks:
      - dev-network
    volumes:
      - ../../projects/nodejs:/workspace/projects
      - ../../projects/shared:/workspace/shared
      - nodejs-modules:/home/developer/.npm
      - ~/.gitconfig:/home/developer/.gitconfig:ro
      - ~/.ssh:/home/developer/.ssh:ro
    ports:
      - "3000:3000"   # React/Next.js
      - "3001:3001"   # Additional dev server
      - "4200:4200"   # Angular
      - "8080:8080"   # Vue.js
      - "9000:9000"   # Additional port
    environment:
      - NODE_ENV=development
    stdin_open: true
    tty: true
    restart: unless-stopped

volumes:
  nodejs-modules:

networks:
  dev-network:
    external: true
EOF

    show_message "Contenedor Node.js configurado"
}

############################################
# CONTENEDOR JAVA
############################################

create_java_container() {
    show_step "Configurando entorno Java..."
    
    cat > "$CONTAINERS_DIR/java/Dockerfile" << 'EOF'
FROM openjdk:17-jdk-slim

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    wget \
    vim \
    nano \
    build-essential \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Instalar Maven
ENV MAVEN_VERSION=3.9.4
RUN wget https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
    tar -xzf apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt && \
    ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven && \
    rm apache-maven-${MAVEN_VERSION}-bin.tar.gz

# Instalar Gradle
ENV GRADLE_VERSION=8.3
RUN wget https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle-${GRADLE_VERSION}-bin.zip -d /opt && \
    ln -s /opt/gradle-${GRADLE_VERSION} /opt/gradle && \
    rm gradle-${GRADLE_VERSION}-bin.zip

# Configurar PATH
ENV PATH="/opt/maven/bin:/opt/gradle/bin:${PATH}"

# Crear usuario de desarrollo
RUN useradd -m -s /bin/bash developer && \
    echo "developer:devpass" | chpasswd && \
    usermod -aG sudo developer

# Configurar directorio de trabajo
WORKDIR /workspace

# Cambiar a usuario developer
USER developer

# Configurar Git
RUN git config --global user.name "Developer" && \
    git config --global user.email "dev@example.com"

EXPOSE 8080 8090 9090

CMD ["/bin/bash"]
EOF

    cat > "$CONTAINERS_DIR/java/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  java-dev:
    build: .
    container_name: java-dev-env
    hostname: java-dev
    networks:
      - dev-network
    volumes:
      - ../../projects/java:/workspace/projects
      - ../../projects/shared:/workspace/shared
      - java-m2:/home/developer/.m2
      - java-gradle:/home/developer/.gradle
      - ~/.gitconfig:/home/developer/.gitconfig:ro
      - ~/.ssh:/home/developer/.ssh:ro
    ports:
      - "8080:8080"   # Spring Boot
      - "8090:8090"   # Additional Java app
      - "9090:9090"   # Additional port
    environment:
      - JAVA_OPTS=-Xmx2g -Xms512m
    stdin_open: true
    tty: true
    restart: unless-stopped

volumes:
  java-m2:
  java-gradle:

networks:
  dev-network:
    external: true
EOF

    show_message "Contenedor Java configurado"
}

############################################
# CONTENEDOR GOLANG
############################################

create_golang_container() {
    show_step "Configurando entorno Go..."
    
    cat > "$CONTAINERS_DIR/golang/Dockerfile" << 'EOF'
FROM golang:1.21-alpine

# Instalar dependencias del sistema
RUN apk add --no-cache \
    git \
    curl \
    wget \
    vim \
    nano \
    build-base \
    bash

# Instalar herramientas de Go
RUN go install github.com/cosmtrek/air@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest && \
    go install golang.org/x/tools/gopls@latest && \
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest

# Crear usuario de desarrollo
RUN adduser -D -s /bin/bash developer && \
    echo "developer:devpass" | chpasswd

# Configurar directorio de trabajo
WORKDIR /workspace

# Cambiar a usuario developer
USER developer

# Configurar Git
RUN git config --global user.name "Developer" && \
    git config --global user.email "dev@example.com"

# Configurar Go
ENV GOPROXY=https://proxy.golang.org
ENV GO111MODULE=on

EXPOSE 8080 3000 9000

CMD ["/bin/bash"]
EOF

    cat > "$CONTAINERS_DIR/golang/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  golang-dev:
    build: .
    container_name: golang-dev-env
    hostname: golang-dev
    networks:
      - dev-network
    volumes:
      - ../../projects/golang:/workspace/projects
      - ../../projects/shared:/workspace/shared
      - golang-pkg:/go/pkg
      - ~/.gitconfig:/home/developer/.gitconfig:ro
      - ~/.ssh:/home/developer/.ssh:ro
    ports:
      - "8080:8080"   # Go web server
      - "3000:3000"   # Additional port
      - "9000:9000"   # Debug port
    environment:
      - CGO_ENABLED=1
      - GOOS=linux
    stdin_open: true
    tty: true
    restart: unless-stopped

volumes:
  golang-pkg:

networks:
  dev-network:
    external: true
EOF

    show_message "Contenedor Go configurado"
}

############################################
# STACK DE BASES DE DATOS
############################################

create_database_stack() {
    show_step "Configurando stack de bases de datos..."
    
    cat > "$CONTAINERS_DIR/databases/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: dev-postgres
    hostname: postgres-db
    networks:
      - dev-network
    environment:
      - POSTGRES_DB=devdb
      - POSTGRES_USER=developer
      - POSTGRES_PASSWORD=devpass
      - POSTGRES_INITDB_ARGS=--encoding=UTF-8 --lc-collate=C --lc-ctype=C
    volumes:
      - postgres-data:/var/lib/postgresql/data
      - ./init-scripts:/docker-entrypoint-initdb.d
    ports:
      - "5432:5432"
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U developer -d devdb"]
      interval: 30s
      timeout: 10s
      retries: 5

  mysql:
    image: mysql:8.0
    container_name: dev-mysql
    hostname: mysql-db
    networks:
      - dev-network
    environment:
      - MYSQL_ROOT_PASSWORD=rootpass
      - MYSQL_DATABASE=devdb
      - MYSQL_USER=developer
      - MYSQL_PASSWORD=devpass
    volumes:
      - mysql-data:/var/lib/mysql
    ports:
      - "3306:3306"
    restart: unless-stopped
    command: --default-authentication-plugin=mysql_native_password

  redis:
    image: redis:7-alpine
    container_name: dev-redis
    hostname: redis-db
    networks:
      - dev-network
    volumes:
      - redis-data:/data
    ports:
      - "6379:6379"
    restart: unless-stopped
    command: redis-server --appendonly yes

  mongodb:
    image: mongo:7
    container_name: dev-mongodb
    hostname: mongodb-db
    networks:
      - dev-network
    environment:
      - MONGO_INITDB_ROOT_USERNAME=admin
      - MONGO_INITDB_ROOT_PASSWORD=devpass
      - MONGO_INITDB_DATABASE=devdb
    volumes:
      - mongodb-data:/data/db
    ports:
      - "27017:27017"
    restart: unless-stopped

  # Herramientas de administración
  adminer:
    image: adminer:latest
    container_name: dev-adminer
    hostname: adminer
    networks:
      - dev-network
    ports:
      - "8080:8080"
    restart: unless-stopped
    depends_on:
      - postgres
      - mysql

  mongo-express:
    image: mongo-express:latest
    container_name: dev-mongo-express
    hostname: mongo-express
    networks:
      - dev-network
    environment:
      - ME_CONFIG_MONGODB_ADMINUSERNAME=admin
      - ME_CONFIG_MONGODB_ADMINPASSWORD=devpass
      - ME_CONFIG_MONGODB_URL=mongodb://admin:devpass@mongodb-db:27017/
    ports:
      - "8081:8081"
    restart: unless-stopped
    depends_on:
      - mongodb

  redis-commander:
    image: rediscommander/redis-commander:latest
    container_name: dev-redis-commander
    hostname: redis-commander
    networks:
      - dev-network
    environment:
      - REDIS_HOSTS=local:redis-db:6379
    ports:
      - "8082:8081"
    restart: unless-stopped
    depends_on:
      - redis

volumes:
  postgres-data:
  mysql-data:
  redis-data:
  mongodb-data:

networks:
  dev-network:
    external: true
EOF

    # Crear scripts de inicialización de PostgreSQL
    mkdir -p "$CONTAINERS_DIR/databases/init-scripts"
    
    cat > "$CONTAINERS_DIR/databases/init-scripts/01-create-dev-databases.sql" << 'EOF'
-- Crear bases de datos adicionales para desarrollo
CREATE DATABASE testdb;
CREATE DATABASE appdb;

-- Crear esquemas útiles
\c devdb;
CREATE SCHEMA IF NOT EXISTS api;
CREATE SCHEMA IF NOT EXISTS web;

-- Crear usuario adicional con permisos
CREATE USER dev_readonly WITH PASSWORD 'readonly';
GRANT CONNECT ON DATABASE devdb TO dev_readonly;
GRANT USAGE ON SCHEMA public TO dev_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO dev_readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO dev_readonly;
EOF

    show_message "Stack de bases de datos configurado"
}

############################################
# HERRAMIENTAS Y UTILIDADES
############################################

create_tools_stack() {
    show_step "Configurando stack de herramientas..."
    
    cat > "$CONTAINERS_DIR/tools/docker-compose.yml" << 'EOF'
version: '3.8'

services:
  # Reverse proxy para desarrollo
  traefik:
    image: traefik:v3.0
    container_name: dev-traefik
    hostname: traefik
    networks:
      - dev-network
    command:
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
      - "--entrypoints.websecure.address=:443"
    ports:
      - "80:80"
      - "443:443"
      - "8090:8080"  # Traefik dashboard
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    restart: unless-stopped

  # Mailhog para testing de emails
  mailhog:
    image: mailhog/mailhog:latest
    container_name: dev-mailhog
    hostname: mailhog
    networks:
      - dev-network
    ports:
      - "1025:1025"  # SMTP
      - "8025:8025"  # Web interface
    restart: unless-stopped

  # MinIO para S3 compatible storage
  minio:
    image: minio/minio:latest
    container_name: dev-minio
    hostname: minio
    networks:
      - dev-network
    environment:
      - MINIO_ROOT_USER=minioadmin
      - MINIO_ROOT_PASSWORD=minioadmin
    volumes:
      - minio-data:/data
    ports:
      - "9000:9000"
      - "9090:9090"
    command: server /data --console-address ":9090"
    restart: unless-stopped

  # Elasticsearch para búsqueda
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.10.0
    container_name: dev-elasticsearch
    hostname: elasticsearch
    networks:
      - dev-network
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
    volumes:
      - elasticsearch-data:/usr/share/elasticsearch/data
    ports:
      - "9200:9200"
    restart: unless-stopped

  # Kibana para visualización
  kibana:
    image: docker.elastic.co/kibana/kibana:8.10.0
    container_name: dev-kibana
    hostname: kibana
    networks:
      - dev-network
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    ports:
      - "5601:5601"
    depends_on:
      - elasticsearch
    restart: unless-stopped

volumes:
  minio-data:
  elasticsearch-data:

networks:
  dev-network:
    external: true
EOF

    show_message "Stack de herramientas configurado"
}

############################################
# FUNCIÓN PRINCIPAL DE SETUP
############################################

setup_all_containers() {
    show_step "Iniciando configuración completa de contenedores..."
    
    # Verificar que Docker esté instalado y corriendo
    if ! command -v docker &> /dev/null; then
        show_error "Docker no está instalado. Instalar primero."
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        show_error "Docker no está corriendo. Iniciar el servicio primero."
        exit 1
    fi
    
    # Crear red de desarrollo
    create_dev_network
    
    # Crear todos los contenedores
    create_python_container
    create_nodejs_container  
    create_java_container
    create_golang_container
    create_database_stack
    create_tools_stack
    
    show_message "Todas las configuraciones de contenedores creadas exitosamente"
    show_message "Directorio de contenedores: $CONTAINERS_DIR"
    show_message "Directorio de proyectos: $PROJECTS_DIR"
}

############################################
# MENÚ INTERACTIVO
############################################

show_menu() {
    echo
    echo -e "${PURPLE}=== GESTOR DE ENTORNOS DE DESARROLLO ===${NC}"
    echo -e "${CYAN}1.${NC} Configurar todos los entornos"
    echo -e "${CYAN}2.${NC} Configurar solo Python"
    echo -e "${CYAN}3.${NC} Configurar solo Node.js"
    echo -e "${CYAN}4.${NC} Configurar solo Java"
    echo -e "${CYAN}5.${NC} Configurar solo Go"
    echo -e "${CYAN}6.${NC} Configurar solo Bases de Datos"
    echo -e "${CYAN}7.${NC} Configurar solo Herramientas"
    echo -e "${CYAN}8.${NC} Crear red de desarrollo"
    echo -e "${CYAN}0.${NC} Salir"
    echo
}

############################################
# MAIN
############################################

main() {
    echo -e "${GREEN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════╗
║           ENTORNOS DE DESARROLLO EN DOCKER          ║
║                                                      ║
║  Crea entornos containerizados para desarrollo      ║
║  Python | Node.js | Java | Go | Databases | Tools   ║
╚══════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
    
    if [ "$#" -eq 0 ]; then
        # Menú interactivo
        while true; do
            show_menu
            read -p "Selecciona una opción: " choice
            
            case $choice in
                1)
                    setup_all_containers
                    ;;
                2)
                    create_dev_network
                    create_python_container
                    ;;
                3)
                    create_dev_network
                    create_nodejs_container
                    ;;
                4)
                    create_dev_network
                    create_java_container
                    ;;
                5)
                    create_dev_network
                    create_golang_container
                    ;;
                6)
                    create_dev_network
                    create_database_stack
                    ;;
                7)
                    create_dev_network
                    create_tools_stack
                    ;;
                8)
                    create_dev_network
                    ;;
                0)
                    echo "¡Hasta luego!"
                    exit 0
                    ;;
                *)
                    show_error "Opción inválida"
                    ;;
            esac
            
            read -p "Presiona Enter para continuar..."
        done
    else
        # Modo comando directo
        case "$1" in
            "all")
                setup_all_containers
                ;;
            "python"|"py")
                create_dev_network
                create_python_container
                ;;
            "nodejs"|"node"|"js")
                create_dev_network
                create_nodejs_container
                ;;
            "java")
                create_dev_network
                create_java_container
                ;;
            "golang"|"go")
                create_dev_network
                create_golang_container
                ;;
            "databases"|"db")
                create_dev_network
                create_database_stack
                ;;
            "tools")
                create_dev_network
                create_tools_stack
                ;;
            "network")
                create_dev_network
                ;;
            *)
                echo "Uso: $0 [all|python|nodejs|java|golang|databases|tools|network]"
                exit 1
                ;;
        esac
    fi
    
    show_message "Proceso completado exitosamente!"
    echo
    show_warning "Próximos pasos:"
    echo "1. Ejecutar: 'bash dev-manager.sh' para gestionar los contenedores"  
    echo "2. Leer: 'README_CONTAINERS.md' para instrucciones detalladas"
    echo
}

# Ejecutar función principal
main "$@"
