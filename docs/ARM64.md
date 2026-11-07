# ARM64 plan

The desktop live-build configuration is currently amd64. ARM64 is not one universal phone image.

Before producing a bootable image, each target device needs its own:
- SoC and board support (kernel, device tree, vendor modules where legally redistributable)
- Boot chain and partition layout
- Display, touch, GPU, audio, Wi-Fi, Bluetooth, modem and power drivers
- Firmware and recovery/rollback procedure

A generic Debian arm64 root filesystem can be built for testing in QEMU, but it is not equivalent to an Android GSI or a flashable phone image. Do not flash an experimental image to a daily-use phone. The next safe milestone is an arm64 QEMU image, then a named development device.
