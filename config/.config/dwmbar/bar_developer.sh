#!/bin/bash

############################################
# Barra de estado DWM para desarrolladores
# Muestra información relevante para desarrollo:
# - Estado de servicios (Docker, PostgreSQL, Redis)
# - Uso de CPU/RAM detallado
# - Estado de Git en directorio de trabajo
# - Conexión de red y velocidad
# - Temperatura del sistema
# - Carga del sistema
############################################

DIR="$HOME/.config/dwmbar/scripts"

# Crear directorio de scripts si no existe
mkdir -p "$DIR"

# Función para verificar si un servicio está corriendo
check_service() {
    if systemctl is-active --quiet $1 2>/dev/null; then
        echo "🟢"
    else
        echo "🔴"  
    fi
}

# Función para obtener status de Git
git_status() {
    if [ -d ~/Development/projects ]; then
        cd ~/Development/projects
        # Buscar repositorios con cambios
        changed_repos=0
        for dir in */; do
            if [ -d "$dir/.git" ]; then
                cd "$dir"
                if ! git diff-index --quiet HEAD -- 2>/dev/null; then
                    ((changed_repos++))
                fi
                cd ..
            fi
        done
        
        if [ $changed_repos -gt 0 ]; then
            echo "📝$changed_repos"
        else
            echo "✅"
        fi
    else
        echo "❓"
    fi
}

# Función para obtener carga del sistema con colores
load_average() {
    load=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//')
    load_num=$(echo $load | cut -d'.' -f1)
    
    if [ $load_num -gt 2 ]; then
        echo "🔴 $load"
    elif [ $load_num -gt 1 ]; then
        echo "🟡 $load"  
    else
        echo "🟢 $load"
    fi
}

# Función para obtener temperatura del CPU
cpu_temp() {
    if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
        temp=$(cat /sys/class/thermal/thermal_zone0/temp)
        temp_c=$((temp/1000))
        
        if [ $temp_c -gt 70 ]; then
            echo "🔥${temp_c}°C"
        elif [ $temp_c -gt 50 ]; then
            echo "🟡${temp_c}°C"
        else
            echo "❄️${temp_c}°C"
        fi
    else
        echo ""
    fi
}

# Loop principal de la barra
while true; do
    # Servicios de desarrollo
    docker_status=$(check_service docker)
    postgres_status=$(check_service postgresql)  
    redis_status=$(check_service redis-server)
    services="🐳$docker_status 🐘$postgres_status 📦$redis_status"
    
    # Git status
    git_info=$(git_status)
    git_display="📋$git_info"
    
    # Sistema básico  
    datetime="📅$(date '+%Y-%m-%d %H:%M')"
    memory="🧠$($DIR/memoria.sh 2>/dev/null || echo 'N/A')"
    wifi_info="🌐$($DIR/wifi_ip.sh 2>/dev/null || echo 'N/A')"
    volume="🔊$($DIR/volume.sh 2>/dev/null || echo 'N/A')"
    
    # Información adicional para desarrollo
    load_info="⚡$(load_average)"
    temp_info="$(cpu_temp)"
    disk_info="💾$($DIR/disk_root.sh 2>/dev/null || echo 'N/A')"
    
    # Construir barra final
    status_bar="$services | $git_display | $load_info | $temp_info | $memory | $disk_info | $wifi_info | $volume | $datetime"
    
    # Mostrar en DWM
    xsetroot -name "$status_bar"
    
    sleep 2
done
