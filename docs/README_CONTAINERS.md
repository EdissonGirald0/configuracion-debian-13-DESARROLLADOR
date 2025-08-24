# 🐳 Guía Completa: Entornos de Desarrollo Containerizados

## 📋 **Introducción**

Esta configuración utiliza una arquitectura **híbrida** donde:
- **IDEs y editores** se ejecutan en el **HOST** (tu máquina local)
- **Entornos de desarrollo** se ejecutan en **contenedores Docker independientes**
- Los **IDEs se conectan remotamente** a los contenedores para desarrollo

### 🎯 **Ventajas de esta Arquitectura**

✅ **Aislamiento completo**: Cada entorno está completamente separado  
✅ **Sin contaminar el HOST**: Sistema limpio y organizado  
✅ **Fácil gestión**: Encender/apagar entornos según necesidad  
✅ **Reproducible**: Mismo entorno en cualquier máquina  
✅ **Escalable**: Agregar nuevos entornos fácilmente  
✅ **Interconectados**: Los contenedores pueden comunicarse entre sí  

---

## 🚀 **Instalación Inicial**

### **Paso 1: Instalar el Sistema Base**

```bash
# Ejecutar instalación principal
chmod +x 01-install-developer.sh
./01-install-developer.sh

# IMPORTANTE: Reiniciar sesión después de la instalación
# para que el usuario pueda usar Docker sin sudo
```

### **Paso 2: Configurar Entornos Containerizados**

```bash
# Opción 1: Configurar TODOS los entornos
dev-setup all

# Opción 2: Configurar entornos específicos
dev-setup python    # Solo Python
dev-setup nodejs    # Solo Node.js  
dev-setup java      # Solo Java
dev-setup golang    # Solo Go
dev-setup databases # Solo bases de datos
dev-setup tools     # Solo herramientas
```

### **Paso 3: Iniciar Entornos**

```bash
# Iniciar todos los entornos
dev-start

# O iniciar servicios específicos
dev start python
dev start databases
dev start tools
```

---

## 🏗️ **Arquitectura del Sistema**

### **Estructura de Directorios**

```
~/Development/
├── projects/                    # PROYECTOS (compartidos con contenedores)
│   ├── python/                 # Proyectos Python
│   ├── nodejs/                 # Proyectos Node.js
│   ├── java/                   # Proyectos Java
│   ├── golang/                 # Proyectos Go
│   └── shared/                 # Archivos compartidos entre entornos
│
├── containers/                 # CONFIGURACIONES DE CONTENEDORES
│   ├── python/                 # Dockerfile y docker-compose para Python
│   │   ├── Dockerfile
│   │   └── docker-compose.yml
│   ├── nodejs/                 # Dockerfile y docker-compose para Node.js
│   ├── java/                   # Dockerfile y docker-compose para Java  
│   ├── golang/                 # Dockerfile y docker-compose para Go
│   ├── databases/              # Stack completo de bases de datos
│   │   ├── docker-compose.yml
│   │   └── init-scripts/
│   └── tools/                  # Herramientas adicionales
│       └── docker-compose.yml
```

### **Red de Desarrollo**

Todos los contenedores están conectados a una red común llamada **`dev-network`** con subnet `172.20.0.0/16`.

Esto permite que:
- Los contenedores se comuniquen entre sí por nombre de host
- El HOST puede acceder a todos los servicios por `localhost`
- Se pueden definir servicios interdependientes

---

## 🛠️ **Entornos Disponibles**

### **1. 🐍 Entorno Python**

**Contenido:**
- Python 3.11
- Poetry para gestión de dependencias
- Frameworks: Django, Flask, FastAPI
- Data Science: pandas, numpy, matplotlib, jupyter
- Testing: pytest, pytest-cov
- Quality: black, flake8, mypy
- Databases: psycopg2, pymongo, redis, sqlalchemy

**Puertos expuestos:**
- `8000`: Django/FastAPI
- `5000`: Flask  
- `8888`: Jupyter Notebook

**Comandos:**
```bash
# Iniciar entorno Python
dev start python

# Conectar al contenedor
py-dev
# o
dev connect python-dev-env

# Ver logs
dev logs python

# Dentro del contenedor
cd /workspace/projects        # Tus proyectos Python
python --version             # Python 3.11
poetry --version             # Poetry disponible
jupyter notebook --ip=0.0.0.0 --port=8888  # Jupyter
```

