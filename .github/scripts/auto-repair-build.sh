#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="${1:-}"
PACKAGE_LIST="config/package-lists/quantum.list.chroot"
CONFIG_FILE="auto/config"
changed=0

if [[ -n "$LOG_FILE" && ! -f "$LOG_FILE" ]]; then
  echo "No build log at $LOG_FILE" >&2
  exit 2
fi

# Repair only deterministic, low-risk source omissions. Never remove or replace
# KDE Plasma, Wayland, systemd, or SDDM to make a build appear successful.
required_packages=(
  live-config-systemd systemd-sysv isolinux syslinux-common
  kde-plasma-desktop plasma-workspace kwin-wayland sddm xwayland
)
for package in "${required_packages[@]}"; do
  if ! grep -Fxq "$package" "$PACKAGE_LIST"; then
    printf '\n%s\n' "$package" >> "$PACKAGE_LIST"
    echo "REPAIR: restored required package entry: $package"
    changed=1
  fi
done

# Reassert the non-negotiable distro/architecture/init settings if they were
# accidentally altered in the repository.
for setting in '--distribution trixie' '--architectures amd64' '--initsystem systemd'; do
  if ! grep -Fq -- "$setting" "$CONFIG_FILE"; then
    echo "ERROR: required build setting missing from auto/config: $setting" >&2
    echo "No safe automatic repair exists for this malformed config." >&2
    exit 3
  fi
done

if [[ -n "$LOG_FILE" ]]; then
  if grep -Eqi 'cp: cannot stat .*/root/isolinux/(isolinux\.bin|vesamenu\.c32)' "$LOG_FILE"; then
    echo "DIAGNOSIS: ISOLINUX staging failure. The corrected workflow stages both /root/isolinux and chroot/root/isolinux before every build attempt."
    if ! grep -q 'Prepare host ISOLINUX bootloader files' .github/workflows/build-iso.yml; then
      echo "ERROR: host bootloader staging step is missing; refusing an unsafe blind workflow rewrite." >&2
      exit 4
    fi
  fi
  if grep -Eqi 'start-stop-daemon.*not found|dpkg.*start-stop-daemon' "$LOG_FILE"; then
    echo "DIAGNOSIS: damaged/incomplete chroot package state; next attempt must start with lb clean --purge."
  fi
  if grep -Eqi 'Temporary failure resolving|Could not resolve|Connection timed out|Network is unreachable' "$LOG_FILE"; then
    echo "DIAGNOSIS: transient network/repository failure; clean retry with apt retries is safer than changing package sources."
  fi
fi

if [[ "$changed" -eq 1 ]]; then
  git config user.name "github-actions[bot]"
  git config user.email "41898282+github-actions[bot]@users.noreply.github.com"
  git add "$PACKAGE_LIST"
  git commit -m "Auto-repair required KDE Plasma Wayland build packages"
  git push origin "HEAD:${GITHUB_REF_NAME}"
  echo "Repository repair committed and pushed."
else
  echo "No deterministic repository patch was needed."
fi
