#!/usr/bin/env bash

set -e

cd "$(dirname "$0")"

VENTOY_BIN="/opt/ventoy/Ventoy2Disk.sh"

if [[ ! -x "$VENTOY_BIN" ]]; then
    echo "Ventoy not found or not executable at:"
    echo "  $VENTOY_BIN"
    echo
    echo "Install it with:"
    echo "  sudo pacman -S ventoy-bin"
    exit 1
fi

echo "==> Ventoy found:"
echo "    $VENTOY_BIN"
echo

echo "Available disks:"
lsblk -d -o NAME,SIZE,MODEL,TRAN
echo

read -rp "Enter target disk (example: /dev/sdb): " DISK

if [[ ! -b "$DISK" ]]; then
    echo "Invalid block device: $DISK"
    exit 1
fi

echo
echo "WARNING: ALL DATA ON $DISK WILL BE LOST"
read -rp "Type YES to continue: " CONFIRM

if [[ "$CONFIRM" != "YES" ]]; then
    echo "Aborted."
    exit 0
fi

echo
echo "Ventoy Action:"
echo "1) Install"
echo "2) Force install"
echo "3) Update"
echo "4) List info"
read -rp "Choose [1-4]: " ACTION

echo
echo "Options:"
read -rp "Use GPT partition table? [y/N]: " USE_GPT
read -rp "Disable Secure Boot? [y/N]: " DISABLE_SB
read -rp "Preserve space at end (MiB, blank = none): " PRESERVE

OPTS=()
[[ "$USE_GPT" =~ ^[Yy]$ ]] && OPTS+=("-g")
[[ "$DISABLE_SB" =~ ^[Yy]$ ]] && OPTS+=("-S")
[[ -n "$PRESERVE" ]] && OPTS+=("-r" "$PRESERVE")

case "$ACTION" in
    1) CMD="-i" ;;
    2) CMD="-I" ;;
    3) CMD="-u" ;;
    4) CMD="-l" ;;
    *) echo "Invalid option"; exit 1 ;;
esac

echo
echo "==> Running:"
echo "sudo $VENTOY_BIN $CMD ${OPTS[*]} $DISK"
echo

sudo "$VENTOY_BIN" "$CMD" "${OPTS[@]}" "$DISK"

echo
echo "✔ Done."