### **2. 📦 Entorno Node.js**

**Contenido:**
- Node.js 18 LTS
- npm y Yarn
- Tools: nodemon, pm2, live-server
- Frameworks: create-react-app, @vue/cli, @angular/cli, @nestjs/cli
- TypeScript y ESLint

**Puertos expuestos:**
- `3000`: React/Next.js
- `4200`: Angular  
- `8080`: Vue.js

**Comandos:**
```bash
# Iniciar entorno Node.js
dev start nodejs

# Conectar al contenedor  
node-dev
# o
dev connect nodejs-dev-env

# Dentro del contenedor
cd /workspace/projects        # Tus proyectos Node.js
node --version               # Node.js 18
npm --version                # npm latest
npx create-react-app myapp   # Crear app React
```

### **3. ☕ Entorno Java**

**Contenido:**
- OpenJDK 17
- Maven 3.9.4
- Gradle 8.3

**Puertos expuestos:**
- `8080`: Spring Boot
- `8090`: Puerto adicional

**Comandos:**
```bash
# Iniciar entorno Java
dev start java

# Conectar al contenedor
java-dev

# Dentro del contenedor
cd /workspace/projects        # Tus proyectos Java
java --version               # OpenJDK 17
mvn --version                # Maven 3.9.4
gradle --version             # Gradle 8.3
```

### **4. 🐹 Entorno Go**

**Contenido:**
- Go 1.21
- Tools: air (hot reload), dlv (debugger), golangci-lint

**Puertos expuestos:**
- `8080`: Servidor Go
- `9000`: Puerto debug

**Comandos:**
```bash
# Iniciar entorno Go
dev start golang

# Conectar al contenedor
go-dev

# Dentro del contenedor
cd /workspace/projects        # Tus proyectos Go
go version                   # Go 1.21
go mod init myproject        # Inicializar proyecto
air                          # Hot reload
```

### **5. 🗄️ Stack de Bases de Datos**

**Servicios incluidos:**
- **PostgreSQL 15**: `localhost:5432` (user: developer, pass: devpass)
- **MySQL 8.0**: `localhost:3306` (user: developer, pass: devpass)  
- **Redis 7**: `localhost:6379`
- **MongoDB 7**: `localhost:27017` (user: admin, pass: devpass)

**Herramientas de administración:**
- **Adminer**: http://localhost:8080 (PostgreSQL/MySQL)
- **Mongo Express**: http://localhost:8081 (MongoDB)
- **Redis Commander**: http://localhost:8082 (Redis)

**Comandos:**
```bash
# Iniciar stack de bases de datos
start-db
# o  
dev start databases

# Conectar desde HOST
psql -h localhost -U developer -d devdb        # PostgreSQL
mysql -h localhost -u developer -p devdb       # MySQL
redis-cli -h localhost                         # Redis
mongo mongodb://admin:devpass@localhost:27017  # MongoDB
```

### **6. 🛠️ Stack de Herramientas**

**Servicios incluidos:**
- **Traefik**: http://localhost:8090 (reverse proxy y dashboard)
- **MailHog**: http://localhost:8025 (testing de emails)
- **MinIO**: http://localhost:9090 (S3-compatible storage)
- **Elasticsearch**: http://localhost:9200
- **Kibana**: http://localhost:5601 (visualización de logs)

**Comandos:**
```bash
# Iniciar herramientas
dev start tools

# Acceder a herramientas
open http://localhost:8025    # MailHog
open http://localhost:9090    # MinIO
open http://localhost:5601    # Kibana
```

---

## 🎯 **Workflows de Desarrollo**

### **Desarrollo Web Full-Stack**

```bash
# 1. Iniciar servicios necesarios
start-db                      # Bases de datos
dev start nodejs             # Frontend (React/Vue/Angular)
dev start python             # Backend (Django/FastAPI)

# 2. Crear proyecto frontend
node-dev
cd /workspace/projects
npx create-react-app frontend
cd frontend
npm start                     # http://localhost:3000

# 3. Crear proyecto backend (en otra terminal)
py-dev  
cd /workspace/projects
django-admin startproject backend
cd backend
python manage.py runserver 0.0.0.0:8000  # http://localhost:8000

# 4. Los servicios pueden comunicarse:
# Frontend llama al backend: http://python-dev:8000/api/
# Backend conecta a DB: postgresql://developer:devpass@postgres-db:5432/devdb
```

