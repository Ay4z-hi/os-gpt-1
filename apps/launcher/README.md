# SMTH Launcher Preview

Landscape-first, animated SMTH desktop simulation sharing one Flutter UI across Android and Windows.

- Android locks to landscape; Windows opens in a wide desktop window.
- Original orbital wallpaper, vector glyphs, animated dot field and a custom visible pointer.
- Browser opens real URLs in the device's default browser.
- Terminal runs built-ins and ordinary commands in the app user's unprivileged host shell (Windows CMD or Android app shell).
- Files manages the launcher's private documents folder: create folders/files, preview text and delete items.
- Notes auto-save; Calculator evaluates basic arithmetic; Clock updates live.
- Settings persist the launcher preferences. Wi-Fi and Bluetooth are simulated preview toggles, not hardware controls.
- Store installs/removes the built-in launcher apps in the launcher profile.

The launcher is a simulation: it does not boot Linux or install native packages into Android/Windows. The ISO has separate hardware controls and an APT-powered app store.

Builds are produced by GitHub Actions: **Build SMTH launchers**.
