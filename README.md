# SMTH OS

A hybrid desktop/mobile operating system project with an original eclipse identity, a Wayland desktop foundation, and a long-term goal of touch-to-desktop continuity.

> **Status: early prototype.** The repository contains a first amd64 live-build foundation. It is not yet a finished OS, and no ISO has been validated.

## Current foundation

- Debian Bookworm Live-Build configuration for x86_64
- Sway Wayland session, Waybar panel, Wofi launcher, Foot terminal
- SMTH Files launcher (currently backed by Thunar)
- SMTH Web launcher (currently backed by Firefox ESR)
- NetworkManager and BlueZ for Wi-Fi/Ethernet and Bluetooth
- PipeWire/WirePlumber audio and Mako notifications
- Plymouth SMTH boot splash prototype
- Custom black-hole/eclipse SVG mark and wallpaper
- Two accent colours only: coral `#FF315A` and teal `#20D9C2`
- `ahian` command prototype for a more animated Waybar treatment
- APT package install wrapper and manual GitHub Actions ISO workflow

## Build

See [docs/BUILD.md](docs/BUILD.md).

## Architecture and roadmap

- [Architecture blueprint](docs/ARCHITECTURE.md)
- [Implementation status](docs/STATUS.md)
- [ARM64 device support plan](docs/ARM64.md)

## Important

The first build is amd64 desktop Linux. ARM64 phone support requires a named device, compatible kernel/firmware, boot chain, GPU/display/touch drivers, and a separate image process. WinTabs, the Android launcher, CoreLink, and custom native apps remain future milestones.

SMTH OS is an independent project and is not affiliated with Debian, Android, Microsoft, or any other platform.
