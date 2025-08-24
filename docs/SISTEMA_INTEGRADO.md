# 🚀 SISTEMA DE DESARROLLO INTEGRADO DWM-QTILE

## 📋 Descripción General

Este es un **sistema de desarrollo completamente integrado** que combina DWM/Qtile con un entorno de desarrollo containerizado avanzado. Todos los scripts han sido mejorados para trabajar de manera coordinada con:

- **Configuración unificada** (`~/.dev_config`)
- **Sistema de logging integrado** (`~/.dev_logger`)
- **Funciones de desarrollo avanzadas** (`~/.dev_functions`)
- **Gestión coordinada de contenedores**
- **Herramientas de monitoreo y verificación**

## 🎯 INSTALACIÓN RÁPIDA

### Instalación Completa (Recomendada)
```bash
./scripts/master-dev.sh install all
```

### Instalación por Pasos
```bash
./scripts/master-dev.sh install base      # Solo base del sistema
# REINICIAR SESIÓN
./scripts/master-dev.sh install continue  # Continuar después del reinicio
```

## 📚 COMANDOS DEL SCRIPT MAESTRO

### 🔧 Comandos Principales
| Comando | Descripción |
|---------|-------------|
| `../scripts/master-dev install [step]` | Instalación completa o por pasos |
| `../scripts/master-dev setup [service]` | Configurar servicios específicos |
| `../scripts/master-dev start [service]` | Iniciar servicios |
| `../scripts/master-dev stop [service]` | Parar servicios |
| `../scripts/master-dev restart [service]` | Reiniciar servicios |
| `../scripts/master-dev status` | Ver estado completo del sistema |
| `../scripts/master-dev logs [service]` | Ver logs de servicios |
| `../scripts/master-dev check` | Verificación completa del sistema |
| `../scripts/master-dev repair` | Reparación automática |

### 📋 Pasos de Instalación
| Paso | Comando | Descripción |
|------|---------|-------------|
| `base` | `../scripts/master-dev install base` | Instalación base del sistema |
| `tools` | `../scripts/master-dev install tools` | Configuración de herramientas |
| `containers` | `../scripts/master-dev install containers` | Setup de contenedores |
| `all` | `../scripts/master-dev install all` | Instalación completa |

### 🔧 Servicios Disponibles
| Servicio | Descripción |
|----------|-------------|
| `python` | Entorno Python con bases de datos |
| `nodejs` | Entorno Node.js con herramientas |
| `java` | Entorno Java con Maven/Gradle |
| `golang` | Entorno Go con herramientas |
| `databases` | Stack completo de BD |
| `tools` | Herramientas adicionales |
| `all` | Todos los servicios |

### 💡 Ejemplos de Uso
```bash
# Instalación y configuración
master-dev install                # Instalación completa
master-dev setup python           # Solo configurar Python
master-dev start databases         # Solo iniciar BD

# Gestión de servicios
master-dev status                  # Ver estado completo
master-dev logs python            # Ver logs de Python
master-dev restart all            # Reiniciar todo

# Mantenimiento
master-dev check                   # Verificar sistema
master-dev repair                  # Reparar automáticamente
master-dev clean                   # Limpiar sistema
master-dev backup                  # Crear backup completo
```

## 🏗️ ESTRUCTURA DEL SISTEMA

### Scripts Principales
```
../scripts/master-dev.sh                   # Script maestro coordinador
../scripts/core/01-install-developer.sh    # Instalación base integrada
../scripts/core/03-config-dev-tools.sh     # Configuración de herramientas integrada
../scripts/core/setup-dev-containers.sh    # Configuración de contenedores
../scripts/core/dev-manager.sh             # Gestor de contenedores
```

### Scripts Legacy (Archivados)
```
../scripts/legacy/01-install-full.sh       # Script original completo
../scripts/legacy/02-install-interactiva.sh # Script original interactivo
```

### Estructura de Directorios
```
~/Development/              # Directorio principal
├── projects/              # Proyectos organizados por lenguaje
│   ├── python/
│   ├── nodejs/
│   ├── java/
│   └── golang/
├── containers/            # Configuraciones de contenedores
│   ├── python/
│   ├── nodejs/
│   ├── java/
│   ├── golang/
│   ├── databases/
│   └── tools/
├── tools/                 # Herramientas personalizadas
├── logs/                  # Logs del sistema
└── backups/               # Backups automáticos
```

