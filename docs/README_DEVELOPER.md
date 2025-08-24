# DWM + Qtile para Desarrolladores de Software

## 🎯 Propósito

Esta configuración está específicamente optimizada para **desarrolladores e ingenieros de software**, proporcionando un entorno minimalista pero completo para el desarrollo de aplicaciones.

## ✨ Características Principales

### 🖥️ **Window Managers Optimizados**
- **DWM**: Ultraligero, personalizable, ideal para máximo rendimiento
- **Qtile**: Dinámico en Python, fácil configuración, perfecto para workflows complejos

### 🛠️ **Herramientas de Desarrollo Incluidas**

#### **Lenguajes de Programación**
- **Python 3** + pip, venv, setuptools
- **Node.js** + npm (última versión LTS)
- **Java** (OpenJDK) + Maven + Gradle
- **Rust** + Cargo
- **Go** (Golang)
- **C/C++** (GCC, Clang, CMake)

#### **IDEs y Editores**
- **VS Code** (extensiones recomendadas incluidas)
- **PyCharm Community** (via Flatpak)
- **IntelliJ IDEA Community** (via Flatpak) 
- **Neovim** (configuración mejorada)
- **Sublime Text** (via Flatpak)

#### **Herramientas de Contenedores**
- **Docker** + Docker Compose
- **Podman** (alternativa rootless)
- **Kubernetes** tools (kubectl, helm)

#### **Bases de Datos**
- **PostgreSQL** (servidor + cliente)
- **MariaDB/MySQL**
- **Redis**
- **SQLite**
- **DBeaver** (cliente universal GUI)

### 🌐 **Herramientas de Red y APIs**
- **Postman** (cliente API)
- **Insomnia** (alternativa a Postman)
- **HTTPie** (cliente HTTP CLI)
- **curl**, **wget**

### 📊 **Monitoreo y Profiling**
- **htop**, **btop** (monitoreo de procesos)
- **Docker stats** integrado
- **Sistema de métricas en tiempo real**

## 📁 **Estructura de Directorios**

```
~/Development/
├── projects/           # Tus proyectos de desarrollo
│   ├── web/           # Proyectos web
│   ├── mobile/        # Apps móviles
│   ├── desktop/       # Apps de escritorio
│   └── scripts/       # Scripts útiles
├── tools/             # Herramientas personalizadas
├── containers/        # Configuraciones Docker
├── databases/         # Scripts y dumps de BD
└── scripts/           # Scripts de automatización
```

## 🔧 **Instalación**

### Instalación Automática (Recomendada)
```bash
chmod +x 01-install-developer.sh
./01-install-developer.sh
```

### Instalación Manual por Componentes
```bash
# 1. Instalar paquetes base del sistema
sudo apt update && sudo apt upgrade -y

# 2. Instalar herramientas de desarrollo
sudo apt install -y build-essential git curl wget

# 3. Seguir pasos del script...
```

## ⌨️ **Atajos de Teclado Principales**

### **Aplicaciones (Super + Letra)**
| Atajo | Acción |
|-------|--------|
| `Super + Return` | Terminal principal (Alacritty) |
| `Super + Shift + Return` | Terminal con splits (Terminator) |
| `Super + e` | VS Code |
| `Super + Shift + e` | Neovim |
| `Super + b` | Firefox |
| `Super + f` | Gestor de archivos |
| `Super + r` | Rofi (launcher) |
| `Super + p` | PyCharm |
| `Super + i` | IntelliJ IDEA |

### **Herramientas de Desarrollo**
| Atajo | Acción |
|-------|--------|
| `Super + g` | Git GUI |
| `Super + a` | Postman (API client) |
| `Super + o` | Docker containers |
| `Super + Shift + o` | Docker images |
| `Super + k` | kubectl (Kubernetes) |
| `Super + m` | htop (monitor sistema) |

### **Navegación de Ventanas**
| Atajo | Acción |
|-------|--------|
| `Super + h/j/k/l` | Mover foco |
| `Super + Shift + h/j/k/l` | Mover ventana |
| `Super + Control + h/l` | Redimensionar |
| `Super + Tab` | Cambiar layout |
| `Super + q` | Cerrar ventana |

## 🖼️ **Workspaces Organizados**

### **Qtile - Grupos Especializados**
1. **🏠 Home** - General, inicio
2. **🌐 Web** - Navegadores, investigación
3. **💻 Code** - IDEs, editores  
4. **🗄️ Database** - Clientes de BD
5. **🐳 Docker** - Contenedores
6. **📧 Communication** - Slack, Discord
7. **📊 Monitoring** - htop, logs
8. **🎵 Media** - Música, videos
9. **📁 Files** - Gestores de archivos

### **DWM - Tags con Iconos**
1. **󰈹** General
2. **󰈹** Browser  
3. **** Code
4. **** Terminal
5. **󰆍** Database
6. **** Docker
7. **** Communication
8. **󰋋** Files
9. **󰍉** Media

## 📈 **Barra de Estado Inteligente**

