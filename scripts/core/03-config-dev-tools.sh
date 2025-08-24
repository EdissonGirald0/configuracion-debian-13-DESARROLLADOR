#!/bin/bash

############################################
# Script post-instalación para configurar
# herramientas específicas de desarrollo
# INTEGRADO CON SISTEMA DE LOGGING Y CONFIGURACIÓN
############################################

# Cargar configuración y logging si están disponibles
if [ -f ~/.dev_config ]; then
    source ~/.dev_config
fi

if [ -f ~/.dev_logger ]; then
    source ~/.dev_logger
else
    # Funciones básicas de logging si no está disponible
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

echo "=================================="
echo "CONFIGURACIÓN POST-INSTALACIÓN"
echo "Herramientas específicas de desarrollo"
echo "=================================="

# Verificar si estamos como usuario normal
if [ "$(whoami)" == "root" ]; then
    dev_log "ERROR" "Ejecutar como usuario normal"
    exit 1
fi

dev_log "INFO" "Iniciando configuración post-instalación..."

# Usar variables de configuración global si están disponibles
DEV_HOME=${DEV_HOME:-"$HOME/Development"}
DEV_PROJECTS=${DEV_PROJECTS:-"$HOME/Development/projects"}
DEV_TOOLS=${DEV_TOOLS:-"$HOME/Development/tools"}
DEV_LOGS=${DEV_LOGS:-"$HOME/Development/logs"}

# Crear directorios usando variables
mkdir -p "$DEV_HOME"/{projects,tools,logs,backups,templates,scripts}
mkdir -p "$DEV_PROJECTS"/{python,nodejs,java,golang,shared}

############################################
# CONFIGURAR ENTORNO DE PYTHON INTEGRADO
############################################

dev_log "INFO" "Configurando entorno Python integrado..."

# Crear entorno virtual usando configuración global
PYTHON_ENVS_DIR="$DEV_HOME/python-envs"
mkdir -p "$PYTHON_ENVS_DIR"
cd "$PYTHON_ENVS_DIR"

# Crear entorno virtual base con herramientas comunes
if [ ! -d "base" ]; then
    dev_log "INFO" "Creando entorno Python base..."
    python3 -m venv base
    source base/bin/activate
    
    # Instalar herramientas esenciales de Python
    dev_log "INFO" "Instalando herramientas Python esenciales..."
    pip install --upgrade pip setuptools wheel
    pip install \
        # Desarrollo web
        flask django fastapi uvicorn \
        # Data science básico
        numpy pandas matplotlib seaborn \
        # Testing
        pytest pytest-cov pytest-mock \
        # Code quality
        black flake8 pylint mypy isort \
        # Herramientas útiles
        requests httpx \
        ipython jupyter \
        python-dotenv \
        click typer \
        # Database connectors (para conectar a contenedores)
        psycopg2-binary \
        pymongo \
        redis \
        sqlalchemy \
        # Development tools
        rich \
        pydantic
    
    deactivate
    dev_log "SUCCESS" "Entorno Python base creado en $PYTHON_ENVS_DIR/base"
else
    dev_log "INFO" "Entorno Python base ya existe"
fi

# Crear función para activar entorno Python
cat > ~/.local/bin/activate-py-base << 'EOF'
#!/bin/bash
source ~/.dev_config
source "$DEV_HOME/python-envs/base/bin/activate"
export PS1="(python-base) $PS1"
EOF
chmod +x ~/.local/bin/activate-py-base

############################################
# CONFIGURAR NODE.JS Y NPM INTEGRADO
############################################

dev_log "INFO" "Configurando Node.js y npm con sistema integrado..."

# Verificar que Node.js está instalado
if ! command -v node &> /dev/null; then
    dev_log "WARN" "Node.js no está instalado, instalando..."
    # Instalar Node.js via NodeSource
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt install -y nodejs
fi

# Configurar npm para evitar problemas de permisos
npm config set prefix "$DEV_TOOLS/npm-global"
export PATH="$DEV_TOOLS/npm-global/bin:$PATH"

# Instalar herramientas globales útiles
dev_log "INFO" "Instalando herramientas Node.js globales..."
npm install -g \
    # Herramientas de desarrollo
    nodemon \
    live-server \
    http-server \
    serve \
    # Frameworks y tools
    create-react-app \
    @vue/cli \
    @angular/cli \
    @nestjs/cli \
    # Build tools
    webpack \
    webpack-cli \
    parcel \
    vite \
    # Utilidades
    eslint \
    prettier \
    typescript \
    ts-node \
    # Package managers
    yarn \
    pnpm \
    # Deployment y build
    vercel \
    netlify-cli \
    # Development utilities
    concurrently \
    cross-env \
    rimraf \
    # Testing
    jest \
    # Docker integration
    docker-compose-viz

# Crear función para gestionar proyectos Node.js
cat > ~/.local/bin/node-project << 'EOF'
#!/bin/bash
source ~/.dev_config 2>/dev/null || true

