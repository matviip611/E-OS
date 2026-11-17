#!/usr/bin/env bash
# E-OS by PME — збірка ISO (Debian bookworm, лише amd64). Запуск: bash ./build.sh
set -euo pipefail
cd "$(dirname "$0")"
ROOT="$(pwd)"

if [ "$(id -u)" -ne 0 ]; then exec sudo -E bash "$0" "$@"; fi

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y live-build debootstrap squashfs-tools xorriso mtools dosfstools \
  syslinux syslinux-common syslinux-utils isolinux rsync cpio zstd grub-pc-bin grub-efi-amd64-bin python3 python3-pil fonts-dejavu-core ca-certificates

# --- 1. розкласти ресурси з assets/ у дерево системи
INC="config-tree/includes.chroot"
install -d "$INC/usr/share/pixmaps" "$INC/usr/share/E-OS" \
  "$INC/usr/share/wallpapers/E-OS/contents/images" \
  "$INC/usr/share/plymouth/themes/eos" "$INC/usr/share/sddm/themes/eos" \
  "$INC/usr/share/icons/hicolor/256x256/apps"
cp assets/wallpaper.jpg        "$INC/usr/share/wallpapers/E-OS/contents/images/1920x1080.jpg"
cp assets/wallpaper.jpg        "$INC/usr/share/sddm/themes/eos/background.jpg"
cp assets/logo-white.png       "$INC/usr/share/sddm/themes/eos/logo.png"
cp assets/logo-white.png       "$INC/usr/share/pixmaps/eos-logo.png"
cp assets/menu-round.png       "$INC/usr/share/pixmaps/eos-menu.png"
cp assets/logo-round-256.png   "$INC/usr/share/icons/hicolor/256x256/apps/eos.png"
cp assets/plymouth-logo.png    "$INC/usr/share/plymouth/themes/eos/logo.png"
cp assets/background-music.mp3 "$INC/usr/share/E-OS/background-music.mp3"

# --- 2. конфіг live-build
rm -rf build && mkdir build && cd build
lb config \
  --distribution bookworm \
  --architectures amd64 \
  --binary-images iso-hybrid \
  --archive-areas "main contrib non-free non-free-firmware" \
  --debian-installer none \
  --apt-recommends false \
  --memtest none \
  --iso-application "E-OS" \
  --iso-publisher "PME" \
  --iso-volume "E-OS" \
  --bootappend-live "boot=live components quiet splash locales=uk_UA.UTF-8 keyboard-layouts=us,ua timezone=Europe/Kyiv username=eos hostname=e-os"

cp -a "$ROOT"/config-tree/package-lists/. config/package-lists/
cp -a "$ROOT"/config-tree/hooks/normal/.  config/hooks/normal/
cp -a "$ROOT"/config-tree/includes.chroot/. config/includes.chroot/
chmod +x config/hooks/normal/* config/includes.chroot/usr/local/bin/* 2>/dev/null || true

# --- 3. брендинг екрана завантаження робить хук config-tree/hooks/normal/9000-eos-boot.hook.binary

# --- 4. збірка
# Сильніше стиснення squashfs (той самий вміст, менший файл): блок 1M + BCJ-фільтр x86, щоб ISO влізло в ліміт 2 GiB одним файлом
export MKSQUASHFS_OPTIONS="-b 1M -Xbcj x86 -Xdict-size 100%"
lb build
ISO="$(ls -1 *.iso | head -n1)"
mv "$ISO" "$ROOT/E-OS-amd64.iso"
cd "$ROOT" && sha256sum E-OS-amd64.iso > E-OS-amd64.iso.sha256
echo "Готово: $ROOT/E-OS-amd64.iso"
