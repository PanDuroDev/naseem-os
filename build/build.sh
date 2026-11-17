#!/usr/bin/env bash
set -euo pipefail

REPO=$(cd "$(dirname "$0")/.." && pwd)
WORK=${WORK:-/mnt/naseem}
MIRROR=${MIRROR:-https://geo.mirror.pkgbuild.com}
IMAGE_SIZE=${IMAGE_SIZE:-12G}
OUT=${OUT:-$REPO/release}
TARGET=$WORK/target
BS=

step() { echo; echo "===== $* ====="; }

cleanup() {
  mountpoint -q "$WORK/mnt/boot" 2>/dev/null && umount "$WORK/mnt/boot" || true
  mountpoint -q "$WORK/mnt" 2>/dev/null && umount "$WORK/mnt" || true
  if [ -n "$BS" ]; then mountpoint -q "$BS$WORK" 2>/dev/null && umount "$BS$WORK" || true; fi
  if [ -n "${LOOP:-}" ]; then losetup -d "$LOOP" 2>/dev/null || true; fi
}
trap cleanup EXIT

step "workspace $WORK"
rm -rf "$WORK"
mkdir -p "$WORK/bs" "$OUT"
df -h "$WORK"

step "download arch bootstrap"
curl -fL --retry 3 --retry-delay 5 -o "$WORK/bootstrap.tar.zst" \
  "$MIRROR/iso/latest/archlinux-bootstrap-x86_64.tar.zst"
tar -I zstd -xf "$WORK/bootstrap.tar.zst" -C "$WORK/bs"
BS=$WORK/bs/root.x86_64
cp /etc/resolv.conf "$BS/etc/resolv.conf"
printf 'Server = %s/$repo/os/$arch\n' "$MIRROR" > "$BS/etc/pacman.d/mirrorlist"

step "expose workspace inside the bootstrap"
mkdir -p "$BS$WORK"
mount --bind "$WORK" "$BS$WORK"

step "wallpaper"
mkdir -p "$REPO/config/home/nasim/Pictures"
convert -size 2560x1600 gradient:'#22304d-#5c3d6b' "$REPO/config/home/nasim/Pictures/wallpaper.png"

step "stage build inputs"
cp "$REPO/build/chroot.sh" "$BS/chroot.sh"
cp "$REPO/build/setup.sh" "$BS/setup.sh"
cp -a "$REPO/config" "$BS/config"
export TARGET

step "build rootfs"
"$BS/usr/bin/arch-chroot" "$BS" /bin/bash /chroot.sh

step "create disk image"
IMG=$WORK/naseem.raw
truncate -s "$IMAGE_SIZE" "$IMG"
parted -s "$IMG" mklabel gpt
parted -s "$IMG" mkpart ESP fat32 1MiB 513MiB
parted -s "$IMG" set 1 esp on
parted -s "$IMG" mkpart root ext4 513MiB 100%
LOOP=$(losetup -fP --show "$IMG")
mkfs.vfat -F32 -n ESP "${LOOP}p1" >/dev/null
mkfs.ext4 -q -F -L naseem "${LOOP}p2"
mkdir -p "$WORK/mnt"
mount "${LOOP}p2" "$WORK/mnt"
mkdir -p "$WORK/mnt/boot"
mount "${LOOP}p1" "$WORK/mnt/boot"

step "copy rootfs onto image"
step "trim pacman cache"
rm -rf "$TARGET"/var/cache/pacman/pkg/* "$TARGET"/var/lib/pacman/sync/* "$TARGET"/tmp/* 2>/dev/null || true
rsync -aHAX --numeric-ids "$TARGET/" "$WORK/mnt/"

step "write fstab"
UUID_ROOT=$(blkid -s UUID -o value "${LOOP}p2")
UUID_ESP=$(blkid -s UUID -o value "${LOOP}p1")
cat > "$WORK/mnt/etc/fstab" <<EOF
UUID=$UUID_ROOT / ext4 rw,relatime 0 1
UUID=$UUID_ESP /boot vfat rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro 0 2
EOF

step "install bootloader"
"$BS/usr/bin/arch-chroot" "$WORK/mnt" grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=naseem --removable --no-nvram
"$BS/usr/bin/arch-chroot" "$WORK/mnt" grub-mkconfig -o /boot/grub/grub.cfg
umount "$WORK/mnt/boot"
umount "$WORK/mnt"
losetup -d "$LOOP"
LOOP=

step "convert images"
qemu-img convert -f raw -O qcow2 -c "$IMG" "$OUT/naseem.qcow2"
qemu-img convert -f raw -O vmdk -o subformat=streamOptimized -c "$IMG" "$OUT/naseem.vmdk"
qemu-img convert -f raw -O vdi "$IMG" "$OUT/naseem.vdi"
rm -f "$IMG"
xz -T0 -6 "$OUT/naseem.vdi"
cd "$OUT"
for f in "$OUT"/naseem.*; do [ "$(stat -c%s "$f")" -lt 2147483648 ] || { echo "ERROR: $f is over the 2 GiB GitHub release asset limit"; exit 1; }; done
sha256sum naseem.qcow2 naseem.vmdk naseem.vdi.xz > SHA256SUMS
ls -lh "$OUT"