case "$1" in
    "new")
        if [ -z "$2" ]; then
            echo "Uso: node-project new <nombre>"
            exit 1
        fi
        mkdir -p "$DEV_PROJECTS/nodejs/$2"
        cd "$DEV_PROJECTS/nodejs/$2"
        npm init -y
        npm install --save-dev nodemon eslint prettier
        echo "✅ Proyecto Node.js '$2' creado"
        ;;
    "list")
        ls -la "$DEV_PROJECTS/nodejs/"
        ;;
    *)
        echo "Uso: node-project {new|list} [nombre]"
        ;;
esac
EOF
chmod +x ~/.local/bin/node-project

dev_log "SUCCESS" "Node.js configurado con sistema integrado"

############################################
# CONFIGURAR DOCKER COMPOSE SAMPLES
############################################

echo "🐳 Configurando plantillas Docker..."

mkdir -p ~/Development/containers/templates

# PostgreSQL + Redis template
cat > ~/Development/containers/templates/postgres-redis.yml << 'EOF'
version: '3.8'
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: devdb
      POSTGRES_USER: developer
      POSTGRES_PASSWORD: devpass
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
EOF

# MongoDB + Redis template
cat > ~/Development/containers/templates/mongo-redis.yml << 'EOF'
version: '3.8'
services:
  mongodb:
    image: mongo:6
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: devpass
    ports:
      - "27017:27017"
    volumes:
      - mongo_data:/data/db

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

volumes:
  mongo_data:
  redis_data:
EOF

# Full stack development template
cat > ~/Development/containers/templates/fullstack-dev.yml << 'EOF'
version: '3.8'
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: appdb
      POSTGRES_USER: developer
      POSTGRES_PASSWORD: devpass
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  mailhog:
    image: mailhog/mailhog
    ports:
      - "8025:8025"  # Web interface
      - "1025:1025"  # SMTP server

  adminer:
    image: adminer
    ports:
      - "8080:8080"
    depends_on:
      - postgres

volumes:
  postgres_data:
  redis_data:
EOF

echo "✅ Plantillas Docker creadas en ~/Development/containers/templates/"

############################################
# CONFIGURAR EXTENSIONES DE VS CODE INTEGRADAS
############################################

dev_log "INFO" "Configurando VS Code con sistema integrado..."

# Verificar que VS Code está instalado
if ! command -v code &> /dev/null; then
    dev_log "WARN" "VS Code no está instalado, instalando..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install -y code
fi

# Instalar extensiones esenciales para desarrollo containerizado
dev_log "INFO" "Instalando extensiones de VS Code..."

# Core extensions
code --install-extension ms-python.python
code --install-extension ms-python.black-formatter
code --install-extension ms-python.flake8
code --install-extension ms-python.pylint
code --install-extension ms-vscode.vscode-typescript-next
code --install-extension bradlc.vscode-tailwindcss
code --install-extension esbenp.prettier-vscode

# Remote development (clave para contenedores)
code --install-extension ms-vscode-remote.vscode-remote-extensionpack
code --install-extension ms-vscode-remote.remote-containers
code --install-extension ms-vscode-remote.remote-ssh

# Docker integration
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-kubernetes-tools.vscode-kubernetes-tools

# Database tools
code --install-extension ms-mssql.mssql
code --install-extension bradlc.vscode-tailwindcss
code --install-extension cweijan.vscode-postgresql-client2
code --install-extension cweijan.vscode-mysql-client2
code --install-extension cweijan.vscode-redis-client

# Development utilities
code --install-extension formulahendry.auto-rename-tag
code --install-extension ms-vscode.vscode-json
code --install-extension redhat.vscode-yaml
code --install-extension eamodio.gitlens
code --install-extension github.copilot
code --install-extension github.vscode-pull-request-github
code --install-extension github.codespaces

# Language support
code --install-extension golang.go
code --install-extension redhat.java
code --install-extension vscjava.vscode-java-pack

# Configuración de VS Code optimizada para desarrollo containerizado
mkdir -p ~/.config/Code/User

cat > ~/.config/Code/User/settings.json << 'EOF'
{
    "editor.fontSize": 13,
    "editor.fontFamily": "'JetBrains Mono', 'Fira Code', 'Cascadia Code', monospace",
    "editor.fontLigatures": true,
    "editor.minimap.enabled": true,
    "editor.minimap.maxColumn": 120,
    "editor.rulers": [80, 120],
    "editor.wordWrap": "wordWrapColumn",
    "editor.wordWrapColumn": 100,
    "editor.tabSize": 4,
    "editor.insertSpaces": true,
    "editor.detectIndentation": true,
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.organizeImports": "explicit",
        "source.fixAll.eslint": "explicit"
    },
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,
    "files.autoSave": "afterDelay",
    "files.autoSaveDelay": 1000,
    
    "workbench.colorTheme": "One Dark Pro",
    "workbench.iconTheme": "material-icon-theme",
    "workbench.startupEditor": "welcomePage",
    
    "terminal.integrated.shell.linux": "/bin/bash",
    "terminal.integrated.fontSize": 12,
    "terminal.integrated.cursorStyle": "line",
    "terminal.integrated.copyOnSelection": true,
    
    "python.defaultInterpreterPath": "/workspace/.venv/bin/python",
    "python.formatting.provider": "black",
    "python.linting.enabled": true,
    "python.linting.flake8Enabled": true,
    "python.linting.pylintEnabled": true,
    "python.testing.pytestEnabled": true,
    
    "git.enableSmartCommit": true,
    "git.confirmSync": false,
    "git.autofetch": true,
    
    "docker.showStartPage": false,
    "docker.dockerodeOptions": {
        "version": "auto"
    },
    
    "remote.containers.defaultExtensions": [
        "ms-python.python",
        "ms-vscode.vscode-typescript-next",
        "ms-azuretools.vscode-docker"
    ],
    
    "remote.containers.logLevel": "info",
    
    "extensions.ignoreRecommendations": false,
    "extensions.autoUpdate": true,
    
    "security.workspace.trust.untrustedFiles": "open",
    
    "explorer.confirmDelete": false,
    "explorer.confirmDragAndDrop": false,
    
    "emmet.includeLanguages": {
        "javascript": "javascriptreact",
        "typescript": "typescriptreact"
    }
}
EOF

