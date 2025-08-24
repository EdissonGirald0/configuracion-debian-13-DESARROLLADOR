# 🔧 Manual de Troubleshooting - Entornos Containerizados

## 🚨 **Problemas Comunes y Soluciones**

### **1. Docker y Permisos**

#### **❌ Error: "Permission denied while trying to connect to Docker daemon"**

**Síntomas:**
```
Got permission denied while trying to connect to the Docker daemon socket
```

**Solución:**
```bash
# Verificar grupo docker
groups $USER

# Si no aparece 'docker', agregarlo
sudo usermod -aG docker $USER

# OBLIGATORIO: Cerrar sesión y volver a entrar
logout
# o reiniciar sistema
sudo reboot

# Verificar después de reiniciar
docker run hello-world
```

#### **❌ Error: "Cannot connect to the Docker daemon"**

**Síntomas:**
```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock
```

**Solución:**
```bash
# Iniciar Docker
sudo systemctl start docker
sudo systemctl enable docker

# Verificar estado
sudo systemctl status docker
docker info
```

### **2. Contenedores y Servicios**

#### **❌ Error: "Port already in use"**

**Síntomas:**
```
Error starting userland proxy: listen tcp4 0.0.0.0:5432: bind: address already in use
```

**Solución:**
```bash
# 1. Identificar proceso que usa el puerto
sudo lsof -i :5432

# 2. Ver detalles del proceso
ps aux | grep <PID>

# 3. Opciones:
# A) Matar proceso si es seguro
sudo kill -9 <PID>

# B) Cambiar puerto en docker-compose.yml
cd ~/Development/containers/databases
nano docker-compose.yml
# Cambiar "5432:5432" por "5433:5432"

# 4. Reiniciar servicio
docker-compose down
docker-compose up -d
```

#### **❌ Error: "Container already exists"**

**Síntomas:**
```
Container name "/dev-postgres" is already in use
```

**Solución:**
```bash
# 1. Ver contenedores existentes
docker ps -a | grep dev-

# 2. Remover contenedor problemático
docker rm -f dev-postgres

# 3. Reiniciar servicio
dev start databases
```

#### **❌ Error: "No space left on device"**

**Síntomas:**
```
Error: No space left on device
```

**Solución:**
```bash
# 1. Ver uso de espacio Docker
docker system df

# 2. Limpiar caché y contenedores no utilizados
docker system prune -af

# 3. Limpiar volúmenes no utilizados (¡CUIDADO!)
docker volume prune -f

# 4. Limpiar imágenes no utilizadas
docker image prune -af

# 5. Ver espacio disponible
df -h
```

### **3. Red y Conectividad**

#### **❌ Error: "Connection refused" entre contenedores**

**Síntomas:**
```
psycopg2.OperationalError: connection to server at "postgres-db" (172.20.0.3), port 5432 failed
```

**Solución:**
```bash
# 1. Verificar que la red existe
docker network ls | grep dev-network

# 2. Verificar que contenedores están en la red
docker network inspect dev-network

# 3. Si la red no existe, crearla
docker network create --driver bridge --subnet=172.20.0.0/16 dev-network

# 4. Verificar conectividad entre contenedores
docker exec python-dev-env ping postgres-db
```

#### **❌ Error: "Name resolution failure"**

**Síntomas:**
```
Could not resolve hostname: postgres-db
```

**Solución:**
```bash
# 1. Verificar que todos los servicios están en la misma red
docker-compose ps

# 2. Verificar configuración de red en docker-compose.yml
grep -A 5 "networks:" ~/Development/containers/*/docker-compose.yml

# 3. Reconstruir servicios
dev stop databases
dev start databases
```

### **4. Performance y Recursos**

#### **❌ Error: "Container is running but extremely slow"**

**Síntomas:**
- Comandos tardan mucho tiempo
- IDE responde lentamente

**Solución:**
```bash
# 1. Verificar recursos del sistema
htop

# 2. Ver uso de memoria Docker
docker stats

# 3. Limitar recursos de contenedores (editar docker-compose.yml)
cd ~/Development/containers/python
nano docker-compose.yml

# Agregar:
# deploy:
#   resources:
#     limits:
#       cpus: '1.0'
#       memory: 2G

# 4. Reiniciar servicio
docker-compose down
docker-compose up -d
```

#### **❌ Error: "Out of memory"**

**Síntomas:**
```
Container killed due to out of memory
```

