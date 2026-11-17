# Naseem OS

Arch Linux + Hyprland, shipped as a ready-to-run VM image with a macOS-flavoured desktop.
Nothing is built on a local machine: GitHub Actions builds, smoke-tests and publishes the image.

## Status

`v0.0.4` - bootable base plus the macOS look: translucency, rounded corners, wallpaper,
top bar, dock, app grid, WhiteSur icons, Inter font, and `yay` for AUR packages.

## Download

Releases page:

| File | Use with |
|------|----------|
| `naseem.qcow2` | QEMU/KVM, virt-manager, Proxmox |
| `naseem.vmdk` | VMware, VirtualBox |

Both are UEFI images. In VirtualBox enable System -> Enable EFI before first boot.

## Default account

| | |
|---|---|
| user | `nasim` |
| password | `naseem` |
| sudo | passwordless (`%wheel`) |

Change it after first boot with `passwd`.

## What works

- Hyprland starts automatically on tty1 when a DRM device exists.
- Top bar (Waybar) with workspaces, clock, tray, network, volume, battery.
- Bottom dock (nwg-dock-hyprland), wallpaper, rounded corners, blur, shadows.
- App grid / Launchpad (nwg-drawer) on `Super+A`.
- WhiteSur icons, Inter UI font, JetBrains Mono terminal font.
- `Super+Return` terminal (kitty), `Super+Space` search (fuzzel), `Super+Q` close, `Super+Shift+Q` exit.
- NetworkManager, PipeWire, Flatpak + Flathub wired up.
- `pacman -S <pkg>` for official packages, `yay -S <pkg>` for AUR, `flatpak install` for Flathub. `nwg-look` changes GTK theme from the GUI.

## Build

Push to `main`, or run the workflow manually:

```
gh workflow run build.yml
gh run watch
```

Push a `v*` tag to publish the images to a GitHub Release:

```
gh api -X POST repos/PanDuroDev/naseem-os/git/refs -f ref=refs/tags/v0.0.4 -f sha=$(gh api repos/PanDuroDev/naseem-os/commits/main --jq .sha)
```

## Roadmap

- [x] bootable Arch + Hyprland image in CI
- [x] icons, fonts, dock, wallpaper, translucent top bar, app grid
- [x] AUR helper (`yay`)
- [ ] WhiteSur GTK theme (its installer forces a full system upgrade; needs a prebuilt theme instead)
- [ ] macOS cursors (upstream installer produces nothing headless)
- [ ] window traffic lights, macOS window controls
- [ ] one-click app install menu
- [ ] Omarchy package layer (install/update menu, defaults)
- [ ] ISO output