# Crear configuración específica para desarrollo containerizado
cat > ~/.config/Code/User/tasks.json << 'EOF'
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Conectar a Python Container",
            "type": "shell",
            "command": "py-dev",
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            }
        },
        {
            "label": "Conectar a Node.js Container", 
            "type": "shell",
            "command": "node-dev",
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always", 
                "focus": false,
                "panel": "new"
            }
        },
        {
            "label": "Iniciar Servicios de Desarrollo",
            "type": "shell",
            "command": "dev-start",
            "group": "build",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            }
        },
        {
            "label": "Ver Estado de Contenedores",
            "type": "shell", 
            "command": "dev-status",
            "group": "test",
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": false,
                "panel": "new"
            }
        }
    ]
}
EOF

dev_log "SUCCESS" "VS Code configurado con soporte completo para contenedores"

############################################
# CONFIGURAR FUNCIONES ÚTILES INTEGRADAS
############################################

dev_log "INFO" "Configurando funciones de desarrollo integradas..."

# Crear archivo de funciones de desarrollo mejorado
cat > ~/.dev_functions << 'EOF'
#!/bin/bash

# Cargar configuración si está disponible
if [ -f ~/.dev_config ]; then
    source ~/.dev_config
fi

if [ -f ~/.dev_logger ]; then
    source ~/.dev_logger
fi

# Función mejorada para crear nuevo proyecto Python
newpy() {
    if [ -z "$1" ]; then
        echo "Uso: newpy <nombre_proyecto> [tipo]"
        echo "Tipos: web, api, data, cli, basic"
        return 1
    fi
    
    local project_name="$1"
    local project_type="${2:-basic}"
    local project_dir="${DEV_PROJECTS:-$HOME/Development/projects}/python/$project_name"
    
    dev_log "INFO" "Creando proyecto Python '$project_name' tipo '$project_type'..."
    
    mkdir -p "$project_dir"
    cd "$project_dir"
    
    # Crear entorno virtual
    python3 -m venv venv
    source venv/bin/activate
    
    # Instalar herramientas básicas
    pip install --upgrade pip setuptools wheel
    pip install black flake8 pytest python-dotenv
    
    # Instalar dependencias según tipo
    case "$project_type" in
        "web")
            pip install django django-cors-headers django-extensions
            django-admin startproject backend .
            ;;
        "api")
            pip install fastapi uvicorn pydantic sqlalchemy psycopg2-binary
            ;;
        "data")
            pip install pandas numpy matplotlib seaborn jupyter scikit-learn
            ;;
        "cli")
            pip install click typer rich
            ;;
    esac
    
    # Crear estructura básica
    mkdir -p src tests docs
    touch src/__init__.py tests/__init__.py
    
    # Crear archivos de configuración
    cat > .env << 'ENVEOF'
# Configuración de desarrollo
DEBUG=True
DATABASE_URL=postgresql://developer:devpass@localhost:5432/devdb
REDIS_URL=redis://localhost:6379/0
ENVEOF

    cat > requirements.txt << 'REQEOF'
# Generado automáticamente - actualizar con: pip freeze > requirements.txt
REQEOF

    cat > .gitignore << 'GITEOF'
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/
.pytest_cache/
.coverage
htmlcov/
.tox/
.nox/
.coverage
.pytest_cache/
cover/
.DS_Store
GITEOF

    # Crear README con template
    cat > README.md << 'READEOF'
# {project_name}

Proyecto Python tipo {project_type}

## Setup

```bash
# Activar entorno virtual
source venv/bin/activate

# Instalar dependencias
pip install -r requirements.txt

# Ejecutar tests
pytest

# Ejecutar aplicación
python src/main.py
```

## Desarrollo con Contenedores

```bash
# Conectar a contenedor Python
py-dev

# Navegar al proyecto
cd /workspace/projects/{project_name}

# Desarrollar normalmente
```
READEOF

    # Reemplazar placeholders
    sed -i "s/{project_name}/$project_name/g" README.md
    sed -i "s/{project_type}/$project_type/g" README.md
    
    # Inicializar git
    git init
    git add .
    git commit -m "Initial commit: $project_type project setup"
    
    deactivate
    
    dev_log "SUCCESS" "Proyecto Python '$project_name' creado en $project_dir"
    echo "💡 Para desarrollar: py-dev && cd /workspace/projects/$project_name"
}

