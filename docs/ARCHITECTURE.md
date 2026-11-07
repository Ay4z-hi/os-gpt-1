# SMTH OS — architecture baseline

## Reality and scope

SMTH OS is a Linux distribution and shell project, not a new kernel today. The first deliverable is a reproducible x86_64 live ISO. ARM64 is a separate build target and requires device-specific boot, kernel, firmware, display, touch, modem, and power integration. An Android APK/GSI is not produced by Debian Live-Build.

## Layer model

1. **Kernel:** Debian Linux LTS kernel, DRM/KMS, input, USB, audio, Wi-Fi and Bluetooth drivers supplied by the target hardware.
2. **Session:** systemd + D-Bus + logind + PipeWire/WirePlumber.
3. **Compositor:** Sway/ wlroots Wayland session for the first prototype; later replace or extend with a dedicated SMTH compositor.
4. **Shell:** Waybar panel, Wofi launcher, Mako notifications, custom theme and desktop entries.
5. **System services:** NetworkManager for Wi-Fi/Ethernet, BlueZ for Bluetooth, UDisks2/GVfs for removable storage.
6. **Apps:** Thunar-based SMTH Files, Firefox ESR-based SMTH Web, Foot terminal, and a package install wrapper.

## WinTabs roadmap

WinTabs is not implemented by the initial Sway configuration. The first milestone uses Sway workspaces and native Wayland windows. A later SMTH shell service will own tab groups and expose them through a compositor protocol; it must never pretend unrelated windows are already one tabbed group.

## Emulator policy

QEMU/KVM, Box64, and FEX are optional, architecture-specific tools. No launcher can safely execute every arbitrary `.iso`, `.exe`, `.apk`, `.bin`, or `.img` file automatically. File types must be routed to explicit handlers; disk images and executables require user confirmation and sandboxing.

## Security

- Do not run downloaded packages as root without verification.
- Prefer signed APT repositories and Flatpak remotes.
- Keep the live image's passwordless sudo limited to the live user and remove it from installed production images.
- Never auto-mount and execute unknown images or binaries.

## Visual system

The interface uses black, white, and graphite surfaces. The only dot/accent colours are coral `#FF315A` and teal `#20D9C2`. The logo is an original eclipse/black-hole motif and the visible wordmark is only `SMTH`.
