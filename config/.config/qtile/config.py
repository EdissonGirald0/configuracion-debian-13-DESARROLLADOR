####################################################
# Agosto 15 de 2025
# configuración de Qtile con 2 pantallas
# barra ajustada para 1360x768
####################################################

# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

####################################################
# Librerías de qtile

from libqtile import bar, layout, widget, hook, qtile
from libqtile.config import Click, Drag, Group, Key, Match, hook, Screen, KeyChord
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.dgroups import simple_key_binder


# Librerías adicionales
# estas son para que qtile detecte si estamos en xorg o en wayland
import os
import subprocess
from libqtile import hook

####################################################
# Variables

mod = "mod4"  # La tecla con el logo de Windows
mod1 = "mod1" # La tecla alt

# terminal = guess_terminal()
# terminal = "alacritty"
terminal = "terminator"

filemanager = "thunar"

# Variables adicionales
wlogout = "wlogout" # para salir, reiniciar, apagar
                    # funciona tanto en xorg como en wayland

powermenu ="wlogout"

####################################################
# funciones

# Sticky windows

sticky_windows = []

@lazy.function
def toggle_sticky_windows(qtile, window=None):
    if window is None:
        window = qtile.current_screen.group.current_window
    if window in sticky_windows:
        sticky_windows.remove(window)
    else:
        sticky_windows.append(window)
    return window

@hook.subscribe.setgroup
def move_sticky_windows():
    for window in sticky_windows:
        window.togroup()
    return

@hook.subscribe.client_killed
def remove_sticky_windows(window):
    if window in sticky_windows:
        sticky_windows.remove(window)

# Below is an example how to make Firefox Picture-in-Picture windows automatically sticky.
@hook.subscribe.client_managed
def auto_sticky_windows(window):
    info = window.info()
    if (info['wm_class'] == ['Toolkit', 'firefox']
            and info['name'] == 'Picture-in-Picture'):
        sticky_windows.append(window)


####################################################
# Atajos de teclado



# █▄▀ █▀▀ █▄█ █▄▄ █ █▄░█ █▀▄ █▀
# █░█ ██▄ ░█░ █▄█ █ █░▀█ █▄▀ ▄█

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "Left", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "Right", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "Down", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "Up", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),


    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # agrego los mismos atajos con flechas - tomado de Arco Linux - Qtile
    Key([mod, "shift"], "Left", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "Right", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "Down", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "Up", lazy.layout.shuffle_up(), desc="Move window up"),


    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),

    # Nuevamente estos 4 atajos con flechas - gracias a Arco Linux
    Key([mod, "control"], "Left", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "Right", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "Down", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "Up", lazy.layout.grow_up(), desc="Grow window up"),



    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle focused window to fullscreen"),
    Key([mod], "v", lazy.window.toggle_floating(), desc="Toggle focused window to floating"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),

    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, "mod1"], "d", lazy.spawn("rofi -show-icons -theme rounded-green-dark -show drun"), desc="Spawn a command using a prompt widget"),


# Atajos adicionales
#########
#   Teclas de volumen con pipewire
#   se debe instalar alsa-utils para que funcione el widget de la barra de qtile

    Key([], "XF86AudioMute", lazy.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), desc="Silencio - Mute"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.0"), desc="Bajar Volumen - Volume down"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0"), desc="Subir Volumen - Volume up"),
#   Estos con wpctl funcionan con wireplumber
#   visto en la wiki de sway
#   https://github.com/swaywm/sway/wiki


    # estas teclas son para pulseaudio - yo uso pipewire
    # se debe instalar alsa-utils para que sirva el comando amixer
    # Key([], "XF86AudioRaiseVolume", lazy.spawn("pactl set-sink-volume 0 +5%"), desc='Volume Up'),
    # Key([], "XF86AudioLowerVolume", lazy.spawn("pactl set-sink-volume 0 -5%"), desc='volume down'),
    # Key([], "XF86AudioMute", lazy.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle"), desc='Volume Mute'),

#   se debe installar playerctl
    Key([], "XF86AudioPlay", lazy.spawn("playerctl play-pause"), desc='playerctl'),
    Key([], "XF86AudioPrev", lazy.spawn("playerctl previous"), desc='playerctl'),
    Key([], "XF86AudioNext", lazy.spawn("playerctl next"), desc='playerctl'),


#   se debe instalar brightnessctl
    Key([], "XF86MonBrightnessUp", lazy.spawn("brightnessctl s 5%+"), desc='brightness UP'),
    Key([], "XF86MonBrightnessDown", lazy.spawn("brightnessctl s 5%-"), desc='brightness Down'),

