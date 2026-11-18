# Naseem OS

Arch Linux + Hyprland, shipped as a ready-to-run VM image with a macOS-flavoured desktop.
Nothing is built locally: GitHub Actions builds, smoke-tests and publishes the image.

## Status

`v0.0.9` - macOS-like desktop on Arch: menu bar, dock, app grid, notifications, lock screen,
screenshots, control centre, app installer, `yay`, Flatpak, preinstalled browser/file manager.

## Download

Releases page: https://github.com/PanDuroDev/naseem-os/releases/latest

| File | Use with |
|------|----------|
| `naseem.vdi.xz` | VirtualBox - extract with 7-Zip, then attach the `.vdi` |
| `naseem.vmdk` | VMware Workstation / Player |
| `naseem.qcow2` | QEMU/KVM, virt-manager, Proxmox |

VirtualBox cannot boot the compressed `.vmdk` (black screen), so use the `.vdi`:
right click the `.xz`, 7-Zip -> Extract Here, then attach `naseem.vdi` as an existing disk.
All images are UEFI: enable EFI in the VM settings. Needs 4 GB RAM, 2 CPUs, ~16 GB disk.

## Default account

| | |
|---|---|
| user | `nasim` |
| password | `naseem` (also the lock screen password) |
| sudo | passwordless (`%wheel`) |

Login is automatic and Hyprland starts by itself. Change the password with `passwd`.

## Installing software

1. `Super+I` - menu of popular apps (Firefox, VLC, GIMP, LibreOffice, Steam, Discord,
   Spotify, ...). Pick one, it installs in a terminal window and reports with a notification.
2. Terminal: `sudo pacman -S <pkg>`, `yay -S <pkg>` for the AUR, `flatpak install flathub <id>`.
3. `nwg-look` changes the GTK theme from a GUI.

Already installed: Firefox, Nautilus (file manager), mpv, imv, Mousepad, foot, plus the desktop.

## Keybinds

Press `Super+/` inside the VM for the full list. The essentials:

| Keys | Action |
|------|--------|
| `Super+Return` | terminal (foot) |
| `Super+Space` | search apps / run a command (fuzzel) |
| `Super+A` | app grid / Launchpad |
| `Super+C` | control centre (wifi, DND, screenshot, lock, power) |
| `Super+I` | install an app |
| `Super+N` | clear notifications |
| `Super+L` | lock screen |
| `Super+Shift+S` | screenshot a region (saved and copied) |
| `Print` | screenshot the whole screen |
| `Super+Q` | close window |
| `Super+F` | fullscreen |
| `Super+1..5` | switch workspace |
| `Super+Shift+1..5` | move window to workspace |
| `Super+Shift+E` | exit Hyprland back to a text console |

## What works

- Hyprland starts automatically on tty1 through `start-hyprland`.
- Menu bar (Waybar): workspaces as dots, focused window, clock, notifications, tray,
  network, volume, battery.
- Dock (nwg-dock-hyprland), wallpaper, rounded corners, blur, shadows, window animations.
- App grid (nwg-drawer) on `Super+A`; app installer on `Super+I`.
- Notifications through mako, bell icon toggles do-not-disturb (`Super+N` clears).
- Lock screen (hyprlock) on `Super+L`, PAM configured for the user.
- Screenshots (grim + slurp + wl-clipboard), copied to the clipboard automatically.
- Control centre (fuzzel) on `Super+C`.
- macOS style window buttons for GTK apps (coloured dots on the left of the header bar).
- WhiteSur icons and cursors, Inter UI font, JetBrains Mono terminal font.
- NetworkManager, PipeWire, Flatpak + Flathub, multilib, `pacman` + `yay`, zram swap.
- `sshd` runs, so the VM is reachable with `ssh -p 2222 nasim@127.0.0.1` after a port forward.

## Configuration

The desktop config is Hyprland Lua format (`~/.config/hypr/hyprland.lua`), because Hyprland
0.57 dropped the ini file. Check edits before restarting the session:

```
Hyprland --verify-config
```

Other configs: `~/.config/waybar/`, `~/.config/mako/config`, `~/.config/hypr/hyprlock.conf`,
`~/.config/foot/foot.ini`, `~/.config/nwg-drawer/drawer.css`, `~/.config/gtk-*/gtk.css`.

## Troubleshooting

- **Black screen after boot, or Hyprland refuses to start** - the virtual GPU cannot do GPU
  rendering. Log into a text console with `Ctrl+Alt+F2` and try `WLR_RENDERER=pixman Hyprland`.
  On VirtualBox enable Display -> Enable 3D Acceleration.
- **VirtualBox stays on a black screen** - you attached the `.vmdk`. Use `naseem.vdi`.
- **No network** - `nmtui`.
- **Notifications do not appear** - `makoctl mode` should not print `do-not-disturb`.
- **Forgot the keybinds** - `Super+/`, or read `~/.config/naseem/keybinds.txt`.

## Build

Push to `main`, or run the workflow manually:

```
gh workflow run build.yml
gh run watch
```

Push a `v*` tag to publish the images to a GitHub Release:

```
gh api -X POST repos/PanDuroDev/naseem-os/git/refs -f ref=refs/tags/v0.0.9 -f sha=$(gh api repos/PanDuroDev/naseem-os/commits/main --jq .sha)
```

## Roadmap

- [x] bootable Arch + Hyprland image in CI
- [x] icons, cursors, fonts, dock, wallpaper, translucent menu bar, app grid
- [x] AUR helper, multilib, preinstalled apps, notifications, lock screen
- [x] screenshots, control centre, app installer, keybind cheatsheet
- [x] macOS style window buttons for GTK apps
- [ ] WhiteSur GTK theme (its installer forces a full system upgrade; needs a prebuilt theme)
- [ ] Omarchy package layer (install/update menu, defaults)
- [ ] ISO output