# Función mejorada para crear nuevo proyecto Node.js
newnode() {
    if [ -z "$1" ]; then
        echo "Uso: newnode <nombre_proyecto> [tipo]"
        echo "Tipos: react, vue, angular, express, nextjs, basic"
        return 1
    fi
    
    local project_name="$1"
    local project_type="${2:-basic}"
    local project_dir="${DEV_PROJECTS:-$HOME/Development/projects}/nodejs/$project_name"
    
    dev_log "INFO" "Creando proyecto Node.js '$project_name' tipo '$project_type'..."
    
    mkdir -p "$project_dir"
    cd "$project_dir"
    
    # Crear proyecto según tipo
    case "$project_type" in
        "react")
            npx create-react-app . --template typescript
            ;;
        "vue")
            npx @vue/cli create . --default
            ;;
        "angular")
            npx @angular/cli new . --routing --style=css
            ;;
        "express")
            npm init -y
            npm install express cors helmet morgan
            npm install --save-dev nodemon @types/node typescript
            ;;
        "nextjs")
            npx create-next-app@latest . --typescript --tailwind --eslint --app --src-dir --import-alias="@/*"
            ;;
        "basic")
            npm init -y
            npm install --save-dev nodemon eslint prettier
            ;;
    esac
    
    # Agregar scripts útiles al package.json si no existen
    if [ -f package.json ]; then
        # Backup del package.json original
        cp package.json package.json.bak
        
        # Agregar/actualizar scripts
        cat package.json | jq '.scripts += {
            "dev": "nodemon src/index.js",
            "start": "node src/index.js",
            "test": "jest",
            "lint": "eslint src/",
            "format": "prettier --write src/"
        }' > package.json.tmp && mv package.json.tmp package.json
    fi
    
    # Crear estructura básica si no fue creada por los frameworks
    mkdir -p src public tests
    if [ ! -f src/index.js ] && [ ! -f src/App.js ]; then
        touch src/index.js
    fi
    
    # .gitignore para Node.js
    cat > .gitignore << 'GITEOF'
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*
.npm
.eslintcache
.node_repl_history
*.tgz
.yarn-integrity
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
.cache
.parcel-cache
.next
out/
build/
dist/
.serverless/
.fusebox/
.dynamodb/
.tern-port
.DS_Store
GITEOF
    
    # Crear README
    cat > README.md << 'READEOF'
# {project_name}

Proyecto Node.js tipo {project_type}

## Setup

```bash
# Instalar dependencias
npm install

# Ejecutar en modo desarrollo
npm run dev

# Ejecutar tests
npm test

# Build para producción
npm run build
```

## Desarrollo con Contenedores

```bash
# Conectar a contenedor Node.js
node-dev

# Navegar al proyecto
cd /workspace/projects/{project_name}

# Desarrollar normalmente
npm run dev
```
READEOF

    # Reemplazar placeholders
    sed -i "s/{project_name}/$project_name/g" README.md
    sed -i "s/{project_type}/$project_type/g" README.md
    
    # Inicializar git si no existe
    if [ ! -d .git ]; then
        git init
        git add .
        git commit -m "Initial commit: $project_type project setup"
    fi
    
    dev_log "SUCCESS" "Proyecto Node.js '$project_name' creado en $project_dir"
    echo "💡 Para desarrollar: node-dev && cd /workspace/projects/$project_name"
}

# Función para abrir proyecto en VS Code con detección automática
opencode() {
    if [ -z "$1" ]; then
        # Si no se especifica proyecto, abrir directorio actual
        code .
        return 0
    fi
    
    local project_name="$1"
    local found=false
    
    # Buscar proyecto en directorios de lenguajes
    for lang_dir in "${DEV_PROJECTS:-$HOME/Development/projects}"/*; do
        if [ -d "$lang_dir" ]; then
            local project_path="$lang_dir/$project_name"
            if [ -d "$project_path" ]; then
                dev_log "SUCCESS" "Abriendo proyecto '$project_name' en VS Code..."
                code "$project_path"
                found=true
                break
            fi
        fi
    done
    
    if [ "$found" = false ]; then
        dev_log "ERROR" "Proyecto '$project_name' no encontrado"
        echo "Proyectos disponibles:"
        find "${DEV_PROJECTS:-$HOME/Development/projects}" -maxdepth 2 -type d -name ".git" | sed 's|/.git||' | sed 's|.*/||' | sort
    fi
}

# Función mejorada para iniciar servicios de desarrollo
devup() {
    dev_log "INFO" "Iniciando servicios de desarrollo..."
    
    # Verificar y iniciar Docker
    if ! systemctl is-active --quiet docker; then
        dev_log "INFO" "Iniciando Docker..."
        sudo systemctl start docker
        sleep 3
    fi
    
    # Verificar grupo docker
    if ! groups $USER | grep -q docker; then
        dev_log "WARN" "Usuario no está en grupo docker. Reinicia sesión después de la instalación."
    fi
    
    # Inicializar entorno si existe el comando
    if command -v dev-init &> /dev/null; then
        dev-init
    fi
    
    # Iniciar contenedores si existe el comando
    if command -v dev-start &> /dev/null; then
        dev-start
    fi
    
    dev_log "SUCCESS" "Servicios de desarrollo iniciados"
}