### Archivos de Configuración
```
~/.dev_config              # Configuración global
~/.dev_logger              # Sistema de logging
~/.dev_functions           # Funciones de desarrollo
~/.bashrc / ~/.zshrc       # Shell integrado
```

## 🔧 FUNCIONES DE DESARROLLO AVANZADAS

### Gestión de Proyectos Python
```bash
newpy myproject            # Crear proyecto Python básico
newpy myapi api           # Crear proyecto API con FastAPI/Flask
newpy myapp web           # Crear proyecto web con Django
newpy mytool cli          # Crear herramienta CLI
newpy myml data           # Crear proyecto de Data Science/ML
```

### Gestión de Proyectos Node.js
```bash
newnode myproject          # Proyecto Node.js básico
newnode myapp express      # Aplicación Express
newnode myapp react        # Aplicación React
newnode myapp next         # Aplicación Next.js
newnode myapp vue          # Aplicación Vue.js
```

### VS Code Integrado
```bash
opencode                   # Abrir proyecto actual
opencode myproject         # Abrir proyecto específico
opencode myproject python  # Abrir con configuración Python
```

### Gestión de Contenedores
```bash
devup                      # Iniciar todos los contenedores
devup python              # Solo Python
devdown                   # Parar todos
devstatus                 # Ver estado
devclean                  # Limpiar contenedores
```

## 🐳 ENTORNOS DE DESARROLLO

### Python Environment
- **Python 3.11+** con pip, pipenv, poetry
- **Bases de datos**: psycopg2, pymongo, redis-py, mysql-connector
- **Web frameworks**: Django, Flask, FastAPI
- **Data Science**: pandas, numpy, jupyter, matplotlib
- **Testing**: pytest, coverage
- **Code quality**: black, flake8, mypy

### Node.js Environment
- **Node.js 18+** con npm, yarn, pnpm
- **Frameworks**: Express, React, Next.js, Vue.js
- **Tools**: nodemon, pm2, webpack, vite
- **Testing**: jest, cypress, playwright
- **Database**: mongoose, prisma, typeorm

### Java Environment
- **OpenJDK 17+** con Maven, Gradle
- **Spring Boot** framework completo
- **Testing**: JUnit, Mockito
- **Build tools**: Maven, Gradle wrapper
- **IDE support**: configuración para IntelliJ/Eclipse

### Go Environment
- **Go 1.21+** con módulos
- **Web frameworks**: Gin, Echo, Fiber
- **Database**: GORM, sql driver
- **Testing**: testing package, testify
- **Tools**: golangci-lint, air (live reload)

### Database Stack
- **PostgreSQL** con pgAdmin
- **MySQL** con phpMyAdmin  
- **MongoDB** con Mongo Express
- **Redis** con Redis Commander
- **Networks**: Comunicación inter-contenedor

## 📊 MONITOREO Y LOGS

### Visualización de Estado
```bash
master-dev status          # Estado completo con recursos
master-dev logs system     # Logs centralizados
master-dev logs python     # Logs específicos de servicio
```

### Verificación de Salud
```bash
master-dev check           # Verificación completa
dev-check                  # Verificación rápida
tools-check               # Verificación de herramientas
```

### Sistema de Logs
- **Logs centralizados** en `~/Development/logs/`
- **Logging por servicio** con docker-compose logs
- **Función dev_log** integrada en todos los scripts
- **Rotación automática** de logs antiguos

## 🔄 ACTUALIZACIONES Y MANTENIMIENTO

### Actualizaciones
```bash
master-dev update          # Actualizar todo el sistema
update-dev-tools-integrated # Solo herramientas
```

### Mantenimiento
```bash
master-dev clean           # Limpiar cache y contenedores
master-dev backup          # Backup completo
master-dev repair          # Reparación automática
```

### Backups Automáticos
- **Proyectos**: respaldo completo con .git
- **Configuraciones**: archivos de config y dotfiles
- **Bases de datos**: dumps automáticos
- **Contenedores**: configuraciones y volúmenes

## 🚀 FLUJO DE TRABAJO TÍPICO

### 1. Instalación Inicial
```bash
git clone <repo>
cd dwm-qtile-system
./master-dev.sh install all
# REINICIAR SESIÓN SI ES NECESARIO
./master-dev.sh install continue
```

