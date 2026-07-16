{
  flake.nixosModules.framework0-hardware =
    { shared, pkgs, lib, ... }: let
      l = shared.installLabels;
    in
    {
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      networking.hostName = "framework0"; # needs to match host module name!

      # -- Boot loader -----------------------
      boot.loader = {
        grub.enable = false;
        systemd-boot.enable = true;
        systemd-boot.consoleMode = "0";
        efi.canTouchEfiVariables = true;
      };

      # -- Kernel & firmware -----------------
      boot.kernelPackages = pkgs.linuxPackages;
      hardware.enableRedistributableFirmware = true;
      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usb_storage"
        "sd_mod"
      ];

      # Workaround for panel self-refresh (PSR) hangs
      # https://community.frame.work/t/fedora-kde-becomes-suddenly-slow/58459
      # https://gitlab.freedesktop.org/drm/amd/-/issues/3647
      boot.kernelParams = [ "amdgpu.dcdebugmask=0x10" ];

      # -- Unfree packages -------------------
      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "steam"
          "steam-unwrapped"
          "bambu-studio"
        ];

      # -- Graphics --------------------------
      hardware.graphics = {
        enable = true;
        enable32Bit = true; # for Steam/proton
      };
      hardware.amdgpu.initrd.enable = true;

      # -- Power management -------------------
      services.power-profiles-daemon.enable = true;
      services.fwupd.enable = true;

      # -- CPU & SSD maintenance -------------
      hardware.cpu.amd.updateMicrocode = true;
      services.fstrim.enable = true;

      services.btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
        fileSystems = [ "/" ];
      };

      boot.tmp.useTmpfs = true;

      # -- LUKS ------------------------------
      boot.initrd.luks.devices.${l.luksName} = {
        device = "/dev/disk/by-partlabel/${l.luksPartlabel}";
        allowDiscards = true;
      };

      # -- Filesystems -----------------------
      fileSystems."/" = {
        device = "/dev/mapper/${l.luksName}";
        fsType = "btrfs";
        options = [
          "subvol=@"
          "compress=zstd"
          "noatime"
        ];
      };

      fileSystems."/home" = {
        device = "/dev/mapper/${l.luksName}";
        fsType = "btrfs";
        options = [
          "subvol=@home"
          "compress=zstd"
          "noatime"
        ];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-partlabel/${l.efiLabel}";
        fsType = "vfat";
        options = [ "umask=0077" ]; # correct accessablility rights
      };

      fileSystems."/.swap" = {
        device = "/dev/mapper/${l.luksName}";
        fsType = "btrfs";
        options = [ "subvol=@swap" ];
        neededForBoot = false; # not needed at boot
      };

      # -- Swap ------------------------------
      swapDevices = [
        {
          device = "/.swap/swapfile";
          # optional: size is already fixed, but you can add:
          # size = 32768; # 32G in MiB
        }
      ];

    };
}