# Función mejorada para parar servicios de desarrollo
devdown() {
    dev_log "INFO" "Parando servicios de desarrollo..."
    
    # Parar contenedores si existe el comando
    if command -v dev-stop &> /dev/null; then
        dev-stop
    fi
    
    # Parar contenedores Docker manualmente
    if command -v docker &> /dev/null; then
        docker stop $(docker ps -q) 2>/dev/null || true
    fi
    
    dev_log "SUCCESS" "Servicios de desarrollo parados"
}

# Función mejorada para limpiar sistema de desarrollo
devclean() {
    dev_log "INFO" "Limpiando sistema de desarrollo..."
    
    # Limpiar Docker
    if command -v docker &> /dev/null; then
        docker system prune -f
        docker image prune -f
        docker volume prune -f
    fi
    
    # Limpiar npm cache
    if command -v npm &> /dev/null; then
        npm cache clean --force 2>/dev/null || true
    fi
    
    # Limpiar pip cache
    if command -v pip3 &> /dev/null; then
        pip3 cache purge 2>/dev/null || true
    fi
    
    # Limpiar logs antiguos
    if [ -d "${DEV_LOGS:-$HOME/Development/logs}" ]; then
        find "${DEV_LOGS:-$HOME/Development/logs}" -name "*.log" -mtime +30 -delete
    fi
    
    dev_log "SUCCESS" "Sistema limpio"
}

# Función mejorada para mostrar status de desarrollo
devstatus() {
    echo "=== STATUS DEL ENTORNO DE DESARROLLO ==="
    echo
    
    # Verificar Docker
    echo "🐳 Docker:"
    if systemctl is-active --quiet docker; then
        echo "  Estado: 🟢 Activo"
        if command -v docker &> /dev/null; then
            local containers=$(docker ps --format "table {{.Names}}\t{{.Status}}" 2>/dev/null | tail -n +2 | wc -l)
            echo "  Contenedores activos: $containers"
            if [ $containers -gt 0 ]; then
                echo "  Contenedores:"
                docker ps --format "    {{.Names}}: {{.Status}}" | head -10
            fi
        fi
    else
        echo "  Estado: 🔴 Inactivo"
    fi
    
    echo
    echo "💾 Recursos del sistema:"
    df -h / | tail -1 | awk '{print "  Disco: " $3 "/" $2 " (" $5 " usado)"}'
    free -h | grep Mem | awk '{print "  RAM: " $3 "/" $2 " (" int($3/$2*100) "% usado)"}'
    
    echo
    echo "📂 Proyectos:"
    local python_projects=$(find "${DEV_PROJECTS:-$HOME/Development/projects}/python" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l)
    local nodejs_projects=$(find "${DEV_PROJECTS:-$HOME/Development/projects}/nodejs" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l)
    echo "  Python: $python_projects proyectos"
    echo "  Node.js: $nodejs_projects proyectos"
    
    # Mostrar estado de servicios específicos si existen
    if command -v dev-status &> /dev/null; then
        echo
        echo "🔧 Estado de contenedores de desarrollo:"
        dev-status
    fi
    
    echo
    echo "🛠️ Herramientas disponibles:"
    command -v python3 >/dev/null && echo "  ✅ Python $(python3 --version | cut -d' ' -f2)"
    command -v node >/dev/null && echo "  ✅ Node.js $(node --version)"
    command -v docker >/dev/null && echo "  ✅ Docker $(docker --version | cut -d' ' -f3 | cut -d',' -f1)"
    command -v code >/dev/null && echo "  ✅ VS Code"
    command -v git >/dev/null && echo "  ✅ Git $(git --version | cut -d' ' -f3)"
}

# Función para mostrar proyectos disponibles
listprojects() {
    echo "📂 Proyectos disponibles:"
    echo
    
    for lang in python nodejs java golang; do
        local lang_dir="${DEV_PROJECTS:-$HOME/Development/projects}/$lang"
        if [ -d "$lang_dir" ]; then
            local count=$(find "$lang_dir" -maxdepth 1 -type d | tail -n +2 | wc -l)
            if [ $count -gt 0 ]; then
                echo "🔸 $lang ($count proyectos):"
                find "$lang_dir" -maxdepth 1 -type d | tail -n +2 | sed 's|.*/||' | sed 's/^/    /'
                echo
            fi
        fi
    done
}

# Función para crear backup rápido
quickbackup() {
    local backup_name="${1:-projects}"
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local backup_file="${DEV_BACKUPS:-$HOME/Development/backups}/${backup_name}-${timestamp}.tar.gz"
    
    mkdir -p "$(dirname "$backup_file")"
    
    dev_log "INFO" "Creando backup rápido..."
    
    if tar -czf "$backup_file" -C "${DEV_HOME:-$HOME/Development}" projects/; then
        dev_log "SUCCESS" "Backup creado: $backup_file"
        echo "Tamaño: $(du -h "$backup_file" | cut -f1)"
    else
        dev_log "ERROR" "Error creando backup"
    fi
}

