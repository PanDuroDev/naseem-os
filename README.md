# Naseem OS

Arch Linux + Hyprland, shipped as a ready-to-run VM image with a macOS-flavoured desktop.
Nothing is built on a local machine: GitHub Actions builds, smoke-tests and publishes the image.

## Status

`v0.0.6` - bootable base plus the macOS look (translucency, rounded corners, wallpaper,
top bar, dock, app grid, WhiteSur icons, Inter font), `yay` for AUR packages, and a
built-in app installer menu on `Super+I`.

## Download

Releases page: https://github.com/PanDuroDev/naseem-os/releases/latest

| File | Use with |
|------|----------|
| `naseem.vmdk` | VirtualBox, VMware |
| `naseem.qcow2` | QEMU/KVM, virt-manager, Proxmox |

Both are UEFI images. In VirtualBox enable System -> Enable EFI before first boot.
Needs 4 GB RAM, 2 CPU cores and about 16 GB of disk.

## Default account

| | |
|---|---|
| user | `nasim` |
| password | `naseem` |
| sudo | passwordless (`%wheel`) |

Change it after first boot with `passwd`.

## Installing software

Three ways, in order of ease:

1. `Super+I` - menu of popular apps (Firefox, VLC, GIMP, LibreOffice, Steam, Discord,
   Spotify, ...). Pick one, it installs in a terminal window and shows progress.
2. Terminal: `sudo pacman -S <pkg>` for official packages, `yay -S <pkg>` for the AUR,
   `flatpak install flathub <id>` for Flathub apps.
3. `nwg-look` changes the GTK theme from a GUI.

## Keybinds

Press `Super+/` inside the VM for the full list. The essentials:

| Keys | Action |
|------|--------|
| `Super+Return` | terminal (kitty) |
| `Super+Space` | search apps / run a command (fuzzel) |
| `Super+A` | app grid / Launchpad |
| `Super+I` | install an app |
| `Super+Q` | close window |
| `Super+F` | fullscreen |
| `Super+1..5` | switch workspace |
| `Super+Shift+1..5` | move window to workspace |
| `Super+Shift+E` | exit Hyprland back to a text console |

## What works

- Hyprland starts automatically on tty1 when a DRM device exists.
- Top bar (Waybar) with workspaces, clock, tray, network, volume, battery.
- Bottom dock (nwg-dock-hyprland), wallpaper, rounded corners, blur, shadows.
- App grid / Launchpad (nwg-drawer) on `Super+A`, app installer on `Super+I`.
- WhiteSur icons and macOS cursors, Inter UI font, JetBrains Mono terminal font.
- NetworkManager, PipeWire, Flatpak + Flathub, multilib repo enabled.
- `pacman`, `yay`, `flatpak` all ready; `nwg-look` for GTK theme settings.

## Troubleshooting

- **Black screen after boot, or Hyprland refuses to start** - the virtual GPU cannot do
  GPU rendering. Log into a text console with `Super+Shift+E` (or `Ctrl+Alt+F2`) and try
  `WLR_RENDERER=pixman Hyprland`. On VirtualBox, enable Display -> Enable 3D Acceleration.
- **No network** - `nmtui`.
- **Forgot the keybinds** - they are also in `~/.config/naseem/keybinds.txt`.

## Build

Push to `main`, or run the workflow manually:

```
gh workflow run build.yml
gh run watch
```

Push a `v*` tag to publish the images to a GitHub Release:

```
gh api -X POST repos/PanDuroDev/naseem-os/git/refs -f ref=refs/tags/v0.0.6 -f sha=$(gh api repos/PanDuroDev/naseem-os/commits/main --jq .sha)
```

## Roadmap

- [x] bootable Arch + Hyprland image in CI
- [x] icons, fonts, dock, wallpaper, translucent top bar, app grid
- [x] AUR helper (`yay`), multilib
- [x] one-click app install menu (`Super+I`)
- [x] keybind cheatsheet (`Super+/`)
- [ ] WhiteSur GTK theme (its installer forces a full system upgrade; needs a prebuilt theme)
- [ ] window traffic lights, macOS window controls
- [ ] Omarchy package layer (install/update menu, defaults)
- [ ] ISO output