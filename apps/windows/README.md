# SMTH OS companion launchers

These apps boot the **real SMTH OS live ISO** in a virtual machine. They do not simulate the desktop or replace the host operating system.

## Windows

The Windows launcher is a small SMTH-themed front end for QEMU.

1. Download and extract the `smth-os-amd64-live-iso` artifact from [the successful ISO build](https://github.com/Ay4z-hi/os-gpt-1/actions/runs/42354899724).
2. Install QEMU for Windows (64-bit) from [the QEMU Windows builds page](https://qemu.weilnetz.de/w64/).
3. Run `SMTH-Launcher.exe`, select the ISO and `qemu-system-x86_64.exe`, then press **BOOT SMTH OS**.
4. The default VM settings are 2 CPU cores and 2 GB RAM. Increase RAM if the host has enough memory.

The EXE does not include the ISO or QEMU binaries. The ISO is roughly 1 GB and QEMU has its own license and distribution terms.

## Android APK — engineering status

The Android app must embed a native QEMU engine to boot this x86_64 ISO. A normal Android activity or WebView cannot boot it. The intended base is [QubeVM](https://github.com/rhn-1k/QubeVM), a GPL-3.0 Android QEMU emulator that supports x86 guests on ARM64 phones. It uses software CPU emulation on stock Android in most cases, so performance can be very slow; its upstream requirements currently include Android 11+, a 64-bit CPU, and at least 2 GB RAM.

The Android integration is **not yet built or tested**. We must integrate and brand the QEMU engine, add an SMTH preset that points to the selected ISO, and build/sign/test the APK before publishing it. We will not ship a fake APK that only displays a launcher screen.

## Important

- The current guest image is AMD64. It is not an ARM-native Android OS.
- Running a VM does not install SMTH OS on the phone or PC.
- The live session may not retain files after shutdown unless a persistent virtual disk is added.
- Never choose a host disk as a VM write target. The launcher currently boots the ISO read-only as a live CD.