### **Desarrollo de APIs**

```bash
# 1. Iniciar backend y base de datos
start-db
dev start python             # o nodejs, java, golang

# 2. Desarrollar API
py-dev
cd /workspace/projects
mkdir my-api && cd my-api

# 3. Crear API con FastAPI
cat > main.py << 'EOF'
from fastapi import FastAPI
import psycopg2

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/db-test")
async def db_test():
    conn = psycopg2.connect(
        host="postgres-db",
        database="devdb", 
        user="developer",
        password="devpass"
    )
    cur = conn.cursor()
    cur.execute("SELECT version();")
    result = cur.fetchone()
    conn.close()
    return {"postgres_version": result[0]}
EOF

# 4. Ejecutar API
pip install fastapi uvicorn psycopg2-binary
uvicorn main:app --host 0.0.0.0 --port 8000 --reload

# 5. Probar API desde HOST
curl http://localhost:8000/
curl http://localhost:8000/db-test
```

### **Desarrollo con Microservicios**

```bash
# 1. Iniciar todos los servicios
dev-start

# 2. Crear servicios en diferentes lenguajes
# Servicio de usuarios en Python
py-dev
cd /workspace/projects
mkdir user-service && cd user-service
# ... desarrollar servicio

# Servicio de productos en Node.js  
node-dev
cd /workspace/projects
mkdir product-service && cd product-service
# ... desarrollar servicio

# Servicio de notificaciones en Go
go-dev
cd /workspace/projects  
mkdir notification-service && cd notification-service
# ... desarrollar servicio

# 3. Los servicios se comunican entre sí:
# user-service llama a: http://nodejs-dev:3000/products
# product-service llama a: http://golang-dev:8080/notify
# Todos conectan a: postgres-db:5432, redis-db:6379
```

---

## 🔧 **Conexión de IDEs Locales**

### **VS Code - Desarrollo Remoto**

1. **Instalar extensiones necesarias:**
```bash
code --install-extension ms-vscode-remote.remote-containers
code --install-extension ms-vscode-remote.remote-ssh
```

2. **Conectar a contenedor:**
- Comando: `Ctrl+Shift+P` → `Remote-Containers: Attach to Running Container`
- Seleccionar contenedor (ej: `python-dev-env`)
- VS Code abrirá conectado al contenedor

3. **Configurar workspace:**
```bash
# Dentro de VS Code conectado al contenedor
# Abrir carpeta: /workspace/projects
# Instalar extensiones Python/Node.js dentro del contenedor
```

### **PyCharm - Desarrollo Remoto**

1. **Configurar intérprete remoto:**
- File → Settings → Project → Python Interpreter
- Add Interpreter → Docker Compose
- Configuration file: `~/Development/containers/python/docker-compose.yml`
- Service: `python-dev`

2. **Configurar deployment:**
- Tools → Deployment → Configuration
- Add server: SFTP
- Host: localhost, Port: 22 (si SSH está habilitado en contenedor)
- O usar Docker Compose mapping

### **IntelliJ IDEA - Desarrollo Remoto**

1. **Configurar SDK remoto:**
- File → Project Structure → SDKs
- Add SDK → Docker Compose
- Seleccionar docker-compose.yml del servicio Java

2. **Run configurations:**
- Configurar para ejecutar dentro del contenedor
- Port mapping automático

---

## 📊 **Monitoreo y Gestión**

### **Ver Estado de Servicios**

```bash
# Estado completo
dev-status

# Resultado esperado:
# python          🟢 Running        Python Development  
# nodejs          🟢 Running        Node.js Development
# databases       🟢 Running        PostgreSQL, MySQL, Redis, MongoDB
# tools           🔴 Stopped        Traefik, MailHog, MinIO, Elasticsearch
```

### **Gestión de Servicios**

