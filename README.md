# SMTH OS

A compact, original Linux desktop project built around a black-hole identity, a minimal Wayland session and a future mobile-to-desktop architecture.

> **Current milestone:** the amd64 live ISO builds successfully. A separate Android + Windows SMTH Launcher Preview is being built as a polished visual simulation; it does not boot the ISO. The ISO still needs real-device boot testing.

## Visual identity

- Black and white UI
- Exactly two accent colours: violet `#A56EFF` and lime `#C8F169`
- Flat dot patterns and an original eclipse / black-hole mark
- No gradients, glow shading or copied Nothing OS glyphs

## Desktop foundation

- Sway Wayland compositor
- Waybar panel and Wofi start menu
- Thunar file manager and Firefox ESR browser
- Foot terminal, Mako notifications and SMTH Settings menu
- NetworkManager, BlueZ and PipeWire
- Custom GRUB/BIOS boot artwork and Plymouth loading screen
- `ahian` command for the alternate animated desktop mode
- Trimmed package list with zram support

## Build

See [docs/BUILD.md](docs/BUILD.md).

## Project status

See [docs/STATUS.md](docs/STATUS.md) and [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

## Platform scope

The first image targets amd64 PCs and virtual machines. ARM64 phone support requires a specific device target, kernel, firmware, boot chain and hardware drivers. The live ISO is not yet an installer.

SMTH OS is an independent project and is not affiliated with Debian, Android, Microsoft, or any other platform.
