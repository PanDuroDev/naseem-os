#!/usr/bin/env bash
set -euo pipefail

TARGET=${TARGET:?TARGET not set}
step() { echo; echo "===== $* ====="; }

step "keyring"
pacman-key --init
pacman-key --populate archlinux
pacman -Sy --noconfirm --needed archlinux-keyring

step "pacstrap $TARGET"
mkdir -p "$TARGET"
pacstrap -K "$TARGET" \
  base linux grub efibootmgr sudo nano git networkmanager openssh ca-certificates \
  hyprland xdg-desktop-portal-hyprland hyprpolkitagent \
  waybar fuzzel foot swaybg nwg-dock-hyprland nwg-look nwg-drawer \
  mesa xorg-xwayland qt5-wayland qt6-wayland \
  pipewire pipewire-pulse wireplumber \
  polkit noto-fonts noto-fonts-emoji ttf-dejavu inter-font ttf-jetbrains-mono \
  sassc libxml2 imagemagick flatpak

step "configure target"
mkdir -p "$TARGET/root"
cp /setup.sh "$TARGET/root/setup.sh"
cp -a /config "$TARGET/config"
mount --bind "$TARGET" "$TARGET"
arch-chroot "$TARGET" /bin/bash /root/setup.sh
umount "$TARGET" || true
rm -rf "$TARGET/config" "$TARGET/root/setup.sh"