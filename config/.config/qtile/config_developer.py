####################################################
# Configuración de Qtile OPTIMIZADA para DESARROLLADORES
# Agosto 2025 - Adaptada para workflows de desarrollo
# Incluye workspaces específicos, atajos para IDEs,
# layouts optimizados para múltiples ventanas y
# widgets específicos para monitoreo de sistema
####################################################

from libqtile import bar, layout, widget, hook, qtile
from libqtile.config import Click, Drag, Group, Key, Match, hook, Screen, KeyChord
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.dgroups import simple_key_binder

import os
import subprocess
from libqtile import hook

####################################################
# VARIABLES PARA DESARROLLO

mod = "mod4"  # Super/Windows key
mod1 = "mod1" # Alt key

# Terminales (múltiples opciones para diferentes necesidades)
terminal = "alacritty"          # Terminal principal GPU-accelerated
terminal_alt = "terminator"     # Terminal con splits
terminal_floating = "xterm"     # Terminal flotante rápido

# Aplicaciones de desarrollo
filemanager = "thunar"
browser = "firefox"
browser_dev = "chromium --new-window --app="
editor = "code"                 # VS Code
editor_alt = "nvim"            # Neovim
ide_python = "flatpak run org.jetbrains.PyCharm-Community"
ide_java = "flatpak run com.jetbrains.IntelliJ-IDEA-Community"

# Herramientas de desarrollo
git_gui = "gitg"
api_client = "flatpak run io.postman.Postman"
db_client = "flatpak run org.dbeaver.DBeaverCommunity"
docker_gui = "docker"          # Se podría usar Portainer vía web

# Sistema
powermenu = "wlogout"

####################################################
# GRUPOS DE TRABAJO ESPECIALIZADOS PARA DESARROLLO

# Grupos con nombres descriptivos para workflow de desarrollo
group_names = [
    ("1", "🏠"), # Home/General
    ("2", "🌐"), # Web/Browser  
    ("3", "💻"), # Code/Editor
    ("4", "🗄️"),  # Database
    ("5", "🐳"), # Docker/Containers
    ("6", "📧"), # Communication
    ("7", "📊"), # Monitoring
    ("8", "🎵"), # Media
    ("9", "📁"), # Files
    ("0", "⚙️"), # System/Config
]

# Crear grupos con reglas automáticas de ventanas
groups = []
for name, label in group_names:
    groups.append(Group(name, label=label))

# Reglas automáticas para organizar aplicaciones por workspace
group_matches = {
    "2": [  # Web/Browser
        Match(wm_class="firefox"),
        Match(wm_class="chromium"),
        Match(wm_class="google-chrome"),
    ],
    "3": [  # Code/Editor  
        Match(wm_class="code"),
        Match(wm_class="code-oss"),
        Match(wm_class="sublime_text"),
        Match(wm_class="jetbrains-pycharm-ce"),
        Match(wm_class="jetbrains-idea-ce"),
    ],
    "4": [  # Database
        Match(wm_class="dbeaver"),
        Match(wm_class="mysql-workbench"),
        Match(wm_class="pgadmin4"),
    ],
    "5": [  # Docker/Containers
        Match(title="Docker"),
        Match(wm_class="docker-desktop"),
    ],
    "6": [  # Communication
        Match(wm_class="slack"),
        Match(wm_class="discord"),
        Match(wm_class="telegram-desktop"),
        Match(wm_class="zoom"),
    ],
    "7": [  # Monitoring
        Match(wm_class="htop"),
        Match(wm_class="btop"),
        Match(wm_class="system-monitor"),
    ],
    "8": [  # Media
        Match(wm_class="vlc"),
        Match(wm_class="mpv"),
        Match(wm_class="spotify"),
    ],
    "9": [  # Files
        Match(wm_class="thunar"),
        Match(wm_class="nautilus"),
        Match(wm_class="pcmanfm"),
    ],
}

# Aplicar matches a grupos
for group_name, matches in group_matches.items():
    group = next((g for g in groups if g.name == group_name), None)
    if group:
        group.matches = matches

####################################################
# ATAJOS DE TECLADO OPTIMIZADOS PARA DESARROLLO