**Solución:**
```bash
# 1. Ver memoria disponible
free -h

# 2. Parar servicios no esenciales
dev stop tools
dev stop java  # Si no lo estás usando

# 3. Aumentar swap si es necesario
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# 4. Hacer swap permanente
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

### **5. Desarrollo y IDEs**

#### **❌ Error: "VS Code no puede conectar al contenedor"**

**Síntomas:**
- VS Code no muestra contenedores disponibles
- Error al intentar conexión remota

**Solución:**
```bash
# 1. Verificar que contenedor está corriendo
docker ps | grep dev-env

# 2. Instalar/reinstalar extensión
code --install-extension ms-vscode-remote.remote-containers

# 3. Verificar Docker desde VS Code
# Ctrl+Shift+P → "Remote-Containers: Rebuild Container"

# 4. Si persiste, conectar manualmente
dev connect python-dev-env
```

#### **❌ Error: "File changes not reflecting in container"**

**Síntomas:**
- Editas archivo en HOST pero no se ve en contenedor
- Hot reload no funciona

**Solución:**
```bash
# 1. Verificar montaje de volúmenes
docker inspect python-dev-env | grep -A 10 "Mounts"

# 2. Verificar permisos
ls -la ~/Development/projects/

# 3. Cambiar permisos si es necesario
chmod -R 755 ~/Development/projects/

# 4. Reiniciar contenedor
dev restart python
```

### **6. Bases de Datos**

#### **❌ Error: "Database connection failed from application"**

**Síntomas:**
```
psycopg2.OperationalError: could not connect to server
```

**Solución:**
```bash
# 1. Verificar que base de datos está corriendo
dev-status

# 2. Probar conexión desde HOST
psql -h localhost -U developer -d devdb -c "SELECT 1;"

# 3. Probar conexión desde contenedor
py-dev
psql -h postgres-db -U developer -d devdb -c "SELECT 1;"

# 4. Si fallla, verificar logs
dev logs databases

# 5. Reiniciar base de datos
dev restart databases
```

#### **❌ Error: "Authentication failed for user"**

**Síntomas:**
```
psql: error: connection to server failed: FATAL: password authentication failed
```

**Solución:**
```bash
# 1. Verificar credenciales en docker-compose.yml
grep -A 5 "POSTGRES_" ~/Development/containers/databases/docker-compose.yml

# 2. Si cambiaste credenciales, recrear contenedor
cd ~/Development/containers/databases
docker-compose down -v  # ¡CUIDADO! Borra datos
docker-compose up -d

# 3. O conectar como superusuario
docker exec -it dev-postgres psql -U postgres
```

### **7. Networking y Puertos**

#### **❌ Error: "Cannot access service from HOST"**

**Síntomas:**
- Servicio corre en contenedor pero no accesible desde HOST
- `curl localhost:8000` falla

**Solución:**
```bash
# 1. Verificar mapeo de puertos
docker port python-dev-env

# 2. Verificar que servicio escucha en 0.0.0.0
# En lugar de:
uvicorn app:app --host 127.0.0.1  # ❌ Solo localhost del contenedor

# Usar:
uvicorn app:app --host 0.0.0.0    # ✅ Accesible desde HOST

# 3. Verificar firewall
sudo ufw status
sudo ufw allow 8000
```

#### **❌ Error: "Service discovery between containers fails"**

**Síntomas:**
- Contenedor A no puede acceder a contenedor B por nombre

**Solución:**
```bash
# 1. Verificar que ambos están en dev-network
docker network inspect dev-network

# 2. Ping entre contenedores
docker exec python-dev-env ping nodejs-dev-env

# 3. Si falla, verificar docker-compose.yml
# Ambos servicios deben tener:
# networks:
#   - dev-network

# 4. Recrear red si es necesario
docker network rm dev-network
docker network create --driver bridge --subnet=172.20.0.0/16 dev-network
```

## 🔍 **Herramientas de Diagnóstico**

### **Comandos de Investigación**

```bash
# === ESTADO GENERAL ===
dev-status                    # Estado de servicios
docker ps                     # Contenedores activos
docker network ls             # Redes disponibles
docker volume ls              # Volúmenes de datos

# === CONTENEDOR ESPECÍFICO ===
docker logs dev-postgres      # Logs de PostgreSQL
docker exec -it python-dev-env bash  # Conectar directamente
docker stats python-dev-env  # Uso de recursos
docker inspect python-dev-env # Configuración completa

# === CONECTIVIDAD ===
docker exec python-dev-env ping postgres-db
docker exec python-dev-env netstat -an
docker exec python-dev-env curl http://nodejs-dev:3000

