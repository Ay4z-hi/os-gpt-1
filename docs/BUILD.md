# Build the first SMTH OS live ISO

## Host requirements

Use a Debian 12 (Bookworm) or compatible Debian/Ubuntu build host with internet access and at least 25 GB free disk space.

```sh
sudo apt update
sudo apt install -y live-build debootstrap squashfs-tools xorriso \
  grub-pc-bin grub-efi-amd64-bin mtools dosfstools
git clone https://github.com/Ay4z-hi/os-gpt-1.git
cd os-gpt-1
chmod +x auto/config
chmod +x config/hooks/normal/*.hook.chroot
chmod +x config/includes.chroot/usr/local/bin/*
sudo ./auto/config
sudo lb build
```

The output should be a hybrid ISO in the project directory. Exact output names depend on live-build version.

## Build through GitHub Actions

Open the repository's **Actions** tab, choose **Build SMTH OS ISO**, then select **Run workflow**. When it finishes, download the artifact named `smth-os-amd64-iso`.

## Test in QEMU

```sh
qemu-system-x86_64 -m 4096 -enable-kvm -cdrom live-image-amd64.hybrid.iso
```

If KVM is unavailable, remove `-enable-kvm` (slower).

## Important limitations

- This configuration currently targets **amd64 only**.
- It is an early live image prototype, not a production installer or mobile image.
- ARM64 needs its own kernel/firmware and board/device boot configuration.
- The custom Plymouth theme and greetd autologin need to be validated in the resulting image.
- Test the ISO in QEMU before writing it to USB hardware.
