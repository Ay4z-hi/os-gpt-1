# Implementation status

This repository contains an initial Debian Live-Build desktop foundation.

## Present in source

- amd64 live-build configuration and package list
- Sway Wayland session, Waybar panel, Wofi app launcher, Foot terminal
- Thunar and Firefox ESR exposed as SMTH Files and SMTH Web launchers
- NetworkManager and BlueZ packages for Wi-Fi/Ethernet and Bluetooth
- PipeWire/WirePlumber audio stack
- Mako notifications
- Custom SMTH eclipse SVG mark and wallpaper (two accent colours only)
- Plymouth script theme for a minimal SMTH boot screen
- ahian command that switches the Waybar accent treatment
- APT-based package install wrapper
- Manual GitHub Actions ISO build workflow

## Not implemented yet

- A successful ISO build/test (CI must be run and the artifact tested)
- Custom native file manager or browser engines; current launchers use Thunar and Firefox ESR
- WinTabs compositor/window grouping
- Mobile launcher APK, Android HAL, GSI, or device-specific ARM64 image
- CoreLink, camera/gallery/paint apps, VM manager, and full settings/control-center GUI
- Production-grade installer, secure user provisioning, signed SMTH package repository
- Custom GRUB theme and hardware validation

Do not describe this project as a finished operating system until the ISO boots and the major hardware paths are tested.