### **Información para Desarrolladores**
- **Estado de servicios**: Docker 🐳, PostgreSQL 🐘, Redis 📦
- **Git status**: Cambios pendientes en proyectos
- **Carga del sistema**: Con códigos de color
- **Temperatura CPU**: Monitoreo térmico
- **Memoria RAM**: Uso detallado
- **Red**: IP y velocidad
- **Fecha/hora**: Formato completo

## 🔧 **Configuraciones Específicas**

### **Git Configuration**
```bash
# El script configura automáticamente:
git config --global core.editor "code --wait"
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global credential.helper 'cache --timeout=28800'
```

### **Docker sin sudo**
```bash
# Usuario agregado automáticamente al grupo docker
sudo usermod -aG docker $USER
# Reiniciar sesión para aplicar cambios
```

### **Zsh + Oh My Zsh**
- Shell mejorada con autocompletado
- Plugins para git, docker, kubectl
- Tema optimizado para desarrollo

## 🚀 **Workflows Recomendados**

### **Desarrollo Web**
1. **Workspace 2** (🌐): Browser para testing
2. **Workspace 3** (💻): VS Code con proyecto
3. **Workspace 4** (Terminal): Servers de desarrollo
4. **Workspace 5** (🗄️): Base de datos si aplica

### **Desarrollo Backend**
1. **Workspace 3** (💻): IDE principal  
2. **Workspace 4** (Terminal): Múltiples terminales
3. **Workspace 5** (🗄️): Cliente de BD
4. **Workspace 6** (🐳): Docker containers

### **DevOps/SysAdmin**
1. **Workspace 4** (Terminal): Comandos SSH/kubectl
2. **Workspace 6** (🐳): Docker management
3. **Workspace 7** (📊): Monitoreo de sistemas

## 🎨 **Personalización**

### **Cambiar Tema de Color**
En `~/.local/src/dwm/config_developer.h`:
```c
// Cambiar tema activo
static const struct Theme *current_theme = &onedark;     // One Dark
static const struct Theme *current_theme = &vscode_dark; // VS Code Dark
static const struct Theme *current_theme = &github_dark; // GitHub Dark
```

### **Modificar Layouts de Qtile**
En `~/.config/qtile/config_developer.py`:
```python
# Cambiar layout por defecto
layout_theme = {
    "border_width": 2,          # Grosor del borde
    "margin": 8,                # Margen entre ventanas
    "border_focus": "#e06c75",  # Color ventana enfocada
}
```

## 📚 **Recursos Adicionales**

### **Documentación**
- [DWM Manual](https://dwm.suckless.org/)
- [Qtile Documentation](http://docs.qtile.org/)
- [Arch Wiki - DWM](https://wiki.archlinux.org/title/dwm)

### **Comunidades**
- [r/unixporn](https://reddit.com/r/unixporn) - Inspiración visual
- [r/DWM](https://reddit.com/r/dwm) - Comunidad DWM
- [Qtile Discord](https://discord.gg/qtile)

## 🐛 **Solución de Problemas**

### **Servicios no inician**
```bash
# Verificar estado de servicios
systemctl status docker postgresql redis-server

# Iniciar manualmente
sudo systemctl start docker
```

### **Configuración de Git no aplicada**
```bash
# Reconfigurar Git manualmente
git config --global user.name "Tu Nombre"
git config --global user.email "tu@email.com"
```

### **DWM no compila**
```bash
# Instalar dependencias faltantes
sudo apt install libx11-dev libxft-dev libxinerama-dev

# Recompilar
cd ~/.local/src/dwm
sudo make clean install
```

### **Qtile no inicia**
```bash
# Verificar configuración
python3 -m py_compile ~/.config/qtile/config_developer.py

# Ver logs
tail -f ~/.local/share/qtile/qtile.log
```

## 🔄 **Actualizaciones**

### **Mantener el sistema actualizado**
```bash
# Sistema base
sudo apt update && sudo apt upgrade

# Flatpaks
flatpak update

# Python packages
pip3 list --outdated | awk '{print $1}' | xargs pip3 install --upgrade

# NPM packages globales
npm update -g
```

## 📞 **Soporte**

Si encuentras problemas:

1. **Revisa logs**: `~/.local/share/qtile/qtile.log`
2. **Verifica configuración**: Sintaxis en archivos de config
3. **Consulta documentación**: Enlaces en recursos adicionales
4. **Comunidad**: Subreddits y Discord mencionados

## 📝 **Changelog**

### v2.0 - Developer Edition (Agosto 2025)
- ✅ Configuración específica para desarrolladores
- ✅ 4 niveles de instalación por componentes  
- ✅ Workspaces organizados por tipo de trabajo
- ✅ Barra de estado con info de desarrollo
- ✅ Docker, Kubernetes, múltiples lenguajes
- ✅ IDEs principales via Flatpak
- ✅ Automatización y scripts inteligentes

---

**¡Disfruta tu nuevo entorno de desarrollo minimalista y productivo!** 🚀