# === RECURSOS ===
docker system df              # Uso de espacio
docker stats                  # CPU/RAM en tiempo real
free -h                       # Memoria HOST
df -h                         # Espacio disco HOST
```

### **Scripts de Diagnóstico**

```bash
# Crear script de diagnóstico completo
cat > ~/Development/diagnose.sh << 'EOF'
#!/bin/bash
echo "=== DIAGNÓSTICO ENTORNOS DESARROLLO ==="
echo
echo "1. Sistema:"
echo "OS: $(lsb_release -d | cut -f2)"
echo "Docker: $(docker --version)"
echo "Compose: $(docker-compose --version)"
echo "Usuario en grupo docker: $(groups $USER | grep -o docker || echo 'NO')"
echo

echo "2. Contenedores:"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo

echo "3. Redes:"
docker network ls | grep dev
echo

echo "4. Volúmenes:"
docker volume ls | grep -E "(postgres|mysql|mongo|redis|python|node)" | head -10
echo

echo "5. Espacio en disco:"
docker system df
echo

echo "6. Recursos:"
echo "Memoria:"
free -h | head -2
echo "CPU:"
top -bn1 | grep "Cpu(s)" | head -1
echo

echo "7. Conectividad:"
echo "Red dev-network:"
docker network inspect dev-network --format '{{.Name}}: {{.IPAM.Config}}' 2>/dev/null || echo "RED NO EXISTE"
echo

echo "8. Puertos en uso:"
ss -tulnp | grep -E ":5432|:3306|:6379|:27017|:8000|:3000" | head -10
EOF

chmod +x ~/Development/diagnose.sh

# Ejecutar diagnóstico
~/Development/diagnose.sh
```

## 📞 **Comandos de Emergencia**

### **Reset Completo**

```bash
# ⚠️ CUIDADO: Esto borra TODOS los datos de desarrollo

# 1. Parar todos los servicios
dev-stop

# 2. Remover contenedores y volúmenes
cd ~/Development/containers
for dir in */; do
  cd "$dir"
  docker-compose down -v
  cd ..
done

# 3. Limpiar Docker
docker system prune -af
docker volume prune -f

# 4. Recrear todo
dev-setup all
dev-start
```

### **Reset Parcial (sin perder datos)**

```bash
# 1. Parar servicios
dev-stop

# 2. Reconstruir contenedores (mantiene volúmenes)
cd ~/Development/containers
for dir in */; do
  cd "$dir"
  docker-compose down
  docker-compose build --no-cache
  docker-compose up -d
  cd ..
done
```

### **Backup de Emergencia**

```bash
# Backup rápido de proyectos
tar -czf ~/emergency-backup-$(date +%Y%m%d-%H%M).tar.gz ~/Development/projects/

# Backup de bases de datos
mkdir -p ~/db-backups
docker exec dev-postgres pg_dumpall -U postgres > ~/db-backups/postgres-backup-$(date +%Y%m%d).sql
docker exec dev-mysql mysqldump -u root -pdevpass --all-databases > ~/db-backups/mysql-backup-$(date +%Y%m%d).sql
```

## 🔬 **Debugging Avanzado**

### **Logs Detallados**

```bash
# Logs con timestamp
docker logs --timestamps dev-postgres

# Logs en tiempo real
docker logs -f python-dev-env

# Logs filtrados
docker logs dev-postgres 2>&1 | grep ERROR
```

### **Análisis de Red**

```bash
# Ver configuración de red completa
docker network inspect dev-network | jq '.[0].Containers'

# Probar conectividad específica
docker exec python-dev-env nslookup postgres-db
docker exec python-dev-env telnet postgres-db 5432
```

### **Análisis de Performance**

```bash
# Recursos en tiempo real
watch -n 1 'docker stats --no-stream'

# Análisis de proceso dentro del contenedor
docker exec python-dev-env htop

# Análisis de red dentro del contenedor
docker exec python-dev-env iftop
```

## 📝 **Logs de Errores Frecuentes**

### **Python Development**

```bash
# Error típico: ModuleNotFoundError
# Solución: Verificar que estás en el entorno virtual correcto
py-dev
which python
pip list

# Error típico: Permission denied writing files  
# Solución: Verificar permisos de directorio
ls -la /workspace/projects/
chmod 755 /workspace/projects/
```

### **Node.js Development**

```bash
# Error típico: node_modules issues
# Solución: Limpiar cache npm
node-dev
npm cache clean --force
rm -rf node_modules package-lock.json
npm install

# Error típico: EACCES npm permissions
# Solución: Configurar npm prefix
npm config set prefix /home/developer/.npm-global
echo 'export PATH=$PATH:/home/developer/.npm-global/bin' >> ~/.bashrc
```

### **Database Issues**

```bash
# PostgreSQL no inicia
# Revisar logs específicos:
docker logs dev-postgres

