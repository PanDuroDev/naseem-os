# Naseem OS

Arch Linux + Hyprland, shipped as a ready-to-run VM image with a macOS-flavoured desktop.
Nothing is built on a local machine: GitHub Actions builds, smoke-tests and publishes the image.

## Status

`v0.0.1` - bootable base: Arch Linux, UEFI/GRUB, autologin on tty1, Hyprland + Waybar.

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
- `Super+Return` terminal (kitty), `Super+Space` launcher (fuzzel), `Super+Q` close, `Super+Shift+Q` exit.
- Rounded corners, blur, shadows and translucent top bar - the macOS feel.
- NetworkManager, PipeWire, Flatpak + Flathub wired up.
- `pacman -S <pkg>` for anything else. AUR helper comes later.

## Build

Push to `main`, or run the workflow manually:

```
gh workflow run build.yml
gh run watch
```

Tag `v*` to publish the images to a GitHub Release.

## Roadmap

- [x] bootable Arch + Hyprland image in CI
- [ ] WhiteSur GTK/icon theme, macOS cursors and fonts
- [ ] dock, macOS top bar layout, window traffic lights
- [ ] Omarchy package layer (install/update menu, defaults)
- [ ] AUR helper, ISO output