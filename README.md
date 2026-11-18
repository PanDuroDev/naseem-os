# Naseem OS

Arch Linux + Hyprland, shipped as a ready-to-run VM image with a macOS-flavoured desktop.
Nothing is built on a local machine: GitHub Actions builds, smoke-tests and publishes the image.

## Status

`v0.0.8` - bootable base, macOS look (translucency, blur, rounded corners, wallpaper, menu bar,
dock, app grid, WhiteSur icons and cursors, Inter font), a working notification centre,
preinstalled apps, `yay` for AUR packages, multilib, and a one-click app installer on `Super+I`.

## Download

Releases page: https://github.com/PanDuroDev/naseem-os/releases/latest

| File | Use with |
|------|----------|
| `naseem.vdi.xz` | VirtualBox - unzip with 7-Zip, then attach the `.vdi` |
| `naseem.vmdk` | VMware Workstation / Player |
| `naseem.qcow2` | QEMU/KVM, virt-manager, Proxmox |

VirtualBox cannot boot the compressed `.vmdk` (it stays on a black screen), so use the
`.vdi`: right click the `.xz`, 7-Zip -> Extract Here, then attach `naseem.vdi` as an
existing hard disk.

All images are UEFI. In VirtualBox enable System -> Enable EFI before first boot.
Needs 4 GB RAM, 2 CPU cores and about 16 GB of disk.

## Default account

| | |
|---|---|
| user | `nasim` |
| password | `naseem` |
| sudo | passwordless (`%wheel`) |

Login is automatic and Hyprland starts by itself. Change the password with `passwd`.

## What is installed

- Browser: Firefox
- Files: Nautilus
- Terminal: foot
- Text editor: mousepad
- Images / video: imv / mpv
- Settings: `nwg-look` (GTK theme and icons)

Anything else comes from `Super+I` or a terminal:
`sudo pacman -S <pkg>`, `yay -S <pkg>` (AUR), `flatpak install flathub <id>`.

## Keybinds

Press `Super+/` inside the VM for the full list. The essentials:

| Keys | Action |
|------|--------|
| `Super+Return` | terminal |
| `Super+Space` | search apps / run a command |
| `Super+A` | app grid / Launchpad |
| `Super+I` | install an app |
| `Super+N` | clear notifications |
| `Super+Q` | close window |
| `Super+F` | fullscreen |
| `Super+1..5` | switch workspace |
| `Super+Shift+1..5` | move window to workspace |
| `Super+Shift+E` | exit Hyprland back to a text console |

The top menu bar behaves like macOS: the leaf on the left opens the app grid, the dots
switch workspaces, the bell toggles Do Not Disturb (right click clears notifications).

## Notifications

`mako` runs as the notification daemon: app notifications, install progress messages and
volume changes all appear top right. `Super+N` dismisses them all.

## Configuration

The desktop config is Hyprland Lua format (`~/.config/hypr/hyprland.lua`), because
Hyprland 0.57 dropped the old ini file. Check edits before restarting the session:

```
Hyprland --verify-config
```

Other config locations: `~/.config/waybar/`, `~/.config/mako/config`,
`~/.config/nwg-dock-hyprland/style.css`, `~/.config/foot/foot.ini`.

## Troubleshooting

- **Black screen after boot, or Hyprland refuses to start** - the virtual GPU cannot do
  GPU rendering. Log into a text console with `Ctrl+Alt+F2` and try
  `WLR_RENDERER=pixman Hyprland`. On VirtualBox, enable Display -> Enable 3D Acceleration.
- **VirtualBox stays on a black screen** - you attached the `.vmdk`. Use `naseem.vdi`.
- **No network** - `nmtui`.
- **No notifications** - check that `mako` is running: `pgrep mako`, otherwise start it
  with `mako &`.
- **Forgot the keybinds** - `Super+/`, or read `~/.config/naseem/keybinds.txt`.

## Build

Push to `main`, or run the workflow manually:

```
gh workflow run build.yml
gh run watch
```

Push a `v*` tag to publish the images to a GitHub Release:

```
gh api -X POST repos/PanDuroDev/naseem-os/git/refs -f ref=tags/v0.0.8 -f sha=$(gh api repos/PanDuroDev/naseem-os/commits/main --jq .sha)
```

## Roadmap

- [x] bootable Arch + Hyprland image in CI
- [x] icons, cursors, fonts, dock, wallpaper, translucent menu bar, app grid
- [x] AUR helper (`yay`), multilib
- [x] one-click app install menu (`Super+I`) with notifications
- [x] notification daemon (`mako`), volume feedback notifications
- [x] preinstalled browser, file manager, editor, image and video viewer
- [ ] window traffic lights, macOS window controls
- [ ] WhiteSur GTK theme (its installer forces a full system upgrade; needs a prebuilt theme)
- [ ] control centre panel (volume, brightness, wifi, bluetooth)
- [ ] Omarchy package layer (install/update menu, defaults)
- [ ] ISO output
