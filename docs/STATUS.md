# Implementation status

This repository contains an initial Debian Live-Build desktop foundation.

## Present in source

- amd64 live-build configuration and package list
- Sway Wayland session, Waybar panel, Wofi launcher, Foot terminal
- SMTH Files launcher backed by Thunar, including desktop shortcut
- SMTH Web launcher backed by Firefox ESR, including desktop shortcut
- SMTH Settings menu for display, network, Bluetooth, sound, and session controls
- SMTH App Installer shortcut for installing packages from signed Debian repositories
- NetworkManager and BlueZ packages for Wi-Fi/Ethernet and Bluetooth
- PipeWire/WirePlumber audio stack and Mako notification daemon
- Custom black-hole/eclipse SVG logo and wallpaper; only coral and teal accent dots
- Plymouth script theme prototype for a minimal SMTH boot screen
- ahian command prototype that switches Waybar styling and reloads it
- APT package install wrapper with package-name validation
- Manual GitHub Actions ISO build workflow

## Not implemented or not validated yet

- A successful ISO build and boot test; CI must be run and the artifact tested
- Custom native file manager or browser engines; current launchers use Thunar and Firefox ESR
- Custom GRUB menu theme; only the Plymouth splash prototype is included
- WinTabs compositor/window grouping
- Mobile launcher APK, Android HAL, GSI, or device-specific ARM64 image
- CoreLink, camera/gallery/paint apps, VM manager, and full settings/control-center GUI
- Production-grade installer, secure user provisioning, signed SMTH package repository
- Hardware validation for graphics, Wi-Fi, Bluetooth, audio, suspend, and power management

Do not describe this project as a finished operating system until the ISO boots and the major hardware paths are tested.
