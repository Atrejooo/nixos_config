# Banish disko from pc0

Migrate `pc0` from a disko-declared disk layout to a plain `hardware.nix`
(like `framework0` / `thinkpad0`) **without reinstalling**. This also
renames the GPT partition labels on the live disk so pc0 uses the same
`shared.installLabels` convention as the other hosts.

## Current state (verified on the live machine)

`/dev/nvme1n1` (disk name `main` in disko):

| partition | partlabel today | fs | mount |
|---|---|---|---|
| nvme1n1p1 (512M) | `disk-main-ESP` | vfat | `/boot` |
| nvme1n1p2 | `disk-main-luks` | crypto_LUKS, mapper `crypted` → btrfs | — |

Btrfs subvolumes (inside `crypted`):

| subvol | mountpoint | needed at boot |
|---|---|---|
| `@` | `/` | yes |
| `@nix` | `/nix` | yes |
| `@log` | `/var/log` | yes |
| `@home` | `/home` | no |
| `@cache` | `/var/cache` | no |
| `swap` | `/.swap` | no (swapfile `/.swap/swapfile`, 32G) |

disko generates GPT partition labels as
`<parent.type>-<disk.name>-<partition.name>`, i.e. `disk-main-ESP` /
`disk-main-luks`. It does **not** use the plain `ESP` / `luks` labels from
`install/_labels.nix` — that's why `shared.installLabels` can't be used on
pc0 until the partitions are relabeled.

## Goals

1. Drop the `pc0-disko` module; pc0's filesystem is declared in
   `hosts/pc0/hardware.nix` like every other host.
2. Relabel the partitions to `ESP` / `luks` (matching `shared.installLabels`).
3. Keep the existing subvolume layout (no restructuring — `@nix`, `@log`,
   `@cache` stay; only `@home` and the swap subvol are "really" needed, but
   re-arranging them is out of scope for this migration).
4. No reinstall, no data loss.

## Repo changes

### `hosts/pc0/hardware.nix`

Keep everything that's already there (systemd-boot + Windows chainload,
kernel modules, nvidia, intel microcode, fstrim, btrfs autoScrub, tmpfs).

- add `shared` to the module function args and `let l = shared.installLabels;`
- append the LUKS / filesystems / swap block replicating the current layout
  exactly:

```nix
      # -- LUKS ------------------------------
      boot.initrd.luks.devices.${l.luksName} = {
        device = "/dev/disk/by-partlabel/${l.luksPartlabel}";
        allowDiscards = true;
      };

      # -- Filesystems -----------------------
      fileSystems."/" = {
        device = "/dev/mapper/${l.luksName}";
        fsType = "btrfs";
        options = [ "subvol=@" "compress=zstd" "noatime" ];
      };

      fileSystems."/home" = {
        device = "/dev/mapper/${l.luksName}";
        fsType = "btrfs";
        options = [ "subvol=@home" "compress=zstd" "noatime" ];
      };

      fileSystems."/nix" = {
        device = "/dev/mapper/${l.luksName}";
        fsType = "btrfs";
        options = [ "subvol=@nix" "compress=zstd" "noatime" ];
        neededForBoot = true;
      };

      fileSystems."/var/log" = {
        device = "/dev/mapper/${l.luksName}";
        fsType = "btrfs";
        options = [ "subvol=@log" "compress=zstd" "noatime" ];
        neededForBoot = true;
      };

      fileSystems."/var/cache" = {
        device = "/dev/mapper/${l.luksName}";
        fsType = "btrfs";
        options = [ "subvol=@cache" "compress=zstd" "noatime" ];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-partlabel/${l.efiLabel}";
        fsType = "vfat";
        options = [ "umask=0077" ];
      };

      fileSystems."/.swap" = {
        device = "/dev/mapper/${l.luksName}";
        fsType = "btrfs";
        options = [ "subvol=swap" ];
        neededForBoot = false;
      };

      # -- Swap ------------------------------
      swapDevices = [ { device = "/.swap/swapfile"; } ];
```