# Función para ver logs de desarrollo
devlogs() {
    local service="$1"
    
    if [ -z "$service" ]; then
        echo "Logs disponibles:"
        echo "  devlogs system    - Logs del sistema de desarrollo"
        echo "  devlogs docker    - Logs de Docker"
        echo "  devlogs python    - Logs de contenedor Python"
        echo "  devlogs nodejs    - Logs de contenedor Node.js"
        return 0
    fi
    
    case "$service" in
        "system")
            if [ -f "${DEV_LOG_FILE:-$HOME/Development/logs/development.log}" ]; then
                tail -f "${DEV_LOG_FILE:-$HOME/Development/logs/development.log}"
            else
                echo "Log del sistema no encontrado"
            fi
            ;;
        "docker")
            journalctl -u docker -f
            ;;
        *)
            if command -v dev &> /dev/null; then
                dev logs "$service"
            else
                docker logs -f "dev-$service" 2>/dev/null || echo "Contenedor '$service' no encontrado"
            fi
            ;;
    esac
}

# Función para conectar rápidamente a diferentes entornos
devconnect() {
    local env="$1"
    
    if [ -z "$env" ]; then
        echo "Entornos disponibles:"
        echo "  devconnect python    - Conectar a Python"
        echo "  devconnect nodejs    - Conectar a Node.js"
        echo "  devconnect java      - Conectar a Java"
        echo "  devconnect golang    - Conectar a Go"
        return 0
    fi
    
    case "$env" in
        "python"|"py")
            if command -v py-dev &> /dev/null; then
                py-dev
            else
                docker exec -it python-dev-env bash
            fi
            ;;
        "nodejs"|"node")
            if command -v node-dev &> /dev/null; then
                node-dev
            else
                docker exec -it nodejs-dev-env bash
            fi
            ;;
        "java")
            if command -v java-dev &> /dev/null; then
                java-dev
            else
                docker exec -it java-dev-env bash
            fi
            ;;
        "golang"|"go")
            if command -v go-dev &> /dev/null; then
                go-dev
            else
                docker exec -it golang-dev-env bash
            fi
            ;;
        *)
            dev_log "ERROR" "Entorno '$env' no reconocido"
            ;;
    esac
}

EOF

# Agregar funciones al bashrc y zshrc
if ! grep -q "source ~/.dev_functions" ~/.bashrc; then
    echo "source ~/.dev_functions" >> ~/.bashrc
fi

if [ -f ~/.zshrc ] && ! grep -q "source ~/.dev_functions" ~/.zshrc; then
    echo "source ~/.dev_functions" >> ~/.zshrc
fi

dev_log "SUCCESS" "Funciones de desarrollo integradas configuradas"

############################################
# INTEGRACIÓN CON OTROS SCRIPTS
############################################

dev_log "INFO" "Configurando integración con otros scripts..."

# Crear script de verificación específico para herramientas
cat > ~/.local/bin/dev-tools-check << 'EOF'
#!/bin/bash
source ~/.dev_config 2>/dev/null || true
source ~/.dev_logger 2>/dev/null || true

echo "🔍 Verificación de Herramientas de Desarrollo"
echo "=============================================="

# Verificar Python
if command -v python3 &> /dev/null; then
    echo "✅ Python: $(python3 --version)"
    if [ -f "$DEV_HOME/python-envs/base/bin/python" ]; then
        echo "   📦 Entorno base: Disponible"
    else
        echo "   ⚠️  Entorno base: No encontrado"
    fi
else
    echo "❌ Python: No instalado"
fi

# Verificar Node.js
if command -v node &> /dev/null; then
    echo "✅ Node.js: $(node --version)"
    echo "   📦 npm: $(npm --version)"
    if command -v yarn &> /dev/null; then
        echo "   📦 yarn: $(yarn --version)"
    fi
else
    echo "❌ Node.js: No instalado"
fi

# Verificar VS Code
if command -v code &> /dev/null; then
    echo "✅ VS Code: Instalado"
    local extensions=$(code --list-extensions | wc -l)
    echo "   📦 Extensiones: $extensions instaladas"
else
    echo "❌ VS Code: No instalado"
fi

# Verificar Git
if command -v git &> /dev/null; then
    echo "✅ Git: $(git --version | cut -d' ' -f3)"
    local user_name=$(git config --global user.name 2>/dev/null || echo "No configurado")
    local user_email=$(git config --global user.email 2>/dev/null || echo "No configurado")
    echo "   👤 Usuario: $user_name <$user_email>"
else
    echo "❌ Git: No instalado"
fi

# Verificar Docker
if command -v docker &> /dev/null; then
    echo "✅ Docker: $(docker --version | cut -d' ' -f3 | cut -d',' -f1)"
    if groups $USER | grep -q docker; then
        echo "   👥 Usuario en grupo docker: Sí"
    else
        echo "   ⚠️  Usuario en grupo docker: No (reiniciar sesión)"
    fi
