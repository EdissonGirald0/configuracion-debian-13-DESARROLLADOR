/* DWM Configuration for Developers
 * Optimizada para workflows de desarrollo con:
 * - Múltiples workspaces organizados
 * - Atajos específicos para herramientas de desarrollo
 * - Layouts optimizados para programación
 * - Integración con herramientas modernas
 */

#ifndef CONFIG_H
#define CONFIG_H
#include "./dwm.h"
#include "./exitdwm.h"

/* ===== CONFIGURACIÓN VISUAL ===== */
static const unsigned int borderpx = 2;        /* border pixel of windows */
static const unsigned int gappx = 6;           /* gaps between windows - más espacio para lectura */
static const unsigned int snap = 16;           /* snap pixel - más sensible para programación */

/* Systray configuration */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft = 0;    /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 1;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray = 1;               /* 0 means no systray */

static const int showbar = 1;                   /* 0 means no bar */
static const int topbar = 1;                    /* 0 means bottom bar */

/* Fuentes optimizadas para programación */
static const char *fonts[] = { 
    "JetBrains Mono Nerd Font:size=11:weight=medium",
    "Font Awesome 6 Free:size=10:weight=solid",
    "Noto Color Emoji:size=10"
};
static const char dmenufont[] = "JetBrains Mono Nerd Font:size=11";

/* ===== ESQUEMAS DE COLOR PARA DESARROLLO ===== */
struct Theme {
    const char *inactive;
    const char *active; 
    const char *bg;
    const char *focus;
};

/* One Dark Theme - Popular entre desarrolladores */
static const struct Theme onedark = {
    .inactive = "#5c6370",
    .active = "#abb2bf", 
    .bg = "#282c34",
    .focus = "#61afef",
};

/* Visual Studio Code Dark Theme */
static const struct Theme vscode_dark = {
    .inactive = "#3c3c3c",
    .active = "#cccccc",
    .bg = "#1e1e1e", 
    .focus = "#007acc",
};

/* Material Theme */
static const struct Theme material = {
    .inactive = "#546e7a",
    .active = "#eeffff",
    .bg = "#263238",
    .focus = "#82aaff",
};

/* GitHub Dark Theme */  
static const struct Theme github_dark = {
    .inactive = "#6e7681",
    .active = "#f0f6fc",
    .bg = "#0d1117",
    .focus = "#58a6ff",
};

/* Tema activo - cambiar aquí para usar otro tema */
static const struct Theme *current_theme = &onedark;

/* Colores basados en el tema seleccionado */
static const char col_gray1[] = "#222222";      /* background */
static const char col_gray2[] = "#444444";      /* inactive window border */
static const char col_gray3[] = "#bbbbbb";      /* font color */
static const char col_gray4[] = "#eeeeee";      /* current tag and current window font color */
static const char col_cyan[] = "#61afef";       /* Top bar second color and active window border color */

static const char *colors[][3] = {
    /*                     fg         bg         border   */
    [SchemeNorm]       = { current_theme->active, current_theme->bg, current_theme->inactive },
    [SchemeSel]        = { current_theme->bg, current_theme->focus, current_theme->focus },
    [SchemeStatus]     = { current_theme->active, current_theme->bg, "#000000" }, // Statusbar right {text,background,not used but cannot be empty}
    [SchemeTagsSel]    = { current_theme->bg, current_theme->focus, "#000000" }, // Tagbar left selected {text,background,not used but cannot be empty}
    [SchemeTagsNorm]   = { current_theme->active, current_theme->bg, "#000000" }, // Tagbar left unselected {text,background,not used but cannot be empty}
    [SchemeInfoSel]    = { current_theme->bg, current_theme->focus, "#000000" }, // Infobar middle selected {text,background,not used but cannot be empty}
    [SchemeInfoNorm]   = { current_theme->active, current_theme->bg, "#000000" }, // Infobar middle unselected {text,background,not used but cannot be empty}
};

/* ===== TAGS ORGANIZADOS PARA DESARROLLO ===== */
/* Unicode icons for different development contexts */
static const char *tags[] = { 
    "󰈹",  /* 1: Home/General */
    "󰈹",  /* 2: Browser/Research */  
    "",  /* 3: Code/Editor */
    "",  /* 4: Terminal */
    "󰆍",  /* 5: Database */
    "",  /* 6: Docker/Containers */
    "",  /* 7: Communication */
    "󰋋",  /* 8: Files */
    "󰍉"   /* 9: Media/Spotify */
};

