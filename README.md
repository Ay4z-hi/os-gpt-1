# SMTH OS

A hybrid desktop and mobile operating system project focused on a distinctive, minimal interface and continuity across devices.

> **Project status:** Early planning. Features described here are goals, not completed functionality.

## Vision

SMTH OS aims to combine:
- A touch-friendly mobile experience with a desktop-style workspace.
- Resizable windows, tabs, and a taskbar/panel.
- A distinctive monochrome visual identity with restrained accent colors.
- Essential system settings and services for networking, audio, power, and notifications.
- Separate build targets for supported ARM64 and x86_64 devices.

## Planned components

- **SMTH Shell:** desktop session and window experience.
- **SMTH Panel:** taskbar, launcher, and system indicators.
- **SMTH Files:** file manager.
- **SMTH Settings:** display, appearance, network, sound, and power settings.
- **SMTH Terminal:** command-line access.
- **SMTH Notify:** notification service.
- **SMTH Store:** application/package management interface.
- **AHIAN mode:** optional animated visual mode, with a way to turn it off.

## Development principles

1. Build a bootable foundation first.
2. Add the compositor and shell before polishing applications.
3. Integrate existing Linux services where practical instead of reimplementing them.
4. Keep licensing and third-party notices available.
5. Document which features are implemented, experimental, or planned.

## Initial technical direction

The initial desktop direction is a Debian-based Linux system using a Wayland compositor and established services such as NetworkManager, BlueZ, PipeWire, and systemd. Exact choices may change as prototypes are tested.

## Roadmap

- [x] Initial project repository
- [x] Project README
- [ ] Repository structure and project documentation
- [ ] Bootable x86_64 development image
- [ ] Wayland session and SMTH Shell prototype
- [ ] Panel, launcher, and window management
- [ ] Settings and core system integrations
- [ ] Essential applications
- [ ] ARM64 support for selected devices

## Contributing

This project is in its early stages. Design notes, prototypes, testing, and documentation are welcome.

## Disclaimer

SMTH OS is an independent project and is not affiliated with Debian, Android, Microsoft, or any other platform mentioned in its technical direction.