else
    echo "❌ Docker: No instalado"
fi

# Verificar estructura de directorios
echo
echo "📁 Estructura de directorios:"
for dir in "$DEV_HOME" "$DEV_PROJECTS" "$DEV_TOOLS" "$DEV_LOGS"; do
    if [ -d "$dir" ]; then
        echo "   ✅ $dir"
    else
        echo "   ❌ $dir (no existe)"
    fi
done

echo
echo "🎯 Estado general: $([ -f ~/.dev_config ] && echo "Configuración integrada ✅" || echo "Configuración básica ⚠️ ")"
EOF

chmod +x ~/.local/bin/dev-tools-check

# Crear script para actualizar herramientas integrado
cat > ~/.local/bin/update-dev-tools-integrated << 'EOF'
#!/bin/bash
source ~/.dev_config 2>/dev/null || true
source ~/.dev_logger 2>/dev/null || true

dev_log "INFO" "Iniciando actualización integrada de herramientas..."

# Sistema base
dev_log "INFO" "Actualizando sistema base..."
sudo apt update && sudo apt upgrade -y

# Flatpaks
if command -v flatpak &> /dev/null; then
    dev_log "INFO" "Actualizando Flatpaks..."
    flatpak update -y
fi

# NPM packages globales
if command -v npm &> /dev/null; then
    dev_log "INFO" "Actualizando NPM packages globales..."
    npm update -g
fi

# Python en entorno base
if [ -f "$DEV_HOME/python-envs/base/bin/activate" ]; then
    dev_log "INFO" "Actualizando Python packages..."
    source "$DEV_HOME/python-envs/base/bin/activate"
    pip install --upgrade pip
    pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U 2>/dev/null || true
    deactivate
fi

# Docker images
if command -v docker &> /dev/null; then
    dev_log "INFO" "Actualizando imágenes Docker..."
    docker image prune -f
    # Actualizar imágenes principales
    for image in postgres:15 redis:7-alpine mongo:7 node:18-alpine python:3.11-slim openjdk:17-alpine golang:1.21-alpine; do
        docker pull $image 2>/dev/null || true
    done
fi

# VS Code extensions
if command -v code &> /dev/null; then
    dev_log "INFO" "Actualizando extensiones de VS Code..."
    code --update-extensions
fi

dev_log "SUCCESS" "Actualización integrada completada"
EOF

chmod +x ~/.local/bin/update-dev-tools-integrated

# Crear enlaces simbólicos para comandos más cortos
ln -sf ~/.local/bin/dev-tools-check ~/.local/bin/tools-check
ln -sf ~/.local/bin/update-dev-tools-integrated ~/.local/bin/tools-update

dev_log "SUCCESS" "Integración con otros scripts configurada"

############################################
# CONFIGURAR HERRAMIENTAS DE KUBERNETES
############################################

echo "☸️ Configurando herramientas Kubernetes..."

# Instalar kubectx y kubens para cambiar contextos fácilmente
cd /tmp
git clone https://github.com/ahmetb/kubectx.git
sudo cp kubectx/kubectx /usr/local/bin/
sudo cp kubectx/kubens /usr/local/bin/
sudo chmod +x /usr/local/bin/kubectx /usr/local/bin/kubens
rm -rf kubectx

# Crear alias útiles para kubectl
mkdir -p ~/.kube

cat > ~/.kube/aliases << 'EOF'
# Kubernetes aliases
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kgn='kubectl get nodes'
alias kde='kubectl describe'
alias kdel='kubectl delete'
alias kaf='kubectl apply -f'
alias kdf='kubectl delete -f'
alias klogs='kubectl logs -f'
alias kexec='kubectl exec -it'
EOF

echo "source ~/.kube/aliases" >> ~/.bashrc
if [ -f ~/.zshrc ]; then
    echo "source ~/.kube/aliases" >> ~/.zshrc
fi

echo "✅ Herramientas Kubernetes configuradas"

############################################
# CONFIGURAR BASES DE DATOS LOCALES
############################################

echo "🗄️ Configurando bases de datos locales..."

# Configurar PostgreSQL
if systemctl list-unit-files | grep -q postgresql; then
    sudo systemctl start postgresql
    
    # Crear usuario de desarrollo
    sudo -u postgres createuser -d -r -s developer 2>/dev/null || true
    sudo -u postgres psql -c "ALTER USER developer PASSWORD 'devpass';" 2>/dev/null || true
    
    # Crear base de datos de desarrollo
    sudo -u postgres createdb -O developer devdb 2>/dev/null || true
    
    echo "✅ PostgreSQL configurado (usuario: developer, pass: devpass, db: devdb)"
fi

# Configurar Redis (ya debería estar funcionando)
if systemctl is-active --quiet redis-server; then
    echo "✅ Redis ya está configurado y funcionando"
fi

############################################
# CREAR SCRIPTS ÚTILES
############################################

echo "📝 Creando scripts útiles..."

mkdir -p ~/.local/bin