```bash
# Iniciar servicio específico
dev start python
dev start databases

# Parar servicio específico  
dev stop python
dev stop databases

# Reiniciar servicio
dev restart python

# Ver logs en tiempo real
dev logs python
dev logs databases

# Iniciar todo
dev-start

# Parar todo
dev-stop
```

### **Mantenimiento**

```bash
# Actualizar imágenes
dev update

# Limpiar contenedores no utilizados
dev cleanup

# Backup de bases de datos
dev backup

# Conectar a contenedor específico
dev connect python-dev-env
dev connect nodejs-dev-env
```

---

## 🗄️ **Gestión de Datos**

### **Persistencia de Datos**

Los datos se mantienen en **volúmenes Docker**:
- `postgres-data`: Datos PostgreSQL
- `mysql-data`: Datos MySQL  
- `redis-data`: Datos Redis
- `mongodb-data`: Datos MongoDB
- `python-venvs`: Entornos virtuales Python
- `nodejs-modules`: Cache npm

### **Backup y Restore**

```bash
# Backup automático
dev backup

# Backup manual de PostgreSQL
docker exec dev-postgres pg_dump -U developer devdb > backup.sql

# Restore PostgreSQL
docker exec -i dev-postgres psql -U developer devdb < backup.sql

# Backup manual de MongoDB
docker exec dev-mongodb mongodump --uri="mongodb://admin:devpass@localhost:27017/devdb" --out=/tmp/backup
```

### **Acceso a Datos desde HOST**

```bash
# PostgreSQL desde HOST
psql -h localhost -p 5432 -U developer -d devdb

# MySQL desde HOST  
mysql -h localhost -P 3306 -u developer -p devdb

# Redis desde HOST
redis-cli -h localhost -p 6379

# MongoDB desde HOST
mongo mongodb://admin:devpass@localhost:27017/devdb
```

---

## 🔐 **Configuración de Credenciales**

### **Git Configuration**

Los contenedores heredan la configuración Git del HOST:
```bash
# En el HOST
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"

# Se monta automáticamente en contenedores como:
# ~/.gitconfig:/home/developer/.gitconfig:ro
```

### **SSH Keys**

```bash
# Las claves SSH se montan automáticamente:
# ~/.ssh:/home/developer/.ssh:ro

# Generar claves SSH si no existen
ssh-keygen -t rsa -b 4096 -C "tu@email.com"

# Agregar a GitHub/GitLab
cat ~/.ssh/id_rsa.pub
```

### **Database Credentials**

**PostgreSQL:**
- Host: `localhost:5432`
- Database: `devdb`  
- User: `developer`
- Password: `devpass`

**MySQL:**
- Host: `localhost:3306`
- Database: `devdb`
- User: `developer` 
- Password: `devpass`

**MongoDB:**
- Host: `localhost:27017`
- Database: `devdb`
- User: `admin`
- Password: `devpass`

**Redis:**
- Host: `localhost:6379`
- No authentication

---

## 🐛 **Solución de Problemas**

### **Docker no está corriendo**

```bash
# Iniciar Docker
sudo systemctl start docker
sudo systemctl enable docker

# Verificar estado
docker info
```

### **Contenedor no inicia**

```bash
# Ver logs del servicio
dev logs python

# Reconstruir contenedor
cd ~/Development/containers/python
docker-compose down
docker-compose build --no-cache
docker-compose up -d
```

### **Puerto ya está en uso**

```bash
# Ver qué proceso usa el puerto
sudo lsof -i :5432

# Matar proceso si es necesario
sudo kill -9 <PID>

# O cambiar puerto en docker-compose.yml
```

### **Problemas de permisos**

```bash
# Verificar que el usuario esté en grupo docker
groups $USER

# Si no está, agregar y reiniciar sesión
sudo usermod -aG docker $USER
# LOGOUT y LOGIN de nuevo
```

### **Contenedor no puede acceder a archivos**

```bash
# Verificar permisos en directorio de proyectos
ls -la ~/Development/projects/

# Cambiar permisos si es necesario
chmod -R 755 ~/Development/projects/
```

### **Base de datos no conecta**

```bash
# Verificar que el servicio esté corriendo
dev-status

# Verificar conectividad desde HOST
psql -h localhost -U developer -d devdb -c "SELECT 1;"

# Ver logs de la base de datos
docker logs dev-postgres
```

---