# Errores comunes:
# "initdb: invalid locale settings" → Verificar LOCALE en Dockerfile
# "could not create shared memory segment" → Aumentar shm_size en docker-compose
```

## ⚡ **Recovery Procedures**

### **Recuperación Rápida - Servicio Específico**

```bash
# Template para cualquier servicio
SERVICE="python"  # o nodejs, java, golang, databases, tools

# 1. Parar servicio
dev stop $SERVICE

# 2. Ver logs para entender problema
dev logs $SERVICE

# 3. Limpiar contenedor específico
cd ~/Development/containers/$SERVICE
docker-compose down
docker-compose rm -f

# 4. Reconstruir y reiniciar
docker-compose build --no-cache
docker-compose up -d

# 5. Verificar estado
dev-status
```

### **Recuperación Completa - Proyecto Específico**

```bash
# Si un proyecto específico está corrupto

PROJECT="mi-proyecto-python"

# 1. Backup del proyecto
cp -r ~/Development/projects/python/$PROJECT ~/backup-$PROJECT-$(date +%Y%m%d)

# 2. Recrear proyecto desde git (si aplica)
cd ~/Development/projects/python/
git clone <repository-url> $PROJECT-new

# 3. Migrar datos/configuraciones
cp ~/backup-$PROJECT-*/config/* ~/Development/projects/python/$PROJECT-new/
```

### **Recuperación de Base de Datos**

```bash
# PostgreSQL recovery
# 1. Parar servicio
dev stop databases

# 2. Backup del volumen (si es posible)
docker run --rm -v postgres-data:/data -v ~/db-backups:/backup busybox tar czf /backup/postgres-volume-backup.tar.gz /data

# 3. Reinicializar base de datos
docker volume rm postgres-data

# 4. Reiniciar servicio
dev start databases

# 5. Restaurar datos (si tienes backup SQL)
psql -h localhost -U developer -d devdb < ~/db-backups/latest-backup.sql
```

## 🔧 **Mantenimiento Preventivo**

### **Rutina Diaria**

```bash
# Al inicio del día
dev-status                    # Verificar estado
dev-start                     # Iniciar servicios necesarios

# Durante el desarrollo
dev logs python 2>&1 | grep ERROR  # Buscar errores
docker stats --no-stream      # Verificar recursos

# Al final del día
dev-stop                      # Parar servicios
docker system prune -f        # Limpiar caché
```

### **Rutina Semanal**

```bash
# Backup semanal
dev backup

# Actualizar imágenes
dev update

# Limpiar logs antiguos
docker system prune -af --filter "until=168h"

# Verificar integridad de volúmenes
docker volume inspect postgres-data
docker volume inspect mysql-data
```

### **Rutina Mensual**

```bash
# Backup completo
tar -czf ~/monthly-backup-$(date +%Y%m).tar.gz ~/Development/

# Actualizar contenedores base
cd ~/Development/containers
for dir in */; do
  cd "$dir"
  docker-compose pull
  docker-compose up -d
  cd ..
done

# Limpiar imágenes antiguas
docker image prune -af
```

## 📞 **Contacto y Soporte**

### **Información del Sistema**

```bash
# Generar reporte completo para soporte
cat > ~/Development/system-report.txt << EOF
=== REPORTE SISTEMA DESARROLLO ===
Fecha: $(date)
Usuario: $USER
OS: $(lsb_release -a)
Docker: $(docker --version)
Compose: $(docker-compose --version)
Shell: $SHELL

=== SERVICIOS ===
$(dev-status)

=== CONTENEDORES ===
$(docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}")

=== RECURSOS ===
$(docker system df)

=== RED ===
$(docker network inspect dev-network --format '{{.Name}}: {{.IPAM.Config}}')

=== VOLÚMENES ===
$(docker volume ls | grep -E "(postgres|mysql|mongo|redis)")
EOF

echo "Reporte generado en: ~/Development/system-report.txt"
```

---

## 🆘 **Si Nada Funciona**

### **Reinstalación Completa**

```bash
# 1. Backup de proyectos (LO MÁS IMPORTANTE)
tar -czf ~/BACKUP-PROYECTOS-$(date +%Y%m%d).tar.gz ~/Development/projects/

# 2. Parar y remover todo
dev-stop
docker system prune -af
docker volume prune -f
docker network prune -f

# 3. Reinstalar desde cero
cd /path/to/dwm-qtile-project
./01-install-developer.sh

# 4. Reconfigurar entornos
# Después de reiniciar sesión:
dev-setup all

# 5. Restaurar proyectos
tar -xzf ~/BACKUP-PROYECTOS-*.tar.gz -C ~/
```

---

**💡 Tip**: Mantén siempre el archivo `system-report.txt` actualizado para facilitar el troubleshooting.