# Script para backup rápido de proyectos
cat > ~/.local/bin/backup-projects << 'EOF'
#!/bin/bash
# Backup rápido de proyectos de desarrollo

BACKUP_DIR="$HOME/Backups/projects"
PROJECTS_DIR="$HOME/Development/projects"

mkdir -p "$BACKUP_DIR"

# Crear backup con fecha
BACKUP_NAME="projects-backup-$(date +%Y%m%d-%H%M%S).tar.gz"

echo "Creando backup de proyectos..."
tar -czf "$BACKUP_DIR/$BACKUP_NAME" -C "$HOME/Development" projects/

echo "✅ Backup creado: $BACKUP_DIR/$BACKUP_NAME"
echo "Tamaño: $(du -h "$BACKUP_DIR/$BACKUP_NAME" | cut -f1)"
EOF

# Script para actualizar todas las herramientas
cat > ~/.local/bin/update-dev-tools << 'EOF'
#!/bin/bash
# Actualizar todas las herramientas de desarrollo

echo "🔄 Actualizando herramientas de desarrollo..."

# Sistema base
echo "📦 Actualizando sistema..."
sudo apt update && sudo apt upgrade -y

# Flatpaks
echo "📱 Actualizando Flatpaks..."
flatpak update -y

# NPM packages globales
echo "📦 Actualizando NPM packages globales..."
npm update -g

# Python en entorno base
echo "🐍 Actualizando Python packages..."
source ~/Development/python-envs/base/bin/activate
pip install --upgrade pip
pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip install -U
deactivate

# Docker images
echo "🐳 Actualizando imágenes Docker..."
docker image prune -f
docker pull postgres:15
docker pull redis:7-alpine
docker pull mongo:6

echo "✅ Todas las herramientas actualizadas"
EOF

############################################
# MENSAJE FINAL INTEGRADO
############################################

echo
echo "=========================================="
echo "🎉 HERRAMIENTAS DE DESARROLLO CONFIGURADAS"
echo "=========================================="
echo
echo "� SISTEMA COMPLETAMENTE INTEGRADO:"
echo "  • Logging centralizado en $DEV_LOGS/development.log"
echo "  • Configuración unificada en ~/.dev_config"
echo "  • Scripts de gestión automática"
echo "  • Integración completa entre todos los componentes"
echo
echo "📁 Estructura optimizada creada:"
echo "  • $DEV_HOME/python-envs/base (entorno Python integrado)"
echo "  • $DEV_HOME/containers/templates (plantillas Docker)"
echo "  • ~/.local/bin (scripts de gestión unificados)"
echo
echo "⚡ FUNCIONES AVANZADAS DISPONIBLES:"
echo "  • newpy <nombre> [tipo]     - Crear proyecto Python (web,api,data,cli)"
echo "  • newnode <nombre> [tipo]   - Crear proyecto Node.js (react,vue,express,nextjs)"
echo "  • opencode [nombre]         - Abrir proyecto con detección automática"
echo "  • devup/devdown            - Gestión inteligente de servicios"
echo "  • devstatus                - Estado completo con recursos"
echo "  • devclean                 - Limpieza avanzada sistema completo"
echo "  • listprojects             - Ver todos los proyectos disponibles"
echo "  • quickbackup [nombre]     - Backup rápido con timestamp"
echo "  • devlogs [servicio]       - Logs centralizados"
echo "  • devconnect <entorno>     - Conexión rápida a contenedores"
echo
echo "🛠️ SCRIPTS DE GESTIÓN INTEGRADOS:"
echo "  • dev-tools-check          - Verificar herramientas específicas"
echo "  • tools-check              - Alias para verificación rápida"
echo "  • update-dev-tools-integrated - Actualización completa integrada"
echo "  • tools-update             - Alias para actualización rápida"
echo "  • activate-py-base         - Activar entorno Python base"
echo "  • node-project             - Gestión proyectos Node.js"
echo
echo "🎯 CONFIGURACIÓN VS CODE:"
echo "  • Remote Containers configurado para desarrollo"
echo "  • Extensiones completas instaladas"
echo "  • Tasks predefinidas para conectar a contenedores"
echo "  • Settings optimizados para desarrollo containerizado"
echo
echo "🔧 VERIFICACIÓN DEL SISTEMA:"
echo "  tools-check                - Verificar todas las herramientas"
echo "  dev-check                  - Verificar sistema completo"
echo "  devstatus                  - Estado en tiempo real"
echo
echo "🔄 PARA APLICAR TODOS LOS CAMBIOS:"
echo "  source ~/.bashrc"
echo "  # o reiniciar terminal"
echo
echo "🚀 PRÓXIMOS PASOS RECOMENDADOS:"
echo "  1. Ejecutar: tools-check"
echo "  2. Si todo OK: dev-setup-complete"
echo "  3. Iniciar desarrollo: dev-start"
echo "  4. Crear primer proyecto: newpy mi-proyecto api"
echo
echo "✨ ¡Sistema de desarrollo COMPLETAMENTE INTEGRADO listo!"
echo "========================================"

# Log final en el sistema
dev_log "SUCCESS" "Configuración post-instalación completada exitosamente"