##Misc keybinds
    Key([], "Print", lazy.spawn("xfce4-screenshooter"), desc='Screenshot'),
    # Key(["control"], "Print", lazy.spawn("flameshot full -c -p ~/Pictures/"), desc='Screenshot'),
    Key([mod], "e", lazy.spawn(filemanager), desc="Open file manager"),
    Key([mod], "s",toggle_sticky_windows(), desc="Toggle state of sticky for current window"),


#########################
#   wlogout para apagar - reiniciar - salir

    Key([mod, "Shift"], "x", lazy.spawn(wlogout), desc="Launch wlogout"),


#########################
#   script de rofi para apagar - reiniciar - salir

    Key([mod, "mod1"], "x", lazy.spawn("powermenu-total"), desc="Launch rofi script"),



# ver las ventanas que están abiertas
# similar a la clásica alt + tab
    Key([mod, "mod1"], "Tab", lazy.spawn("rofi -show-icons -show window -theme rounded-green-dark"), desc="Spawn a command using a prompt widget"),



]

# fin de los atajos de teclado


####################################################
# groups son los espacios de trabajo
# modifico la opción para que el foco no se vaya
# al espacio de trabajo en caso que lo necesite
# no me gusta la opción que trae por defecto


# █▀▀ █▀█ █▀█ █░█ █▀█ █▀
# █▄█ █▀▄ █▄█ █▄█ █▀▀ ▄█


groups = [Group(i) for i in "1234567890abc"]

for i in groups:
    keys.extend(
        [
            # mod + group number = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc=f"Switch to group {i.name}",
            ),
            # mod + shift + group number = switch to & move focused window to group
            # Key(
            #     [mod, "shift"],
            #     i.name,
            #     lazy.window.togroup(i.name, switch_group=True),
            ##    desc=f"Switch to & move focused window to group {i.name}",
            # ),


            # Or, use below if you prefer not to switch to that group.
            # # mod + shift + group number = move focused window to group
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name)),
        ]
    )





####################################################
###𝙇𝙖𝙮𝙤𝙪𝙩###

layouts = [
    layout.Columns(
        margin = 0,
        border_focus = '#00DC6C',
        border_normal = '#1F1D2E',
        border_width = 3,
    ),

    layout.Max(
        border_focus = '#00DC6C',
        border_normal = '#1F1D2E',
        margin = 0,
        border_width = 0,
    ),


    layout.Floating(
        border_focus = '#00DC6C',
        border_normal = '#1F1D2E',
        margin = 0,
        border_width = 3,
    ),
   #  Try more layouts by unleashing below layouts
   #  layout.Stack(num_stacks=2),
   #  layout.Bsp(),
     layout.Matrix(
        border_focus = '#00DC6C',
        border_normal = '#1F1D2E',
        margin = 0,
        border_width = 3,
    ),

    layout.MonadWide(
        border_focus = '#00DC6C',
        border_normal = '#1F1D2E',
        margin = 0,
        border_width = 3,
    ),

    layout.Tile(
        border_focus = '#00DC6C',
        border_normal = '#1F1D2E',
        margin = 0,
        border_width = 3,
    ),
   #  layout.TreeTab(),
   #  layout.VerticalTile(),
   #  layout.Zoomy(),
]


####################################################




widget_defaults = dict(
    font = "sans bold",
    fontsize = 10,
    padding = 1,
)
extension_defaults = [ widget_defaults.copy()]


####################################################
# estas" def" se usan en la configuración de la barra que sigue

def open_launcher():
    qtile.cmd_spawn("rofi -show-icons -theme rounded-green-dark -show drun")

def open_btop():
    qtile.cmd_spawn("alacritty --hold -e btop")

# def open_power():
#     qtile.cmd_spawn("wlogout")

def open_power():
    qtile.cmd_spawn("powermenu-total")


# █▄▄ ▄▀█ █▀█
# █▄█ █▀█ █▀▄