## 📈 **Optimización y Performance**

### **Recursos de Contenedores**

Para limitar recursos, editar `docker-compose.yml`:
```yaml
services:
  python-dev:
    # ...
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 4G
        reservations:
          memory: 1G
```

### **Cache y Performance**

```bash
# Limpiar cache Docker periódicamente
docker system prune -f

# Limpiar volúmenes no utilizados
docker volume prune -f

# Ver uso de espacio
docker system df
```

### **Hot Reload en Desarrollo**

Los proyectos están montados como volúmenes, por lo que los cambios en el HOST se reflejan inmediatamente en los contenedores:

```bash
# Ejemplo con Node.js
node-dev
cd /workspace/projects
npx create-react-app myapp
cd myapp
npm start  # Hot reload automático
```

---

## 🎓 **Casos de Uso Avanzados**

### **Testing Cross-Platform**

```bash
# Desarrollar en Python, probar en diferentes entornos
py-dev
# ... desarrollar aplicación

# Probar en Node.js (API compatibility)
node-dev  
# ... hacer requests a servicio Python

# Probar integración con bases de datos
# Todos los contenedores acceden a las mismas BDs
```

### **Simulación de Microservicios**

```bash
# Cada servicio en su contenedor
dev-start

# API Gateway en Node.js
node-dev
# Servicio auth en Python
py-dev  
# Servicio processing en Go
go-dev
# Servicio notifications en Java
java-dev

# Todos intercomunicados vía dev-network
```

### **CI/CD Local**

```bash
# Simular pipeline de CI/CD
# 1. Desarrollo en contenedor
py-dev
# ... desarrollar y commit

# 2. Testing automático
cd ~/Development/containers/python
docker-compose exec python-dev pytest

# 3. Build en otro contenedor
docker build -t myapp:latest .

# 4. Deploy a staging container
docker run -d --name staging --network dev-network myapp:latest
```

---

## 🔄 **Migración y Actualización**

### **Actualizar Entornos**

```bash
# Actualizar imágenes base
dev update

# Reconstruir contenedores con nuevas herramientas
cd ~/Development/containers/python
# Editar Dockerfile
docker-compose build --no-cache
docker-compose up -d
```

### **Migrar Proyectos Existentes**

```bash
# Mover proyecto existente a estructura containerizada
mv ~/mi-proyecto-python ~/Development/projects/python/

# Conectar a contenedor y continuar desarrollo
py-dev
cd /workspace/projects/mi-proyecto-python
# ... continuar desarrollo
```

### **Backup Completo**

```bash
# Backup de proyectos
tar -czf ~/backups/projects-$(date +%Y%m%d).tar.gz ~/Development/projects/

# Backup de configuraciones
tar -czf ~/backups/containers-$(date +%Y%m%d).tar.gz ~/Development/containers/

# Backup de volúmenes
dev backup
```

---

## 📚 **Recursos Adicionales**

### **Documentación Oficial**
- [Docker Compose](https://docs.docker.com/compose/)
- [Docker Networks](https://docs.docker.com/network/)
- [VS Code Remote Development](https://code.visualstudio.com/docs/remote/containers)

### **Comandos de Referencia Rápida**

```bash
# === GESTIÓN BÁSICA ===
dev-status                    # Ver estado
dev-start                     # Iniciar todo  
dev-stop                      # Parar todo
dev start <servicio>          # Iniciar servicio
dev connect <contenedor>      # Conectar a contenedor

# === SERVICIOS ===
start-db                      # Bases de datos
dev start python             # Python
dev start nodejs             # Node.js
dev start java               # Java
dev start golang             # Go
dev start tools              # Herramientas

# === CONEXIONES RÁPIDAS ===
py-dev                        # Python container
node-dev                      # Node.js container  
java-dev                      # Java container
go-dev                        # Go container

# === DIRECTORIOS ===
dev-dir                       # ~/Development
projects                      # ~/Development/projects
containers                    # ~/Development/containers

# === MANTENIMIENTO ===
dev cleanup                   # Limpiar contenedores
dev update                    # Actualizar imágenes
dev backup                    # Backup de datos
```

---

**¡Con esta configuración tienes un entorno de desarrollo profesional, escalable y completamente containerizado! 🚀**
