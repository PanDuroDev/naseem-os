#!/usr/bin/env bash
set -euo pipefail

step() { echo; echo "===== $* ====="; }

step "locale and time"
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
sed -i 's/^#en_US.UTF-8/en_US.UTF-8/' /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf
echo 'naseem' > /etc/hostname
echo 'KEYMAP=us' > /etc/vconsole.conf

step "initramfs"
sed -i 's/^MODULES=.*/MODULES=(virtio_blk virtio_pci virtio_net virtio_gpu vmwgfx)/' /etc/mkinitcpio.conf
sed -i 's/^HOOKS=.*/HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block filesystems fsck)/' /etc/mkinitcpio.conf
mkinitcpio -P

step "user"
useradd -m -G wheel,video,input -s /bin/bash nasim
echo 'nasim:naseem' | chpasswd
printf '%%wheel ALL=(ALL:ALL) NOPASSWD: ALL\n' > /etc/sudoers.d/10-naseem
chmod 0440 /etc/sudoers.d/10-naseem
chown root:root /etc/sudoers.d/10-naseem

step "services"
systemctl enable NetworkManager sshd
install -d /etc/systemd/system/getty@tty1.service.d
cat > /etc/systemd/system/getty@tty1.service.d/autologin.conf <<'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin nasim --noclear %I $TERM
EOF
cat > /etc/systemd/system/naseem-boot-ok.service <<'EOF'
[Unit]
Description=Naseem boot marker for CI
After=getty.target
[Service]
Type=oneshot
ExecStart=-/bin/sh -c 'echo NASEEM_BOOT_OK > /dev/ttyS0'
[Install]
WantedBy=multi-user.target
EOF
systemctl enable naseem-boot-ok.service

step "desktop dotfiles"
cp -a /config/. /
chown -R nasim:nasim /home/nasim

step "grub defaults"
sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/' /etc/default/grub
sed -i 's|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT="quiet console=tty0 console=ttyS0,115200"|' /etc/default/grub

step "flatpak"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true