/* ===== REGLAS DE VENTANAS PARA APLICACIONES DE DESARROLLO ===== */
static const Rule rules[] = {
    /* xprop(1):
     *  WM_CLASS(STRING) = instance, class
     *  WM_NAME(STRING) = title
     */
    /* class              instance    title       tags mask     isfloating   monitor */
    
    /* Navegadores - Tag 2 */
    { "Firefox",          NULL,       NULL,       1 << 1,       0,           -1 },
    { "Chromium",         NULL,       NULL,       1 << 1,       0,           -1 },
    { "Google-chrome",    NULL,       NULL,       1 << 1,       0,           -1 },
    
    /* IDEs y Editores - Tag 3 */ 
    { "Code",             NULL,       NULL,       1 << 2,       0,           -1 },
    { "code-oss",         NULL,       NULL,       1 << 2,       0,           -1 },
    { "Sublime_text",     NULL,       NULL,       1 << 2,       0,           -1 },
    { "jetbrains-pycharm-ce", NULL,   NULL,       1 << 2,       0,           -1 },
    { "jetbrains-idea-ce", NULL,      NULL,       1 << 2,       0,           -1 },
    { "Neovim",           NULL,       NULL,       1 << 2,       0,           -1 },
    
    /* Terminales - Tag 4 */
    { "Alacritty",        NULL,       NULL,       1 << 3,       0,           -1 },
    { "Terminator",       NULL,       NULL,       1 << 3,       0,           -1 },
    { "kitty",            NULL,       NULL,       1 << 3,       0,           -1 },
    
    /* Bases de datos - Tag 5 */
    { "DBeaver",          NULL,       NULL,       1 << 4,       0,           -1 },
    { "Mysql-workbench-bin", NULL,    NULL,       1 << 4,       0,           -1 },
    { "pgAdmin4",         NULL,       NULL,       1 << 4,       0,           -1 },
    
    /* Docker y contenedores - Tag 6 */
    { "Docker Desktop",   NULL,       NULL,       1 << 5,       0,           -1 },
    
    /* Comunicación - Tag 7 */
    { "Slack",            NULL,       NULL,       1 << 6,       0,           -1 },
    { "Discord",          NULL,       NULL,       1 << 6,       0,           -1 },
    { "TelegramDesktop",  NULL,       NULL,       1 << 6,       0,           -1 },
    { "Zoom",             NULL,       NULL,       1 << 6,       0,           -1 },
    
    /* Gestores de archivos - Tag 8 */
    { "Thunar",           NULL,       NULL,       1 << 7,       0,           -1 },
    { "Nautilus",         NULL,       NULL,       1 << 7,       0,           -1 },
    { "Pcmanfm",          NULL,       NULL,       1 << 7,       0,           -1 },
    
    /* Media - Tag 9 */
    { "Spotify",          NULL,       NULL,       1 << 8,       0,           -1 },
    { "vlc",              NULL,       NULL,       1 << 8,       0,           -1 },
    { "mpv",              NULL,       NULL,       1 << 8,       0,           -1 },
    
    /* Ventanas flotantes - Herramientas de desarrollo */
    { "Arandr",           NULL,       NULL,       0,            1,           -1 }, // Monitor config
    { "Lxappearance",     NULL,       NULL,       0,            1,           -1 }, // Theme config  
    { "Nitrogen",         NULL,       NULL,       0,            1,           -1 }, // Wallpaper
    { "Pavucontrol",      NULL,       NULL,       0,            1,           -1 }, // Audio
    { "Blueman-manager",  NULL,       NULL,       0,            1,           -1 }, // Bluetooth
    { "Galculator",       NULL,       NULL,       0,            1,           -1 }, // Calculator
    { "Gpick",            NULL,       NULL,       0,            1,           -1 }, // Color picker
    
    /* Diálogos de Git y herramientas */
    { "Gitk",             NULL,       NULL,       0,            1,           -1 },
    { "Git-gui",          NULL,       NULL,       0,            1,           -1 },
    { "Pinentry-gtk-2",   NULL,       NULL,       0,            1,           -1 }, // GPG dialogs
    
    /* VirtualBox y VMs */
    { "VirtualBox Manager", NULL,     NULL,       0,            1,           -1 },
    { "VirtualBox Machine", NULL,     NULL,       0,            1,           -1 },
};