### 2. Verificación
```bash
master-dev status          # Ver que todo funcione
master-dev check           # Verificar integridad
```

### 3. Desarrollo Diario
```bash
devup                      # Iniciar entorno
newpy myproject            # Crear proyecto
opencode myproject         # Abrir en VS Code
# DESARROLLAR...
devdown                    # Parar al terminar
```

### 4. Mantenimiento Semanal
```bash
master-dev update          # Actualizar sistema
master-dev clean           # Limpiar cache
master-dev backup          # Crear backup
```

## 🔧 PERSONALIZACIÓN AVANZADA

### Variables de Entorno
El archivo `~/.dev_config` contiene todas las configuraciones:
```bash
export DEV_HOME="$HOME/Development"
export DEV_PROJECTS="$DEV_HOME/projects"
export DEV_CONTAINERS="$DEV_HOME/containers"
export NETWORK_NAME="dev-network"
# ... más configuraciones
```

### Funciones Personalizadas
Añadir funciones en `~/.dev_functions`:
```bash
my_deploy() {
    # Tu función personalizada
}
```

### Extensiones de VS Code
Pre-configuradas automáticamente:
- Remote - Containers
- Python
- Node.js
- Java
- Go
- Docker
- Y muchas más...

## 🆘 SOLUCIÓN DE PROBLEMAS

### Problemas Comunes

#### Docker no funciona
```bash
sudo systemctl start docker
sudo usermod -aG docker $USER
# REINICIAR SESIÓN
```

#### Scripts no encontrados
```bash
master-dev repair          # Reparación automática
source ~/.bashrc           # Recargar configuración
```

#### Contenedores no inician
```bash
master-dev check           # Verificar problemas
docker network ls          # Verificar red
master-dev repair          # Reparar automáticamente
```

#### Permisos de archivos
```bash
sudo chown -R $USER:$USER ~/Development
chmod +x ~/Development/tools/scripts/*
```

### Debugging Avanzado
```bash
master-dev logs system     # Ver logs completos
docker system info         # Info de Docker
master-dev status          # Estado detallado
dev-check -v              # Verificación verbosa
```

## 📈 CARACTERÍSTICAS AVANZADAS

### Integración con VS Code Remote
- **Desarrollo remoto** dentro de contenedores
- **IntelliSense completo** para cada lenguaje
- **Debugging integrado** con breakpoints
- **Terminal integrado** en contenedor
- **Extensiones específicas** por proyecto

### Red de Desarrollo
- **Red Docker personalizada** (172.20.0.0/16)
- **Comunicación inter-servicios**
- **Puertos configurados** automáticamente
- **DNS interno** para servicios

### Gestión de Dependencias
- **Verificación automática** de dependencias
- **Instalación inteligente** de faltantes
- **Actualización coordinada** de herramientas
- **Rollback automático** en errores

### Monitoreo de Recursos
- **Uso de CPU/RAM** por contenedor
- **Espacio en disco** de proyectos
- **Estado de red** y puertos
- **Logs centralizados** y rotación

## 📝 CONTRIBUCIÓN

### Añadir Nuevos Lenguajes
1. Crear directorio en `containers/`
2. Añadir docker-compose.yml
3. Actualizar funciones en scripts
4. Documentar en README

### Mejoras de Scripts
1. Mantener compatibilidad con sistema integrado
2. Usar `dev_log` para logging consistente
3. Cargar configuración con `source ~/.dev_config`
4. Añadir verificaciones en `dev-check`

## 🎉 CARACTERÍSTICAS PRINCIPALES

✅ **Instalación completamente automatizada**  
✅ **Sistema de logging unificado**  
✅ **Configuración centralizada**  
✅ **Contenedores optimizados para desarrollo**  
✅ **VS Code con Remote Containers**  
✅ **Funciones inteligentes de proyecto**  
✅ **Monitoreo y verificación automática**  
✅ **Backups y actualizaciones integradas**  
✅ **Reparación automática de problemas**  
✅ **Documentación completa y ejemplos**  

---

## 📞 CONTACTO Y AYUDA

Para problemas o mejoras:
- Ejecuta `master-dev check` para diagnóstico
- Revisa logs con `master-dev logs system`  
- Usa `master-dev repair` para reparación automática
- Consulta esta documentación para referencia completa

**¡Sistema listo para desarrollo profesional! 🚀**
