-- Naseem OS - Hyprland config (Lua format, Hyprland 0.57+)

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })

hl.env("XCURSOR_THEME", "WhiteSur-cursors")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")

hl.config({
    general = {
        gaps_in     = 10,
        gaps_out    = 22,
        border_size = 1,
        col = {
            active_border   = "rgba(ffffff3d)",
            inactive_border = "rgba(ffffff12)",
        },
        resize_on_border = true,
        layout = "dwindle",
    },
    decoration = {
        rounding         = 14,
        rounding_power   = 2.4,
        active_opacity   = 1.0,
        inactive_opacity = 0.96,
        shadow = { enabled = true, range = 22, render_power = 3, color = 0x66000000 },
        blur   = { enabled = true, size = 8, passes = 3, new_optimizations = true, ignore_opacity = true },
    },
    animations = { enabled = true },
    dwindle    = { preserve_split = true },
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = { natural_scroll = true },
    },
    misc = {
        disable_hyprland_logo = true,
        force_default_wallpaper = 0,
        focus_on_activate = true,
        vfr = true,
    },
})

hl.curve("naseem",     { type = "bezier", points = { {0.25, 0.1}, {0.25, 1} } })
hl.curve("naseem_out", { type = "bezier", points = { {0.4, 0.0}, {1, 1} } })

hl.animation({ leaf = "global",     enabled = true, speed = 8,   bezier = "default" })
hl.animation({ leaf = "windows",    enabled = true, speed = 4.6, bezier = "naseem",     style = "popin 88%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.4, bezier = "naseem_out", style = "popin 92%" })
hl.animation({ leaf = "fade",       enabled = true, speed = 3.6, bezier = "naseem" })
hl.animation({ leaf = "fadeOut",    enabled = true, speed = 2.6, bezier = "naseem_out" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.8, bezier = "naseem",     style = "slidefade 20%" })
hl.animation({ leaf = "layers",     enabled = true, speed = 3.2, bezier = "naseem" })
hl.animation({ leaf = "border",     enabled = true, speed = 6,   bezier = "naseem" })

for _, ns in ipairs({
    "waybar",
    "mako",
    "fuzzel",
    "nwg%-drawer",
    "nwg%-dock%-hyprland",
    "notifications",
}) do
    hl.layer_rule({ match = { namespace = ns }, blur = true })
end

hl.on("hyprland.start", function()
    hl.exec_cmd("swaybg -i /home/nasim/Pictures/wallpaper.png -m fill")
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("nwg-dock-hyprland -i 48 -p bottom -mb 12")
end)

local mod = "SUPER"

hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("foot"))
hl.bind(mod .. " + SPACE",  hl.dsp.exec_cmd("fuzzel"))
hl.bind(mod .. " + Q",      hl.dsp.window.close())
hl.bind(mod .. " + A",      hl.dsp.exec_cmd("nwg-drawer -wm hyprland -c 6 -is 56 -mt 60 -mb 60 -ml 60 -mr 60"))
hl.bind(mod .. " + I",      hl.dsp.exec_cmd("naseem-install"))
hl.bind(mod .. " + C",      hl.dsp.exec_cmd("naseem-control"))
hl.bind(mod .. " + N",      hl.dsp.exec_cmd("makoctl dismiss --all"))
hl.bind(mod .. " + L",      hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd("naseem-shot"))
hl.bind("PRINT",            hl.dsp.exec_cmd("naseem-shot full"))
hl.bind(mod .. " + SLASH",  hl.dsp.exec_cmd("foot --title=Keybinds less /home/nasim/.config/naseem/keybinds.txt"))
hl.bind(mod .. " + F",      hl.dsp.window.fullscreen())
hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())

for i = 1, 5 do
    hl.bind(mod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("naseem-volume up"),   { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("naseem-volume down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("naseem-volume mute"), { locked = true, repeating = true })