/* ===== LAYOUTS OPTIMIZADOS PARA DESARROLLO ===== */
static const float mfact = 0.6;    /* factor of master area size [0.05..0.95] - más ancho para código */
static const int nmaster = 1;      /* number of clients in master area */
static const int resizehints = 0;  /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
    /* symbol     arrange function */
    { "[T]",      tile },    /* Tiling - Principal para código */
    { "[M]",      monocle }, /* Monocle - Para concentrarse en una sola ventana */  
    { "[F]",      NULL },    /* Floating - Para herramientas y diálogos */
    { "[D]",      deck },    /* Deck - Stack de ventanas con una principal */
    { "[S]",      spiral },  /* Spiral - Distribución en espiral */
    { "[G]",      grid },    /* Grid - Para monitorear múltiples terminales */
};

/* ===== COMANDOS Y APLICACIONES ===== */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* Terminal principal y alternativo */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { 
    "dmenu_run", 
    "-m", dmenumon, 
    "-fn", dmenufont, 
    "-nb", current_theme->bg, 
    "-nf", current_theme->active, 
    "-sb", current_theme->focus, 
    "-sf", current_theme->bg, 
    "-i", /* case insensitive */
    NULL 
};

/* Rofi como alternativa moderna a dmenu */
static const char *roficmd[] = { 
    "rofi", "-show", "drun", 
    "-show-icons", 
    "-theme", "Monokai", 
    NULL 
};

/* Terminales */
static const char *termcmd[] = { "alacritty", NULL };
static const char *termaltcmd[] = { "terminator", NULL };
static const char *termfloatcmd[] = { "xterm", NULL };

/* Navegadores */
static const char *browsercmd[] = { "firefox", NULL };
static const char *browseraltcmd[] = { "chromium", NULL };

/* Editores e IDEs */
static const char *editorcmd[] = { "code", NULL };
static const char *nvimcmd[] = { "alacritty", "-e", "nvim", NULL };
static const char *pycharmcmd[] = { "flatpak", "run", "org.jetbrains.PyCharm-Community", NULL };
static const char *ideacmd[] = { "flatpak", "run", "com.jetbrains.IntelliJ-IDEA-Community", NULL };

/* Herramientas de desarrollo */
static const char *gitguicmd[] = { "git-gui", NULL };
static const char *gitkgitkcmd[] = { "gitk", NULL };
static const char *dbeavercmd[] = { "flatpak", "run", "org.dbeaver.DBeaverCommunity", NULL };
static const char *postmancmd[] = { "flatpak", "run", "io.postman.Postman", NULL };

/* Gestores de archivos */
static const char *filecmd[] = { "thunar", NULL };
static const char *rangercmd[] = { "alacritty", "-e", "ranger", NULL };

/* Herramientas del sistema */
static const char *htopcmd[] = { "alacritty", "-e", "htop", NULL };
static const char *btopcmd[] = { "alacritty", "-e", "btop", NULL };

/* Screenshots */
static const char *screenshotcmd[] = { "xfce4-screenshooter", NULL };
static const char *screenshotareacmd[] = { "xfce4-screenshooter", "-r", NULL };
static const char *screenshotwindowcmd[] = { "xfce4-screenshooter", "-w", NULL };

/* Power menu */
static const char *powermenucmd[] = { "powermenu-total", NULL };
static const char *wlogoutcmd[] = { "wlogout", NULL };

/* Control multimedia */
static const char *mutecmd[] = { "wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle", NULL };
static const char *volupcmd[] = { "wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%+", NULL };
static const char *voldowncmd[] = { "wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-", NULL };
static const char *playpausecmd[] = { "playerctl", "play-pause", NULL };
static const char *nextcmd[] = { "playerctl", "next", NULL };
static const char *prevcmd[] = { "playerctl", "previous", NULL };

/* Control de brillo */
static const char *brightupcmd[] = { "brightnessctl", "s", "5%+", NULL };
static const char *brightdowncmd[] = { "brightnessctl", "s", "5%-", NULL };

/* Comandos específicos de desarrollo */
static const char *dockerpscmd[] = { "alacritty", "-e", "sh", "-c", "docker ps; read", NULL };
static const char *dockerimagescmd[] = { "alacritty", "-e", "sh", "-c", "docker images; read", NULL };
static const char *kubectlcmd[] = { "alacritty", "-e", "sh", "-c", "kubectl get pods; read", NULL };
static const char *gitstatus[] = { "alacritty", "-e", "sh", "-c", "cd ~/Development/projects && git status; read", NULL };

/* ===== ATAJOS DE TECLADO OPTIMIZADOS PARA DESARROLLO ===== */
#define MODKEY Mod4Mask  /* Super/Windows key como principal */
#define ALTKEY Mod1Mask  /* Alt key */