Notes:

- `shared.installLabels` = `{ luksPartlabel = "luks"; efiLabel = "ESP"; luksName = "crypted"; }`
  (`install/_labels.nix`) — the mapper name `crypted` already matches.
- `neededForBoot = true` on `/`, `/nix`, `/var/log` matches the current
  fstab's `x-initrd.mount`. `/` defaults to `neededForBoot = true`.
- the swap subvol is literally named `swap` (no `@`), so `subvol=swap`.

### `hosts/pc0/default.nix`

Replace `pc0-disko` with `pc0-hardware`.

### `hosts/pc0/disko.nix`

Delete.

### `flake.nix`

Remove the `disko` input; prune it from `flake.lock` with `nix flake lock`.

### `hosts/pc0/install-config.nix` (new)

```nix
{ ... }: {
  hostInstall.pc0 = {
    diskDevice = "/dev/nvme1n1";
    swapSize = "32G";
    username = "aki";
  };
}
```

Lets pc0 be installed with `nix run .#install -- --host pc0` like the other
hosts.

### `README.md`

Update the disko references:

- line 24: drop "disko is used for declarative disk layout"
- lines 43-46: hosts section (hardware.nix / default.nix / install-config.nix,
  no more `<host>-disko`)
- line 90: "existing hosts" — pc0 is no longer "for Disko"
- lines 116-129: remove the "With Disko" installation section

## Live migration

> **Order is critical:** relabel → `nixos-rebuild switch` → reboot.
> Do **not** reboot between relabeling and the switch — the old disko
> config still references `disk-main-*` and would fail to boot.
> Relabeling GPT partition names is pure metadata; no data is touched and
> it's reversible (`sgdisk --change-name=1:disk-main-ESP` etc.).

1. Pull the updated flake:
   ```
   cd /etc/nixos && sudo git pull
   ```

2. Rename the GPT partition labels:
   ```
   sudo nix shell nixpkgs#gptfdisk -c sgdisk --change-name=1:ESP --change-name=2:luks /dev/nvme1n1
   sudo udevadm trigger --subsystem-match=block && sudo udevadm settle
   ls /dev/disk/by-partlabel/   # expect ESP and luks now
   ```
   If the symlinks are stale:
   ```
   sudo nix shell nixpkgs#parted -c "partprobe /dev/nvme1n1"
   ```

3. Sanity-check the subvolumes still line up:
   ```
   sudo btrfs subvolume list /
   ```

4. Switch to the new config (regenerates fstab + initrd with `ESP` / `luks`):
   ```
   sudo nixos-rebuild switch --flake .#pc0
   ```

5. Verify `/boot` now resolves via the new label:
   ```
   findmnt /boot
   ```

6. Reboot, then verify:
   ```
   findmnt
   swapon --show
   lsblk -f
   sudo btrfs subvolume list /
   ```

## Verification checklist

- [ ] `nix flake check` passes after removing the disko input
- [ ] `/dev/disk/by-partlabel/ESP` and `.../luks` exist
- [ ] fstab shows `subvol=@`, `@home`, `@nix`, `@log`, `@cache`, `swap`
- [ ] `/boot` mounted from `/dev/disk/by-partlabel/ESP` (vfat, `umask=0077`)
- [ ] swapfile active after reboot
- [ ] `lsblk` shows the relabeled partitions

## Rollback

- If a boot fails after the switch, pick an older generation from the
  systemd-boot menu.
- The label rename is reversible:
  ```
  sudo nix shell nixpkgs#gptfdisk -c sgdisk --change-name=1:disk-main-ESP --change-name=2:disk-main-luks /dev/nvme1n1
  ```
  (then switch back to a config that references `disk-main-*`).
- No filesystem data is modified at any point during this migration.