keys = [
    # =============== NAVEGACIÓN BÁSICA ===============
    # Mover foco entre ventanas
    Key([mod], "h", lazy.layout.left(), desc="Move focus left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "Left", lazy.layout.left()),
    Key([mod], "Right", lazy.layout.right()),
    Key([mod], "Down", lazy.layout.down()),
    Key([mod], "Up", lazy.layout.up()),
    Key([mod], "space", lazy.layout.next()),

    # Mover ventanas
    Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left()),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right()),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up()),

    # Redimensionar ventanas
    Key([mod, "control"], "h", lazy.layout.grow_left()),
    Key([mod, "control"], "l", lazy.layout.grow_right()),
    Key([mod, "control"], "j", lazy.layout.grow_down()),
    Key([mod, "control"], "k", lazy.layout.grow_up()),
    Key([mod, "control"], "Left", lazy.layout.grow_left()),
    Key([mod, "control"], "Right", lazy.layout.grow_right()),
    Key([mod, "control"], "Down", lazy.layout.grow_down()),
    Key([mod, "control"], "Up", lazy.layout.grow_up()),

    # =============== APLICACIONES DE DESARROLLO ===============
    
    # Terminales
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch main terminal"),
    Key([mod, "shift"], "Return", lazy.spawn(terminal_alt), desc="Launch terminal with splits"),
    Key([mod, "control"], "Return", lazy.spawn(terminal_floating), desc="Launch floating terminal"),

    # Editores e IDEs
    Key([mod], "e", lazy.spawn(editor), desc="Launch VS Code"),
    Key([mod, "shift"], "e", lazy.spawn(editor_alt), desc="Launch Neovim in terminal"),
    Key([mod], "p", lazy.spawn(ide_python), desc="Launch PyCharm"),
    Key([mod], "i", lazy.spawn(ide_java), desc="Launch IntelliJ IDEA"),

    # Navegadores
    Key([mod], "b", lazy.spawn(browser), desc="Launch Firefox"),
    Key([mod, "shift"], "b", lazy.spawn("chromium"), desc="Launch Chromium"),

    # Herramientas de desarrollo
    Key([mod], "g", lazy.spawn(git_gui), desc="Launch Git GUI"),
    Key([mod], "d", lazy.spawn(db_client), desc="Launch Database client"),
    Key([mod], "a", lazy.spawn(api_client), desc="Launch API client"),
    
    # Gestores de archivos
    Key([mod], "f", lazy.spawn(filemanager), desc="Launch file manager"),
    Key([mod, "shift"], "f", lazy.spawn("ranger"), desc="Launch ranger (CLI file manager)"),

    # =============== HERRAMIENTAS DEL SISTEMA ===============
    
    # Monitoreo del sistema
    Key([mod], "m", lazy.spawn(terminal + " -e htop"), desc="Launch htop"),
    Key([mod, "shift"], "m", lazy.spawn(terminal + " -e btop"), desc="Launch btop"),
    
    # Docker
    Key([mod], "o", lazy.spawn(terminal + " -e docker ps"), desc="Docker containers"),
    Key([mod, "shift"], "o", lazy.spawn(terminal + " -e docker images"), desc="Docker images"),

    # =============== DESARROLLO ESPECÍFICO ===============
    
    # Quick commands con rofi
    Key([mod], "r", lazy.spawn("rofi -show drun -show-icons"), desc="Run launcher"),
    Key([mod, "shift"], "r", lazy.spawn("rofi -show run"), desc="Run command"),
    Key([mod], "w", lazy.spawn("rofi -show window"), desc="Window switcher"),

    # Screenshots (importantes para documentación)
    Key([], "Print", lazy.spawn("xfce4-screenshooter"), desc="Screenshot"),
    Key(["shift"], "Print", lazy.spawn("xfce4-screenshooter -r"), desc="Screenshot region"),
    Key(["control"], "Print", lazy.spawn("xfce4-screenshooter -w"), desc="Screenshot window"),

    # =============== LAYOUTS Y VENTANAS ===============
    
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "y", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
    
    # Layout específicos útiles para desarrollo
    Key([mod], "n", lazy.layout.normalize(), desc="Reset window sizes"),
    Key([mod], "comma", lazy.layout.decrease_nmaster(), desc="Decrease master windows"),
    Key([mod], "period", lazy.layout.increase_nmaster(), desc="Increase master windows"),

    # =============== SISTEMA ===============
    
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload config"),
    Key([mod, "shift"], "x", lazy.spawn(powermenu), desc="Power menu"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),

    # =============== MULTIMEDIA ===============
    
    # Control de volumen
    Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")),
    
    # Control multimedia
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause")),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next")),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous")),
    
    # Brillo (para laptops)
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl s 5%+")),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl s 5%-")),
]