static Key keys[] = {
    /* ===== APLICACIONES BÁSICAS ===== */
    /* modifier                     key        function        argument */
    { MODKEY,                       XK_d,      spawn,          {.v = dmenucmd } },          // dmenu
    { MODKEY,                       XK_r,      spawn,          {.v = roficmd } },           // rofi  
    { MODKEY,                       XK_Return, spawn,          {.v = termcmd } },           // terminal principal
    { MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termaltcmd } },        // terminal alternativo
    { MODKEY|ControlMask,           XK_Return, spawn,          {.v = termfloatcmd } },      // terminal flotante
    
    /* ===== NAVEGADORES ===== */
    { MODKEY,                       XK_b,      spawn,          {.v = browsercmd } },        // Firefox
    { MODKEY|ShiftMask,             XK_b,      spawn,          {.v = browseraltcmd } },     // Chromium
    
    /* ===== EDITORES E IDES ===== */
    { MODKEY,                       XK_e,      spawn,          {.v = editorcmd } },         // VS Code
    { MODKEY|ShiftMask,             XK_e,      spawn,          {.v = nvimcmd } },           // Neovim
    { MODKEY,                       XK_p,      spawn,          {.v = pycharmcmd } },        // PyCharm
    { MODKEY,                       XK_i,      spawn,          {.v = ideacmd } },           // IntelliJ IDEA
    
    /* ===== HERRAMIENTAS DE DESARROLLO ===== */
    { MODKEY,                       XK_g,      spawn,          {.v = gitguicmd } },         // Git GUI
    { MODKEY|ShiftMask,             XK_g,      spawn,          {.v = gitkgitkcmd } },       // Gitk
    { MODKEY,                       XK_BackSpace, spawn,       {.v = dbeavercmd } },        // DBeaver
    { MODKEY,                       XK_a,      spawn,          {.v = postmancmd } },        // Postman
    
    /* ===== GESTORES DE ARCHIVOS ===== */
    { MODKEY,                       XK_f,      spawn,          {.v = filecmd } },           // Thunar
    { MODKEY|ShiftMask,             XK_f,      spawn,          {.v = rangercmd } },         // Ranger
    
    /* ===== MONITOREO DEL SISTEMA ===== */
    { MODKEY,                       XK_m,      spawn,          {.v = htopcmd } },           // htop
    { MODKEY|ShiftMask,             XK_m,      spawn,          {.v = btopcmd } },           // btop
    
    /* ===== COMANDOS ESPECÍFICOS DE DESARROLLO ===== */
    { MODKEY,                       XK_o,      spawn,          {.v = dockerpscmd } },       // Docker ps
    { MODKEY|ShiftMask,             XK_o,      spawn,          {.v = dockerimagescmd } },   // Docker images
    { MODKEY,                       XK_k,      spawn,          {.v = kubectlcmd } },        // kubectl
    { MODKEY,                       XK_s,      spawn,          {.v = gitstatus } },         // Git status en proyectos
    
    /* ===== SCREENSHOTS ===== */
    { 0,                            XK_Print,  spawn,          {.v = screenshotcmd } },     // Screenshot
    { ShiftMask,                    XK_Print,  spawn,          {.v = screenshotareacmd } }, // Screenshot área
    { ControlMask,                  XK_Print,  spawn,          {.v = screenshotwindowcmd }}, // Screenshot ventana
    
    /* ===== NAVEGACIÓN DE VENTANAS ===== */
    { MODKEY,                       XK_j,      focusstack,     {.i = +1 } },               // Focus siguiente
    { MODKEY,                       XK_k,      focusstack,     {.i = -1 } },               // Focus anterior
    { MODKEY,                       XK_Down,   focusstack,     {.i = +1 } },               // Focus siguiente (flecha)
    { MODKEY,                       XK_Up,     focusstack,     {.i = -1 } },               // Focus anterior (flecha)
    
    /* Mover ventanas */
    { MODKEY|ShiftMask,             XK_j,      movestack,      {.i = +1 } },               // Mover abajo
    { MODKEY|ShiftMask,             XK_k,      movestack,      {.i = -1 } },               // Mover arriba  
    { MODKEY|ShiftMask,             XK_Down,   movestack,      {.i = +1 } },               // Mover abajo (flecha)
    { MODKEY|ShiftMask,             XK_Up,     movestack,      {.i = -1 } },               // Mover arriba (flecha)
    
    /* Redimensionar */
    { MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },             // Reducir master
    { MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },             // Aumentar master
    { MODKEY,                       XK_Left,   setmfact,       {.f = -0.05} },             // Reducir master (flecha)
    { MODKEY,                       XK_Right,  setmfact,       {.f = +0.05} },             // Aumentar master (flecha)
    
    /* Master area */
    { MODKEY|ControlMask,           XK_h,      incnmaster,     {.i = +1 } },               // Más ventanas en master
    { MODKEY|ControlMask,           XK_l,      incnmaster,     {.i = -1 } },               // Menos ventanas en master
    
    /* ===== LAYOUTS ===== */
    { MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },       // Tiling
    { MODKEY,                       XK_y,      setlayout,      {.v = &layouts[1]} },       // Monocle
    { MODKEY,                       XK_u,      setlayout,      {.v = &layouts[2]} },       // Floating
    { MODKEY,                       XK_n,      setlayout,      {.v = &layouts[3]} },       // Deck
    { MODKEY,                       XK_c,      setlayout,      {.v = &layouts[4]} },       // Spiral
    { MODKEY,                       XK_x,      setlayout,      {.v = &layouts[5]} },       // Grid
    { MODKEY,                       XK_Tab,    setlayout,      {0} },                      // Toggle último layout
    
    /* ===== VENTANAS ===== */
    { MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },                      // Toggle floating
    { MODKEY,                       XK_space,  zoom,           {0} },                      // Zoom to master
    { MODKEY,                       XK_q,      killclient,     {0} },                      // Cerrar ventana
    { MODKEY,                       XK_F11,    togglefullscr,  {0} },                      // Fullscreen
    
    /* ===== TAGS/WORKSPACES ===== */
    { MODKEY,                       XK_0,      view,           {.ui = ~0 } },              // Ver todos los tags
    { MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },              // Mover a todos los tags
    { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },               // Monitor anterior
    { MODKEY,                       XK_period, focusmon,       {.i = +1 } },               // Monitor siguiente
    { MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },               // Mover ventana a monitor anterior
    { MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },               // Mover ventana a monitor siguiente
    
    /* ===== MULTIMEDIA ===== */
    { 0,                           XF86XK_AudioMute,          spawn, {.v = mutecmd } },
    { 0,                           XF86XK_AudioLowerVolume,   spawn, {.v = voldowncmd } },
    { 0,                           XF86XK_AudioRaiseVolume,   spawn, {.v = volupcmd } },
    { 0,                           XF86XK_AudioPlay,          spawn, {.v = playpausecmd } },
    { 0,                           XF86XK_AudioNext,          spawn, {.v = nextcmd } },
    { 0,                           XF86XK_AudioPrev,          spawn, {.v = prevcmd } },
    
    /* Brillo */
    { 0,                           XF86XK_MonBrightnessUp,    spawn, {.v = brightupcmd } },
    { 0,                           XF86XK_MonBrightnessDown,  spawn, {.v = brightdowncmd } },
    
    /* ===== SISTEMA ===== */
    { MODKEY|ControlMask,           XK_r,      quit,           {1} },                      // Restart DWM
    { MODKEY|ShiftMask,             XK_x,      spawn,          {.v = wlogoutcmd } },       // Power menu
    { MODKEY|ALTKEY,                XK_x,      spawn,          {.v = powermenucmd } },     // Rofi power menu
    { MODKEY|ControlMask,           XK_q,      quit,           {0} },                      // Quit DWM
};

/* ===== ATAJOS PARA TAGS/WORKSPACES ===== */
#define TAGKEYS(KEY,TAG) \
    { MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
    { MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
    { MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* Mapeo de teclas numéricas a tags */
TAGKEYS(                        XK_1,                      0)  /* Home */
TAGKEYS(                        XK_2,                      1)  /* Browser */
TAGKEYS(                        XK_3,                      2)  /* Code */
TAGKEYS(                        XK_4,                      3)  /* Terminal */
TAGKEYS(                        XK_5,                      4)  /* Database */
TAGKEYS(                        XK_6,                      5)  /* Docker */
TAGKEYS(                        XK_7,                      6)  /* Communication */
TAGKEYS(                        XK_8,                      7)  /* Files */
TAGKEYS(                        XK_9,                      8)  /* Media */

/* ===== BOTONES DEL MOUSE ===== */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
    /* click                event mask      button          function        argument */
    { ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
    { ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
    { ClkWinTitle,          0,              Button2,        zoom,           {0} },
    { ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
    { ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
    { ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
    { ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
    { ClkTagBar,            0,              Button1,        view,           {0} },
    { ClkTagBar,            0,              Button3,        toggleview,     {0} },
    { ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
    { ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

#endif /* CONFIG_H */
