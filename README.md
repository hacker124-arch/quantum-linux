# Quantum Linux

**Quantum Linux is an experimental Debian 13 (Trixie) live-image project.**
Its target desktop is **KDE Plasma 6 with the Plasma Wayland session**.

## Project goals

- Debian 13 Trixie, amd64
- Full KDE Plasma 6 desktop, SDDM login manager, and Wayland session
- KDE utilities: Dolphin, Konsole, Ark, Kate and System Settings
- PipeWire audio and OBS Studio
- Common laptop firmware and network management
- Optional Waydroid and Helium browser installation during image creation
- Optional USB-based QuantumEffects asset importer

## Important technical notes

- In Debian 13, use `plasma-workspace` for the Plasma workspace. Do **not**
  request `plasma-workspace-wayland`; it is not available in Trixie.
  The Trixie Plasma Workspace package depends on `kwin-wayland`, which is
  also explicitly included. See the
  [Debian Trixie package details](https://packages.debian.org/trixie/plasma-workspace).
- The workflow builds a Debian Trixie amd64 live ISO on a GitHub-hosted
  Ubuntu 24.04 runner and uploads the ISO with a SHA256 checksum.
- Waydroid is optional. Its functionality depends on kernel Binder support,
  graphics drivers and host hardware. Package installation alone does not
  guarantee Android apps will run on every computer.
- Helium is optional and comes from its upstream Debian repository. If that
  repository is unavailable during a build, the base ISO build continues.
- OBS Studio and `v4l2loopback-dkms` are included, but loopback support depends
  on kernel headers and module build support.
- Plasma is heavier than XFCE. Performance on low-memory systems must be
  tested; no performance guarantee is claimed.
- This is not a production-certified operating system. Test the ISO in a VM
  and on spare hardware before daily use.

## Build

1. Open the repository's **Actions** tab.
2. Select **Build Quantum Linux ISO**.
3. Choose **Run workflow** (or push a change to `main`).
4. Wait for all build steps to finish.
5. Download the `Quantum-Linux-Debian13-amd64` artifact.
6. Verify `SHA256SUMS` before writing the ISO to a USB drive.
7. Boot and test the live environment before installing it.

The build runs on GitHub-hosted infrastructure. It does not use or modify
your computer's local Windows drives.

## USB animation assets

Create a folder named `QuantumEffects` at the root of a USB drive and place a
`manifest.txt` inside it. Boot Quantum Linux, mount the USB, then run:

```bash
sudo quantum-effects-import
```

The importer copies the data into `/usr/local/share/quantum-effects`. It does
not execute scripts from removable media. Actual Plasma animation/theme
integration must be provided by a compatible asset pack; the importer alone
does not create new Plasma effects.

## Safety and licensing

- Back up important data before partitioning or installing any operating system.
- Do not use an installer or partitioning tool on a real disk until the ISO has
  been tested and the installation steps have been reviewed.
- Quantum Linux is an independent remix. Debian, KDE, OBS Studio, Waydroid and
  Helium retain their own trademarks and licenses. Review redistribution
  requirements before publishing an ISO.
