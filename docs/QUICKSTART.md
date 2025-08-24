# ⚡ Instalación Rápida - Sistema Integrado DWM-Qtile v2.0

## 🚀 **Nueva Instalación Integrada en 5 Minutos**

> � **NOVEDAD**: Ahora con **script maestro coordinador** que gestiona toda la instalación y configuración de manera inteligente.

### **1️⃣ Instalación Automática Completa (Recomendada)**

```bash
# Clonar o descargar el proyecto  
cd /path/to/dwm-qtile-project

# ⚡ INSTALACIÓN COMPLETA CON SCRIPT MAESTRO
chmod +x scripts/master-dev.sh
./scripts/master-dev.sh install all

# Si requiere reinicio de sesión:
# 1. Reinicia tu sesión completamente
# 2. Regresa al directorio  
# 3. Ejecuta: ./scripts/master-dev.sh install continue
```

### **2️⃣ Verificación Rápida**

```bash
# Verificar que todo esté instalado correctamente
./scripts/master-dev.sh check

# Ver estado completo del sistema
./scripts/master-dev.sh status

# Si hay problemas, reparar automáticamente  
./scripts/master-dev.sh repair
```

### **3️⃣ Iniciar Servicios y Desarrollo**

```bash  
# Iniciar todos los servicios de desarrollo
./scripts/master-dev.sh start all

# Ver estado de todos los servicios
./scripts/master-dev.sh status

# Ver logs del sistema (opcional)
./scripts/master-dev.sh logs system
```

## 🚀 **Primeros Pasos con Funciones Integradas**

### **🐍 Desarrollo Python Inteligente**

```bash
# Crear proyecto Python con template inteligente
newpy mi_proyecto              # Proyecto básico
newpy mi_api api              # API con FastAPI/Flask  
newpy mi_web web              # Aplicación web Django
newpy mi_tool cli             # Herramienta CLI
newpy mi_ml data              # Data Science/ML

# Abrir automáticamente en VS Code optimizado
opencode mi_proyecto python
```

### **🟢 Desarrollo Node.js con Templates**

```bash
# Crear proyecto Node.js con frameworks
newnode mi_app                # Proyecto básico
newnode mi_app express        # Aplicación Express
newnode mi_app react          # Aplicación React  
newnode mi_app next           # Aplicación Next.js
newnode mi_app vue            # Aplicación Vue.js

# Abrir con configuración Node.js
opencode mi_app nodejs
```

### **🔧 Gestión Automática de Servicios**

```bash
# 1. Conectar a entorno Python
py-dev

# 2. Crear proyecto de prueba
cd /workspace/projects
mkdir hello-python && cd hello-python

# 3. Crear app simple
cat > app.py << 'EOF'
from fastapi import FastAPI
import psycopg2

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "¡Hola desde contenedor Python!", "status": "working"}

@app.get("/db")
async def test_db():
    try:
        conn = psycopg2.connect(
            host="postgres-db",
            database="devdb",
            user="developer", 
            password="devpass"
        )
        cur = conn.cursor()
        cur.execute("SELECT 'PostgreSQL conectado!' as message;")
        result = cur.fetchone()
        conn.close()
        return {"database": result[0]}
    except Exception as e:
        return {"database": f"Error: {str(e)}"}
EOF

# 4. Instalar dependencias y ejecutar
pip install fastapi uvicorn psycopg2-binary
uvicorn app:app --host 0.0.0.0 --port 8000 --reload

# 5. Probar desde HOST
# Abrir: http://localhost:8000
# Abrir: http://localhost:8000/db
```

### **Desarrollo Node.js**

```bash
# 1. Conectar a entorno Node.js
node-dev

# 2. Crear proyecto React
cd /workspace/projects
npx create-react-app hello-react
cd hello-react

# 3. Iniciar desarrollo
npm start

# 4. Acceder desde HOST
# Abrir: http://localhost:3000
```

### **Conectar IDE Local**

**VS Code:**
```bash
# 1. Instalar extensión Remote Containers
code --install-extension ms-vscode-remote.remote-containers

# 2. Abrir VS Code
code .

# 3. Conectar a contenedor:
# Ctrl+Shift+P → "Remote-Containers: Attach to Running Container"
# Seleccionar: python-dev-env
```

## 🗄️ **Acceso a Bases de Datos**

### **Desde Aplicaciones**

```python
# Python - PostgreSQL
import psycopg2
conn = psycopg2.connect(
    host="postgres-db",      # Nombre del contenedor
    database="devdb",
    user="developer",
    password="devpass"
)
```

```javascript
// Node.js - PostgreSQL
const { Pool } = require('pg');
const pool = new Pool({
  host: 'postgres-db',
  database: 'devdb', 
  user: 'developer',
  password: 'devpass',
  port: 5432,
});
```

### **Desde HOST (herramientas gráficas)**

```bash
# Configurar herramienta gráfica (ej: DBeaver)
Host: localhost
Port: 5432
Database: devdb
User: developer
Password: devpass
```

**Web Interfaces:**
- **Adminer**: http://localhost:8080 (PostgreSQL/MySQL)
- **Mongo Express**: http://localhost:8081 (MongoDB)  
- **Redis Commander**: http://localhost:8082 (Redis)

## 🔧 **Comandos Útiles**

### **Gestión Diaria**

```bash
# === AL INICIAR EL DÍA ===
dev-status                    # Ver estado
dev-start                     # Iniciar entornos necesarios

# === DURANTE DESARROLLO ===
py-dev                        # Trabajar en Python
node-dev                      # Trabajar en Node.js
dev logs python              # Ver logs si hay problemas

# === AL FINALIZAR EL DÍA ===
dev-stop                      # Parar todos los servicios
# o
dev stop python              # Parar solo Python si trabajas en múltiples
```

### **Comandos de Emergencia**

```bash
# Si algo no funciona
dev restart python           # Reiniciar servicio específico
dev cleanup                  # Limpiar contenedores problemáticos
docker system prune -f       # Limpiar caché Docker

# Si necesitas reinstalar
cd ~/Development/containers/python
docker-compose down
docker-compose up --build -d
```

## 📋 **Checklist de Verificación**

### **Después de la Instalación**

- [ ] Docker instalado y corriendo: `docker --version`
- [ ] Usuario en grupo docker: `groups $USER | grep docker`
- [ ] Contenedores creados: `dev-status`
- [ ] Red creada: `docker network ls | grep dev-network`
- [ ] Volúmenes creados: `docker volume ls`

### **Antes de Desarrollar**

- [ ] Servicios iniciados: `dev-status`
- [ ] Base de datos accesible: `psql -h localhost -U developer -d devdb -c "SELECT 1;"`
- [ ] Directorios de proyectos: `ls ~/Development/projects/`
- [ ] IDE configurado para conexión remota

### **Al Conectar IDE**

- [ ] VS Code conecta a contenedor: Remote indicator en esquina inferior izquierda
- [ ] Intérprete/SDK configurado correctamente en IDE
- [ ] Terminal del IDE muestra prompt del contenedor
- [ ] Extensiones de lenguaje instaladas en contenedor

## 🆘 **Obtener Ayuda**

```bash
# Manual de comandos
dev help

# Comandos disponibles
dev help commands

# Estado detallado
dev-status --verbose

# Logs detallados
dev logs --all
```

**🎉 ¡Listo para desarrollar con entornos profesionales containerizados!**

---
> **Nota**: Para la guía completa y casos de uso avanzados, consultar `README_CONTAINERS.md`
