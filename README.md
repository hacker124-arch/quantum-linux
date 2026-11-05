# Quantum Linux

**Quantum Linux is an experimental Debian 13 (Trixie) live-image project.**
Its target desktop is **KDE Plasma 6 with the Plasma Wayland session**, using
**systemd** as PID 1 and the live-config backend.

## Project goals

- Debian 13 Trixie, amd64
- KDE Plasma 6 desktop, SDDM login manager, and Plasma Wayland session
- KDE utilities: Dolphin, Konsole, Ark, Kate and System Settings
- PipeWire audio and OBS Studio
- Common laptop firmware and NetworkManager
- Optional Waydroid and Helium browser installation during image creation
- Optional USB-based QuantumEffects asset importer

## Build design

- GitHub Actions builds the image on an Ubuntu 24.04 hosted runner.
- `auto/config` is the single source of truth for live-build settings.
- The workflow deliberately runs `lb config` (not `lb config noauto`) so
  live-build executes the repository's `auto/config`.
- The image explicitly selects `--initsystem systemd` and the
  `live-config-systemd` backend. SysV init packages must not be selected.
- The workflow validates the generated configuration, builds the ISO, checks
  that the ISO is readable, and publishes a SHA256 checksum with the artifact.
- Optional Waydroid and Helium installation failures do not fail the base image.

## Debian package notes

- Debian 13 provides `plasma-workspace`; do not request the nonexistent
  `plasma-workspace-wayland` package. The Wayland compositor package
  `kwin-wayland` is included explicitly.
- `live-config-systemd` is the live-config backend for a systemd live image.
  The sysvinit backend conflicts with `systemd-sysv` and must not be installed.
- Waydroid functionality depends on kernel Binder support, graphics drivers
  and host hardware. Installing its package does not guarantee Android apps
  will run on every computer.
- OBS Studio is included. Virtual camera/loopback functionality depends on
  kernel headers and module support.
- Plasma is heavier than XFCE. Performance on low-memory systems must be tested.

## Build

1. Open the repository's **Actions** tab.
2. Select **Build Quantum Linux ISO**.
3. Choose **Run workflow** (or push a relevant change to `main`).
4. Wait for the build job to finish.
5. Download the `Quantum-Linux-Debian13-amd64` artifact.
6. Verify `SHA256SUMS` before writing the ISO to a USB drive.
7. Test the live session in a VM and on spare hardware before daily use.

The build runs on GitHub-hosted infrastructure. It does not use or modify
your computer's local Windows drives.

## USB animation assets

Create a folder named `QuantumEffects` at the root of a USB drive and place a
`manifest.txt` inside it. Boot Quantum Linux, mount the USB, then run:

```bash
sudo quantum-effects-import
```

The importer copies data into `/usr/local/share/quantum-effects`. It does not
execute scripts from removable media. Actual Plasma animation/theme integration
must be provided by a compatible asset pack; the importer alone does not create
new Plasma effects.

## Limitations and safety

- This is an experimental live image, not a production-certified OS.
- Successful ISO creation does not prove every laptop will boot or that all
  hardware will work. Test the image before daily use.
- Back up important data before partitioning or installing any operating system.
- Review licensing and trademark requirements before redistributing the ISO.
