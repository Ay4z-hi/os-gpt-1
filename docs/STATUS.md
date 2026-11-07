# SMTH OS implementation status

## Current target

A compact, bootable **amd64 live desktop ISO**. No Android APK or Windows EXE launcher work is in scope right now.

## Added to source

- Sway Wayland session with Waybar panel and Wofi start menu
- Custom black/white desktop styling with exactly two accent colours: violet `#A56EFF` and lime `#C8F169`
- Custom SVG black-hole/eclipse wallpapers and icon theme
- `ahian` command: toggles an alternate wallpaper, larger window spacing, stronger borders and animated Waybar accent
- Custom Plymouth loading screen with SMTH wordmark and progress indicator
- Bootloader preparation script that replaces Debian-labelled boot artwork/menu text with SMTH artwork
- Thunar-based SMTH Files and Firefox ESR-based SMTH Web
- Settings menu for display, network, Bluetooth, sound and session controls
- NetworkManager, BlueZ, PipeWire/WirePlumber and Mako
- APT package installer wrapper
- Firmware for common Wi-Fi, graphics and audio devices
- zram support and a trimmed package list
- GitHub Actions workflow for building and uploading the live ISO

## Not yet verified / future work

- A successful clean ISO build and QEMU boot test
- Physical hardware tests for Wi-Fi, Bluetooth, graphics, audio, suspend and brightness
- A dedicated graphical login screen; the first image auto-starts the SMTH session
- Custom native applications and a true integrated Control Center
- WinTabs compositor/window grouping
- ARM64 device images, Android runtime, CoreLink and mobile continuity
- Installer for installing SMTH onto a PC drive

Do not call the ISO complete until CI succeeds and the image boots in QEMU.
