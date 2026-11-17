# Naseem OS

Arch Linux + Hyprland, shipped as a ready-to-run VM image with a macOS-flavoured desktop.
Nothing is built on a local machine: GitHub Actions builds, smoke-tests and publishes the image.

## Status

`v0.0.2` - bootable base plus the macOS look: WhiteSur theme, Inter font, translucency,
rounded corners, top bar and dock.

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
- WhiteSur GTK theme, WhiteSur icons and cursors, Inter UI font, JetBrains Mono terminal font.
- `Super+Return` terminal (kitty), `Super+Space` launcher (fuzzel), `Super+Q` close, `Super+Shift+Q` exit.
- NetworkManager, PipeWire, Flatpak + Flathub wired up.
- `pacman -S <pkg>` for anything else. `nwg-look` changes GTK theme from the GUI.

## Build

Push to `main`, or run the workflow manually:

```
gh workflow run build.yml
gh run watch
```

Push a `v*` tag to publish the images to a GitHub Release:

```
gh release create v0.0.2 --notes "..." --target main
```

## Roadmap

- [x] bootable Arch + Hyprland image in CI
- [x] WhiteSur GTK/icon theme, macOS cursors and fonts
- [x] dock, wallpaper, translucent top bar
- [ ] window traffic lights on hover, macOS window controls
- [ ] AUR helper, one-click app install menu
- [ ] Omarchy package layer (install/update menu, defaults)
- [ ] ISO output