# Atajos para cambiar entre grupos
for i in groups:
    keys.extend([
        # Cambiar a grupo
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc=f"Switch to group {i.name}"),
        # Mover ventana a grupo
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            desc=f"Move window to group {i.name}"),
        # Cambiar a grupo y seguir la ventana
        Key([mod, "control"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc=f"Move window to group {i.name} and follow"),
    ])

####################################################
# LAYOUTS OPTIMIZADOS PARA DESARROLLO

layout_theme = {
    "border_width": 2,
    "margin": 8,
    "border_focus": "#e06c75",    # Rojo suave para foco
    "border_normal": "#3e4452",   # Gris para ventanas normales  
    "border_focus_stack": "#61afef", # Azul para stacks con foco
    "border_normal_stack": "#3e4452",
}

layouts = [
    # Layout principal para desarrollo - columnas flexibles
    layout.Columns(
        **layout_theme,
        border_on_single=True,
        num_columns=3,
        grow_amount=10,
    ),
    
    # Para concentrarse en una sola ventana
    layout.Max(**layout_theme),
    
    # Para comparar código side-by-side  
    layout.MonadTall(
        **layout_theme,
        ratio=0.6,
        change_ratio=0.02,
        max_ratio=0.8,
        min_ratio=0.25,
    ),
    
    # Para múltiples terminales o logs
    layout.MonadWide(
        **layout_theme,
        ratio=0.65,
        change_ratio=0.02,
    ),
    
    # Stack para muchas ventanas pequeñas
    layout.Stack(
        **layout_theme,
        num_stacks=2,
        autosplit=True,
    ),
    
    # Para presentaciones o demos
    layout.Floating(**layout_theme),
    
    # Matrix para monitoreo de múltiples servicios
    layout.Matrix(
        **layout_theme,
        columns=3,
    ),
    
    # Spiral para navegación de código
    layout.Spiral(
        **layout_theme,
        ratio=0.6,
        clockwise=True,
    ),
]

####################################################
# WIDGETS ESPECIALIZADOS PARA DESARROLLO

widget_defaults = dict(
    font="JetBrains Mono Nerd Font",
    fontsize=12,
    padding=3,
    background="#282c34",  # One Dark background
)

extension_defaults = widget_defaults.copy()

