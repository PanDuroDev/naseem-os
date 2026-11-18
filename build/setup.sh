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

step "multilib"
printf '\n[multilib]\nInclude = /etc/pacman.d/mirrorlist\n' >> /etc/pacman.conf
pacman -Sy --noconfirm >/dev/null 2>&1 || echo 'WARN: multilib sync failed'

step "app installer"
chmod 755 /usr/local/bin/naseem-install /usr/local/bin/naseem-volume
bash -n /usr/local/bin/naseem-install || echo 'WARN: naseem-install syntax error'
bash -n /usr/local/bin/naseem-volume || echo 'WARN: naseem-volume syntax error'
/usr/local/bin/naseem-install --check || echo 'WARN: some curated packages missing from the repos'

step "macOS icons and cursors"
sudo -u nasim env HOME=/home/nasim git clone --depth 1 https://github.com/vinceliuice/WhiteSur-icon-theme /tmp/ws-icon
sudo -u nasim env HOME=/home/nasim git clone --depth 1 https://github.com/vinceliuice/WhiteSur-cursors /tmp/ws-cur

sudo -u nasim env HOME=/home/nasim bash -c 'cd /tmp/ws-icon && ./install.sh -d /home/nasim/.icons -t default' </dev/null \
  || echo 'WARN: WhiteSur icon theme install failed'
sudo -u nasim env HOME=/home/nasim bash -c 'cd /tmp/ws-cur && ./install.sh' </dev/null \
  || echo 'WARN: WhiteSur cursors install failed'
rm -rf /tmp/ws-icon /tmp/ws-cur
test -d /home/nasim/.icons/WhiteSur || echo 'MISSING .icons/WhiteSur'
find /home/nasim -maxdepth 5 -iname '*WhiteSur*cursor*' -type d 2>/dev/null | head -n 3 || true
step "AUR helper"
rm -rf /tmp/yayd
curl -fsSL -o /tmp/yay.tgz https://github.com/jguer/yay/releases/download/v13.1.0/yay_13.1.0_x86_64.tar.gz || true
mkdir -p /tmp/yayd
if tar -xzf /tmp/yay.tgz -C /tmp/yayd 2>/dev/null; then
  YAY_BIN=$(find /tmp/yayd -name yay -type f | head -n1 || true)
  if [ -n "$YAY_BIN" ]; then install -Dm755 "$YAY_BIN" /usr/bin/yay; else echo 'WARN: yay binary not found'; fi
else
  echo 'WARN: yay download failed'
fi
rm -rf /tmp/yayd /tmp/yay.tgz
command -v yay || echo 'MISSING yay'
chown -R nasim:nasim /home/nasim

step "grub defaults"
sed -i 's/^GRUB_TIMEOUT=.*/GRUB_TIMEOUT=1/' /etc/default/grub
sed -i 's|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT="quiet console=tty0 console=ttyS0,115200"|' /etc/default/grub

step "flatpak"
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo || true