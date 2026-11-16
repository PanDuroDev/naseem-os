#!/usr/bin/env bash
set -euo pipefail

TARGET=${TARGET:?TARGET not set}
step() { echo; echo "===== $* ====="; }

step "keyring"
pacman-key --init
pacman-key --populate archlinux
pacman -Sy --noconfirm --needed archlinux-keyring

step "pacstrap $TARGET"
pacstrap -K "$TARGET" \
  base linux grub efibootmgr sudo nano git networkmanager openssh \
  hyprland xdg-desktop-portal-hyprland hyprpolkitagent \
  waybar fuzzel kitty \
  mesa xorg-xwayland qt5-wayland qt6-wayland \
  pipewire pipewire-pulse wireplumber \
  polkit noto-fonts noto-fonts-emoji ttf-dejavu \
  flatpak

step "configure target"
mkdir -p "$TARGET/root"
cp /setup.sh "$TARGET/root/setup.sh"
cp -a /config "$TARGET/config"
arch-chroot "$TARGET" /bin/bash /root/setup.sh
rm -rf "$TARGET/config" "$TARGET/root/setup.sh"