screens = [


##############################################################
##  fake screen 1 - pantalla interna del portatil
##############################################################
##
####################################################
    Screen(
        top = bar.Bar(
            [
                ##############
                widget.Image(
                    filename = '~/.config/qtile/Assets/3.png',
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/launch_Icon.png',
                    background = '#033C4B',
                    mouse_callbacks = {'Button1': open_launcher},
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/6.png',
                ),

                ###############

                widget.GroupBox(
                    fontsize = 14,
                    borderwidth = 1,
                    highlight_method = 'block',
                    active = '#56D9C7', #Active workspaces circle color
                    block_highlight_text_color = "#00F076", #Current workspace circle color
                    highlight_color = '#4B427E',
                    inactive = '#052A25', #Empty workspace circle
                    foreground = '#046F5F',
                    background = '#046F5F',
                    this_current_screen_border = '#00361A', #Circle background color
                    this_screen_border = '#52548D',
                    other_current_screen_border = '#52548D',
                    other_screen_border = '#52548D',
                    urgent_border = '#52548D',
                    rounded = True,
                    disable_drag = True,
                 ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/5.png',
                ),

                ###############

                widget.Image(
                    filename = '~/.config/qtile/Assets/2.png',
                ),

                widget.CurrentLayoutIcon(
                    background = '#046F5F',
                    padding = 2,
                    scale = 0.5,
                ),

                widget.CurrentLayout(
                    background ='#046F5F',
                    padding = 0,
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/5.png',
                ),

                ###############

                widget.Image(
                    filename = '~/.config/qtile/Assets/2.png',
                ),

                widget.WindowName(
                    background = '#046F5F',
                    format = "{name}",
                    empty_group_string = 'Desktop',
                    padding = 0,
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/5.png',
                ),

                ###############

                widget.Image(
                    filename = '~/.config/qtile/Assets/1.png',
                    background = '#52548D',
                ),

                widget.CPU(
                    format='CPU:({load_percent:.1f}%/{freq_current}GHz)',
                    margin = 1,
                    padding = 1,
                    background = '#046F5F',
                    mouse_callbacks = {'Button1': open_btop},
                ),

                widget.Spacer(
                    length = 6,
                    background = '#046f5f',
                ),

                widget.Memory(
                    format = 'RAM:({MemUsed:.0f}MB/{MemTotal:.0f}MB)',
                    padding = 0,
                    background = '#046F5F',
                    mouse_callbacks = {'Button1': open_btop},
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/5.png',
                ),

                ###############

                widget.Image(
                    filename = '~/.config/qtile/Assets/2.png',
                    background = '#52548D',
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/Bar-Icons/volume.svg',
                    background = '#046F5F',
                    margin_y = 3,
                    scale = True,
                    mouse_callbacks = {'Button1': open_btop},
                ),

                widget.Spacer(
                    length = 4,
                    background = '#046f5f',
                ),

                widget.Volume(
                    padding = 0,
                    background = '#046F5F',
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/5.png',
                ),

                ###############

                widget.Image(
                    filename = '~/.config/qtile/Assets/1.png',
                    background = '#4B427E',
                ),


                widget.Clock(
                    format = '%d/%m/%y ', #Here you can change between USA or another timezone
                    background = '#046f5f',
                    padding = 0,
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/Bar-Icons/calendar.svg',
                    background = '#046F5F',
                    margin_y = 3,
                    margin_x = 5,
                    scale = True,
                ),

                widget.Clock(
                    format = '%H:%M',
                    background = '#046f5f',
                    padding = 0,
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/5.png',
                    background = '#4B427E',
                ),

                ###############


                widget.Image(
                    filename = '~/.config/qtile/Assets/2.png',
                    background = '#52548D',
                ),

                widget.Systray(
                    background = '#046F5F',
                    icon_size = 14,
                    padding = 2,
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/5.png',
                ),




                ###############

                widget.Image(
                    filename = '~/.config/qtile/Assets/Bar-Icons/shutdown.svg',
                    background = '#FF0000',
                    margin_y = 3,
                    margin_x = 5,
                    scale = True,
                    mouse_callbacks = {'Button1': open_power},
                ),





                ###############

                # Batería de un laptop
                widget.Spacer(
                    length = 18,
                    background = '#046f5f',
                ),
                widget.BatteryIcon(),
                widget.Battery(background = '#046f5f'),

                widget.Image(
                    filename = '~/.config/qtile/Assets/5.png',
                    background = '#4B427E',
                ),








            ],
            30,  # Bar size (all axis)
            margin = [2,4,2,4] # Bar margin (Top,Right,Bottom,Left)
        ),


    ),



# pantalla externa
#########################################
####################################################
    Screen(
        top = bar.Bar(
            [
                ##############
                widget.Image(
                    filename = '~/.config/qtile/Assets/3.png',
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/launch_Icon.png',
                    background = '#033C4B',
                    mouse_callbacks = {'Button1': open_launcher},
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/6.png',
                ),

                ###############

                widget.GroupBox(
                    fontsize = 14,
                    borderwidth = 1,
                    highlight_method = 'block',
                    active = '#56D9C7', #Active workspaces circle color
                    block_highlight_text_color = "#00F076", #Current workspace circle color
                    highlight_color = '#4B427E',
                    inactive = '#052A25', #Empty workspace circle
                    foreground = '#046F5F',
                    background = '#046F5F',
                    this_current_screen_border = '#00361A', #Circle background color
                    this_screen_border = '#52548D',
                    other_current_screen_border = '#52548D',
                    other_screen_border = '#52548D',
                    urgent_border = '#52548D',
                    rounded = True,
                    disable_drag = True,
                 ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/5.png',
                ),

                ###############

                widget.Image(
                    filename = '~/.config/qtile/Assets/2.png',
                ),

                widget.CurrentLayoutIcon(
                    background = '#046F5F',
                    padding = 2,
                    scale = 0.5,
                ),

                widget.CurrentLayout(
                    background ='#046F5F',
                    padding = 0,
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/5.png',
                ),

                ###############

                widget.Image(
                    filename = '~/.config/qtile/Assets/2.png',
                ),

                widget.WindowName(
                    background = '#046F5F',
                    format = "{name}",
                    empty_group_string = 'Desktop',
                    padding = 0,
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/5.png',
                ),

                ###############

                widget.Image(
                    filename = '~/.config/qtile/Assets/1.png',
                    background = '#52548D',
                ),

                widget.CPU(
                    format='CPU:({load_percent:.1f}%/{freq_current}GHz)',
                    margin = 1,
                    padding = 1,
                    background = '#046F5F',
                    mouse_callbacks = {'Button1': open_btop},
                ),

                widget.Spacer(
                    length = 6,
                    background = '#046f5f',
                ),

                widget.Memory(
                    format = 'RAM:({MemUsed:.0f}MB/{MemTotal:.0f}MB)',
                    padding = 0,
                    background = '#046F5F',
                    mouse_callbacks = {'Button1': open_btop},
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/5.png',
                ),

                ###############

                widget.Image(
                    filename = '~/.config/qtile/Assets/2.png',
                    background = '#52548D',
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/Bar-Icons/volume.svg',
                    background = '#046F5F',
                    margin_y = 3,
                    scale = True,
                    mouse_callbacks = {'Button1': open_btop},
                ),

                widget.Spacer(
                    length = 4,
                    background = '#046f5f',
                ),

                widget.Volume(
                    padding = 0,
                    background = '#046F5F',
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/5.png',
                ),

                ###############

                widget.Image(
                    filename = '~/.config/qtile/Assets/1.png',
                    background = '#4B427E',
                ),


                widget.Clock(
                    format = '%d/%m/%y ', #Here you can change between USA or another timezone
                    background = '#046f5f',
                    padding = 0,
                ),

                widget.Image(
                    filename = '~/.config/qtile/Assets/Bar-Icons/calendar.svg',
                    background = '#046F5F',
                    margin_y = 3,
                    margin_x = 5,
                    scale = True,
                ),

                widget.Clock(
                    format = '%H:%M',
                    background = '#046f5f',
                    padding = 0,
                ),

                # Batería de un laptop
                widget.Spacer(
                    length = 18,
                    background = '#046f5f',
                ),
                widget.BatteryIcon(),
                widget.Battery(background = '#046f5f'),

                widget.Image(
                    filename = '~/.config/qtile/Assets/5.png',
                    background = '#4B427E',
                ),

                ###############

                widget.Image(
                    filename = '~/.config/qtile/Assets/Bar-Icons/shutdown.svg',
                    background = '#FF0000',
                    margin_y = 3,
                    margin_x = 5,
                    scale = True,
                    mouse_callbacks = {'Button1': open_power},
                ),


            ],
            30,  # Bar size (all axis)
            margin = [2,4,2,4] # Bar margin (Top,Right,Bottom,Left)
        ),


    ),



#####################################################33





#  aqui irian más screens
##########################



]


######################################################################
#  fin de las pantallas
######################################################################




# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False #This basically puts your mouse in the center on the screen after you switch to another workspace
floating_layout = layout.Floating(
	border_focus='#00DC6C',
	border_normal='#1F1D2E',
	border_width=3,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)



auto_fullscreen = True
focus_on_window_activation = "smart" #or focus
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"



###########################################################################
#  Adicionales
###########################################################################
#  HOOK STARTUP
#  Se necesitan unas librerías que están al comienzo del archivo
#  por ahora solo he creado el archivo autostart_x1.sh
#  Aun no he probado Qtile en Wayland

@hook.subscribe.startup_once
def autostart():
    if qtile.core.name == "x11":
        autostartscript = "~/.config/qtile/autostart_x11.sh"
    elif qtile.core.name == "wayland":
        autostartscript = "~/.config/qtile/autostart_wayland.sh"

    home = os.path.expanduser(autostartscript)
    subprocess.Popen([home])

###########################################################################