def init_widgets_list():
    widgets_list = [
        # Menú de aplicaciones
        widget.Image(
            filename="~/.config/qtile/Assets/python-white.png",
            scale="False",
            mouse_callbacks={'Button1': lambda: qtile.cmd_spawn("rofi -show drun")},
            margin=3,
        ),
        
        # Indicador de grupos con iconos
        widget.GroupBox(
            fontsize=14,
            margin_y=3,
            margin_x=0,
            padding_y=5,
            padding_x=3,
            borderwidth=3,
            active="#61afef",           # Azul para activos
            inactive="#5c6370",        # Gris para inactivos 
            rounded=False,
            highlight_color="#e06c75",  # Rojo para highlight
            highlight_method="line",
            this_current_screen_border="#98c379", # Verde para actual
            this_screen_border="#61afef",
            other_current_screen_border="#e5c07b",
            other_screen_border="#c678dd",
            foreground="#abb2bf",
            background="#282c34",
        ),
        
        # Separador
        widget.Prompt(
            padding=10,
            foreground="#e06c75",
            background="#282c34",
        ),
        
        # Indicador de layout actual
        widget.CurrentLayout(
            foreground="#61afef",
            background="#282c34",
            padding=5,
        ),
        
        # Título de ventana con límite para no ocupar todo
        widget.WindowName(
            foreground="#abb2bf",
            background="#282c34",
            padding=0,
            max_chars=50,
        ),
        
        # Spacer para empujar widgets a la derecha
        widget.Spacer(),
        
        # ============ WIDGETS DE MONITOREO PARA DESARROLLO ============
        
        # Uso de CPU con gráfico
        widget.CPU(
            format="🖥️ {load_percent}%",
            foreground="#e06c75",
            background="#282c34",
            padding=5,
            update_interval=2.0,
        ),
        
        # Uso de RAM
        widget.Memory(
            format="🧠 {MemUsed:.0f}{mm}",
            foreground="#98c379", 
            background="#282c34",
            padding=5,
            update_interval=2.0,
        ),
        
        # Uso de disco (importante para compilaciones)
        widget.DF(
            update_interval=600,
            foreground="#d19a66",
            background="#282c34", 
            padding=5,
            visible_on_warn=False,
            format="💾 {uf}{m}",
            partition="/",
        ),
        
        # Red (para APIs y descargas)
        widget.Net(
            interface="auto",
            format="🌐 ↓{down} ↑{up}",
            foreground="#61afef",
            background="#282c34",
            padding=5,
            update_interval=2.0,
        ),
        
        # Separador visual
        widget.Sep(
            linewidth=1,
            padding=10,
            foreground="#5c6370",
            background="#282c34",
        ),
        
        # Control de volumen
        widget.Volume(
            foreground="#c678dd",
            background="#282c34",
            padding=5,
            emoji=True,
        ),
        
        # Separador
        widget.Sep(
            linewidth=1, 
            padding=10,
            foreground="#5c6370",
            background="#282c34",
        ),
        
        # Reloj con formato completo
        widget.Clock(
            foreground="#e5c07b",
            background="#282c34",
            format="📅 %Y-%m-%d %H:%M",
            padding=5,
        ),
        
        # Indicador de actualizaciones del sistema
        widget.CheckUpdates(
            update_interval=1800,
            distro="Debian",
            display_format="📦 {updates}",
            foreground="#98c379",
            background="#282c34",
            padding=5,
            colour_have_updates="#e06c75",
            colour_no_updates="#98c379",
        ),
        
        # Systray para aplicaciones del sistema
        widget.Systray(
            background="#282c34",
            padding=5,
        ),
        
        # Botón de apagado
        widget.QuickExit(
            default_text="⏻",
            countdown_format="{}",
            foreground="#e06c75",
            background="#282c34",
            padding=5,
        ),
    ]
    return widgets_list

####################################################
# CONFIGURACIÓN DE PANTALLAS

def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1

def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    # Remover systray de pantalla secundaria
    del widgets_screen2[22]  # QuickExit
    del widgets_screen2[21]  # Systray
    return widgets_screen2

screens = [
    Screen(
        top=bar.Bar(
            widgets=init_widgets_screen1(),
            opacity=0.95,
            size=28,
            background="#282c34",
            margin=[8, 8, 0, 8],  # Margin around bar
        ),
        # Wallpaper para pantalla principal
        wallpaper="~/Pictures/dev-wallpaper.png",
        wallpaper_mode="fill",
    ),
]

# Detectar segunda pantalla
if len(subprocess.run(["xrandr", "--listmonitors"], capture_output=True, text=True).stdout.split('\n')) > 3:
    screens.append(
        Screen(
            top=bar.Bar(
                widgets=init_widgets_screen2(),
                opacity=0.95,
                size=28,
                background="#282c34",
                margin=[8, 8, 0, 8],
            ),
            wallpaper="~/Pictures/dev-wallpaper-2.png", 
            wallpaper_mode="fill",
        )
    )

####################################################
# CONFIGURACIÓN DE MOUSE Y VENTANAS FLOTANTES

mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

