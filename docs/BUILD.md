# Build SMTH OS — amd64 live ISO

This produces a bootable **live desktop ISO** for x86_64 PCs and virtual machines. It is not yet a disk installer or a phone image.

## Build locally

Recommended host: Debian 12 (Bookworm), with internet access and 25 GB free disk space.

```sh
sudo apt update
sudo apt install -y live-build debootstrap squashfs-tools xorriso \
  grub-pc-bin grub-efi-amd64-bin mtools dosfstools librsvg2-bin

git clone https://github.com/Ay4z-hi/os-gpt-1.git
cd os-gpt-1

chmod +x auto/config scripts/*.sh
chmod +x config/hooks/normal/*.hook.chroot
chmod +x config/includes.chroot/usr/local/bin/*

sudo lb clean --all
sudo ./auto/config
sudo ./scripts/prepare-bootloaders.sh
sudo lb build
```

The resulting ISO is normally named `live-image-amd64.hybrid.iso`.

## Build with GitHub Actions

1. Open the repository's **Actions** tab.
2. Choose **Build SMTH OS ISO**.
3. Tap **Run workflow**.
4. When the job succeeds, open its run and download `smth-os-amd64-live-iso` under Artifacts.

## Test before using a USB

```sh
qemu-system-x86_64 -m 4096 -enable-kvm \
  -cdrom live-image-amd64.hybrid.iso
```

Remove `-enable-kvm` if hardware virtualization is unavailable.

## What the first image includes

- Sway Wayland desktop, Waybar panel and Wofi start menu
- SMTH black/white interface with coral and teal accent dots
- Custom SMTH GRUB/BIOS boot artwork and Plymouth loading splash
- SMTH Files, SMTH Web, terminal and Settings entries
- NetworkManager Wi-Fi/Ethernet, BlueZ Bluetooth, PipeWire audio
- Mako notifications, package installer wrapper and `ahian` mode
- zram swap support and a deliberately small desktop package set

## Scope and safety

- Target: **amd64 only**. ARM64 phone support needs a named device and its own kernel, firmware, boot chain and drivers.
- The ISO is a live environment; the installer is intentionally not included yet.
- Hardware support varies by PC. Firmware packages cover common Wi-Fi, graphics and audio devices but cannot guarantee every chipset.
- Test in QEMU first. Do not flash an experimental image to your daily-use phone or PC.
