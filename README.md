# Quantum Linux — starter build project

**Status: experimental starter source, not a finished or tested ISO.**

Target: Debian 13 (Trixie), amd64, KDE Plasma 6 / Wayland, OBS Studio,
Helium Browser, and optional Waydroid. The GitHub Actions workflow attempts
to build a Debian Live ISO using `live-build`.

## Important limitations

- This is a first build scaffold. The workflow must be run and its output
  tested in a VM before anyone installs it on real hardware.
- Waydroid requires compatible Binder support in the running kernel and
  suitable graphics support. Its presence in the image does not guarantee
  that it will work on every computer.
- BlueStacks is Windows-only. Waydroid is the Linux-native Android alternative.
- The optional animation importer copies a pack from a USB into the installed
  system so the USB can be removed afterward. The actual Plasma animation
  effects/theme still need to be packaged and validated for the chosen Plasma
  version; this scaffold does not pretend to ship finished custom effects.
- The Helium browser is installed from its official Debian repository. Helium
  is beta software.
- The image is not tuned or benchmarked yet for 6 GB RAM. Plasma is relatively
  heavier than XFCE; memory use must be measured on the target laptop.

## Build on GitHub

1. Create a **public or private** GitHub repository named `quantum-linux`.
2. Upload the contents of this folder to the repository root.
3. Open **Actions** and enable workflows if GitHub asks.
4. Run **Build Quantum Linux ISO** using **Run workflow**.
5. If it succeeds, download the `quantum-linux-iso` artifact from that run.
6. Verify the SHA256 file and boot the ISO in a VM first.

The workflow uses GitHub-hosted Ubuntu runners, so your Windows E: drive does
not need to hold the Linux build tree. GitHub account limits and artifact
retention apply.

## USB animation pack

Put a folder named `QuantumEffects` at the root of a USB drive. The folder
should contain a `manifest.txt` file and the tested animation/theme assets.
After installation, run:

```bash
sudo quantum-effects-import
```

The importer copies the folder to `/usr/local/share/quantum-effects`, so the
USB can be removed. It does not blindly execute files from the USB.

## Safety

Do not select an install/partition option on a real laptop until the ISO has
been booted and tested in a VM and the installer has been reviewed. Back up
important files first. This project does not include an unattended partition
or disk-erasure configuration.