# Ventanas que siempre deben flotar (útil para herramientas de desarrollo)
floating_layout = layout.Floating(
    **layout_theme,
    float_rules=[
        # Diálogos del sistema
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),    # gitk  
        Match(wm_class="maketag"),       # gitk
        Match(wm_class="ssh-askpass"),   # ssh-askpass
        Match(title="branchdialog"),     # gitk
        Match(title="pinentry"),         # GPG key password entry
        
        # Herramientas de desarrollo que funcionan mejor flotando
        Match(wm_class="Arandr"),        # Monitor settings
        Match(wm_class="Pavucontrol"),   # Audio settings
        Match(wm_class="Nitrogen"),      # Wallpaper setter
        Match(wm_class="Lxappearance"),  # Theme settings
        Match(wm_class="Blueman-manager"), # Bluetooth
        
        # Aplicaciones de desarrollo específicas
        Match(wm_class="krita", title="New Image"), # Krita new image dialog
        Match(wm_class="gimp-2.10", title="GNU Image Manipulation Program"),
        Match(wm_class="VirtualBox Manager"),
        Match(wm_class="VirtualBox Machine"),
        
        # Ventanas temporales de IDEs
        Match(title="About PyCharm"),
        Match(title="Preferences"),
        Match(title="Settings"),
        Match(title="Configure"),
        Match(wm_class="jetbrains-toolbox"),
        
        # Calculadora y herramientas pequeñas
        Match(wm_class="galculator"),
        Match(wm_class="calculator"),
    ]
)

####################################################
# HOOKS PARA AUTOMATIZACIÓN

@hook.subscribe.startup_once
def start_once():
    """Aplicaciones que se ejecutan al inicio"""
    home = os.path.expanduser('~')
    subprocess.call([home + '/.config/qtile/autostart_dev.sh'])

@hook.subscribe.startup
def start_always():
    """Se ejecuta siempre que se reinicia qtile"""
    # Establecer cursor
    subprocess.Popen(['xsetroot', '-cursor_name', 'left_ptr'])

@hook.subscribe.client_new
def new_client(client):
    """Configuraciones automáticas para nuevas ventanas"""
    # IDEs y editores siempre al grupo 3 (Code)
    if client.window.get_wm_class() and any(ide in client.window.get_wm_class()[1].lower() 
                                          for ide in ['code', 'pycharm', 'idea', 'sublime']):
        client.togroup('3')
    
    # Navegadores siempre al grupo 2 (Web)
    elif client.window.get_wm_class() and any(browser in client.window.get_wm_class()[1].lower() 
                                            for browser in ['firefox', 'chromium', 'chrome']):
        client.togroup('2')

# Configuración adicional
dgroups_key_binder = None
dgroups_app_rules = []
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wmname = "Qtile-Dev"

####################################################
# FUNCIONES PERSONALIZADAS PARA DESARROLLO

@lazy.function
def window_to_prev_group(qtile):
    """Mover ventana al grupo anterior"""
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i - 1].name)

@lazy.function  
def window_to_next_group(qtile):
    """Mover ventana al siguiente grupo"""
    if qtile.currentWindow is not None:
        i = qtile.groups.index(qtile.currentGroup)
        qtile.currentWindow.togroup(qtile.groups[i + 1].name)

# Agregar atajos para las funciones personalizadas
keys.extend([
    Key([mod, "shift"], "comma", window_to_prev_group),
    Key([mod, "shift"], "period", window_to_next_group),
])

# Atajos adicionales específicos para desarrollo
development_keys = [
    # Quick terminal commands
    Key([mod, "control"], "t", lazy.spawn(terminal + " -e 'cd ~/Development/projects && bash'")),
    Key([mod, "control"], "g", lazy.spawn(terminal + " -e 'cd ~/Development/projects && git status && bash'")),
    Key([mod, "control"], "d", lazy.spawn(terminal + " -e 'docker ps && bash'")),
    Key([mod, "control"], "k", lazy.spawn(terminal + " -e 'kubectl get pods && bash'")),
    
    # Development shortcuts
    Key([mod, "control"], "s", lazy.spawn("code ~/Development/projects")),  # Open projects folder
    Key([mod, "control"], "n", lazy.spawn("code --new-window")),           # New VS Code window
    Key([mod, "control"], "p", lazy.spawn("code ~/Development/projects --add")), # Add to workspace
]

keys.extend(development_keys)
