#!/usr/bin/env bash
set -euo pipefail

# ── defaults ──────────────────────────────────────
DISK=""
HOST=""
SWAP_SIZE="32G"
LUKS_NAME="crypted"
EFI_LABEL="ESP"
LUKS_PARTLABEL="luks"
USERNAME=""                 # optional – will be asked if not given

# ── usage ─────────────────────────────────────────
usage() {
    cat <<EOF
Usage: $0 --disk <disk> --host <host> [options]

Required:
  --disk          Device to install to (e.g. /dev/nvme0n1)
  --host          NixOS host name (installs github:Atrejooo/nixos_config#<host>)

Optional:
  --swap-size     Swap file size (default: 32G)
  --luks-name     LUKS mapper name (default: crypted)
  --username      Normal user to set password for (will be asked if omitted)
  --help          Show this message
EOF
    exit 1
}

# ── parse arguments ───────────────────────────────
while [[ $# -gt 0 ]]; do
    case "$1" in
        --disk)        DISK="$2"; shift 2;;
        --host)        HOST="$2"; shift 2;;
        --swap-size)   SWAP_SIZE="$2"; shift 2;;
        --luks-name)   LUKS_NAME="$2"; shift 2;;
        --username)    USERNAME="$2"; shift 2;;
        --help|-h)     usage;;
        *)             echo "Unknown option: $1"; usage;;
    esac
done

# ── validation ────────────────────────────────────
if [[ -z "$DISK" || -z "$HOST" ]]; then
    echo "Error: --disk and --host are required."
    usage
fi

# ── safety check (ALWAYS read from terminal) ──────
echo "WARNING: ALL DATA ON ${DISK} WILL BE DESTROYED"
echo "Host: $HOST  |  Flake: github:Atrejooo/nixos_config#${HOST}"
read -p "Continue? (yes/no): " answer </dev/tty
[[ "$answer" == "yes" ]] || exit 1

# ── wipe & partition ──────────────────────────────
wipefs -af "$DISK"

parted --script "$DISK" \
    mklabel gpt \
    mkpart "$EFI_LABEL" fat32 1MiB 513MiB \
    set 1 esp on \
    name 1 "$EFI_LABEL" \
    mkpart "$LUKS_PARTLABEL" 513MiB 100% \
    name 2 "$LUKS_PARTLABEL"

udevadm settle

# ── Wipe partition signatures (old LUKS header) ──
wipefs -af "/dev/disk/by-partlabel/$LUKS_PARTLABEL"
udevadm settle
sleep 1   # let the kernel forget any cached signatures

# ── EFI ───────────────────────────────────────────
mkfs.vfat -F32 "/dev/disk/by-partlabel/$EFI_LABEL"

# ── LUKS (pipe YES to skip the "are you sure?" prompt) ─
echo "YES" | cryptsetup luksFormat "/dev/disk/by-partlabel/$LUKS_PARTLABEL"
cryptsetup open "/dev/disk/by-partlabel/$LUKS_PARTLABEL" "$LUKS_NAME"

# ── Btrfs ─────────────────────────────────────────
mkfs.btrfs -f "/dev/mapper/$LUKS_NAME"

mount "/dev/mapper/$LUKS_NAME" /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@swap

umount /mnt

# ── mount subvolumes ──────────────────────────────
mount -o subvol=@,compress=zstd,noatime \
    "/dev/mapper/$LUKS_NAME" /mnt

mkdir -p /mnt/{home,boot,.swap}

mount -o subvol=@home,compress=zstd,noatime \
    "/dev/mapper/$LUKS_NAME" /mnt/home

mount -o subvol=@swap \
    "/dev/mapper/$LUKS_NAME" /mnt/.swap

mount "/dev/disk/by-partlabel/$EFI_LABEL" /mnt/boot

# ── swapfile ──────────────────────────────────────
truncate -s 0 /mnt/.swap/swapfile
chattr +C /mnt/.swap/swapfile
fallocate -l "$SWAP_SIZE" /mnt/.swap/swapfile
chmod 600 /mnt/.swap/swapfile
mkswap /mnt/.swap/swapfile

# ── install NixOS ─────────────────────────────────
nixos-install --root /mnt --flake "github:Atrejooo/nixos_config#${HOST}"

# ── set passwords (always from terminal) ──────────
if [[ -z "$USERNAME" ]]; then
    read -p "Enter the username for which to set a password: " USERNAME </dev/tty
fi

echo "------------------------------------------------"
echo "Setting passwords for root and ${USERNAME}…"
echo "------------------------------------------------"

nixos-enter --root /mnt -c "passwd root"
nixos-enter --root /mnt -c "passwd $USERNAME"

echo "Done. You can now reboot."
