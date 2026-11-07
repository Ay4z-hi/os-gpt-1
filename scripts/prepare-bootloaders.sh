#!/bin/sh
set -eu
ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SOURCE=/usr/share/live/build/bootloaders
DEST="$ROOT/config/bootloaders"
if [ ! -d "$SOURCE" ]; then
  echo "live-build bootloader templates not found at $SOURCE" >&2
  exit 1
fi
mkdir -p "$DEST"
cp -a "$SOURCE/." "$DEST/"
mkdir -p "$DEST/grub-pc" "$DEST/isolinux" "$DEST/syslinux_common"
if ! command -v rsvg-convert >/dev/null 2>&1; then
  echo "Install librsvg2-bin to generate SMTH boot artwork" >&2
  exit 1
fi
rsvg-convert -w 800 -h 600 "$ROOT/assets/boot/smth-boot.svg" > "$DEST/grub-pc/splash.png"
rsvg-convert -w 640 -h 480 "$ROOT/assets/boot/smth-boot.svg" > "$DEST/syslinux_common/splash.png"
cp "$DEST/syslinux_common/splash.png" "$DEST/isolinux/splash.png"
rm -f "$DEST/splash.svg" "$DEST/syslinux_common/splash.svg"
# Replace distro names in copied boot menus without touching binary bootloader modules.
find "$DEST" -type f \( -name '*.cfg' -o -name '*.in' -o -name '*.txt' \) -exec sed -i \
  -e 's/Debian GNU\/Linux/SMTH OS/g' \
  -e 's/Debian Live/SMTH OS/g' \
  -e 's/debian-live/SMTH/g' {} +
# Give the user a short, branded boot menu timeout.
for file in "$DEST/isolinux/isolinux.cfg" "$DEST/syslinux/syslinux.cfg"; do
  if [ -f "$file" ]; then
    if grep -q '^timeout ' "$file"; then
      sed -i 's/^timeout .*/timeout 60/' "$file"
    else
      printf '\ntimeout 60\n' >> "$file"
    fi
  fi
done
echo "SMTH bootloader artwork and labels prepared."
