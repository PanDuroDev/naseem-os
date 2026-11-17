-- Naseem OS - Hyprland config (Lua format, Hyprland 0.57+)

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })

hl.env("XCURSOR_THEME", "WhiteSur-cursors")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.config({
    general = {
        gaps_in     = 8,
        gaps_out    = 16,
        border_size = 1,
        col = {
            active_border   = "rgba(ffffff44)",
            inactive_border = "rgba(ffffff14)",
        },
        resize_on_border = true,
        layout = "dwindle",
    },
    decoration = {
        rounding         = 12,
        rounding_power   = 2,
        active_opacity   = 1.0,
        inactive_opacity = 0.97,
        shadow = { enabled = true, range = 18, render_power = 3, color = 0x55000000 },
        blur   = { enabled = true, size = 6, passes = 2, new_optimizations = true },
    },
    animations = { enabled = true },
    dwindle    = { pseudotile = true, preserve_split = true },
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        touchpad = { natural_scroll = true },
    },
    misc = {
        disable_hyprland_logo = true,
        force_default_wallpaper = 0,
        focus_on_activate = true,
    },
})

hl.curve("naseem", { type = "bezier", points = { {0.25, 0.1}, {0.25, 1} } })
hl.animation({ leaf = "global",     enabled = true, speed = 8,   bezier = "default" })
hl.animation({ leaf = "windows",    enabled = true, speed = 4.5, bezier = "naseem", style = "popin 90%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.5, bezier = "naseem", style = "popin 90%" })
hl.animation({ leaf = "fade",       enabled = true, speed = 3,   bezier = "naseem" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 3,   bezier = "naseem", style = "slidefade" })
hl.animation({ leaf = "layers",     enabled = true, speed = 3,   bezier = "naseem" })

hl.on("hyprland.start", function()
    hl.exec_cmd("swaybg -i /home/nasim/Pictures/wallpaper.png -m fill")
    hl.exec_cmd("waybar")
    hl.exec_cmd("nwg-dock-hyprland -i 44 -p bottom -mb 8")
end)

local mod = "SUPER"

hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("foot"))
hl.bind(mod .. " + SPACE",  hl.dsp.exec_cmd("fuzzel"))
hl.bind(mod .. " + Q",      hl.dsp.window.close())
hl.bind(mod .. " + A",      hl.dsp.exec_cmd("nwg-drawer -wm hyprland -c 6 -is 56 -mt 60 -mb 60 -ml 60 -mr 60"))
hl.bind(mod .. " + I",      hl.dsp.exec_cmd("naseem-install"))
hl.bind(mod .. " + SLASH",  hl.dsp.exec_cmd("foot --title=Keybinds less /home/nasim/.config/naseem/keybinds.txt"))
hl.bind(mod .. " + F",      hl.dsp.exec_cmd("hyprctl dispatch fullscreen 0"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("hyprctl dispatch exit"))

for i = 1, 5 do
    hl.bind(mod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })