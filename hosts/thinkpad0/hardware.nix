{ inputs, ... }:
{
  flake.nixosModules.thinkpad0-hardware =
    { pkgs, lib, ... }:
    {
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      networking.hostName = "thinkpad0";

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
        "ahci"
        "nvme"
        "sd_mod"
        "xhci_pci"
        "rtsx_pci_sdmmc"
        "usbhid"
        "usb_storage"
        "i915"
      ];

      # -- LUKS ------------------------------
      boot.initrd.luks.devices.crypted = {
        device = "/dev/disk/by-partlabel/luks"; # matches label in install.sh
        allowDiscards = true;
      };

      # -- Filesystems -----------------------
      fileSystems."/" = {
        device = "/dev/mapper/crypted"; # matches label in install.sh
        fsType = "btrfs";
        options = [
          "subvol=@"
          "compress=zstd"
          "noatime"
        ];
      };

      fileSystems."/home" = {
        device = "/dev/mapper/crypted";
        fsType = "btrfs";
        options = [
          "subvol=@home"
          "compress=zstd"
          "noatime"
        ];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-partlabel/ESP"; # matches label in install.sh
        fsType = "vfat";
        options = [ "umask=0077" ]; # correct accessablility rights
      };

      fileSystems."/.swap" = {
        device = "/dev/mapper/crypted";
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

      # -- Unfree packages -------------------
      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "nvidia-x11"
          "nvidia-settings"
          "nvidia-kernel-modules"
          "steam"
          "steam-unwrapped"
          "bambu-studio"
        ];

      # -- Graphics --------------------------
      hardware.graphics.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        open = false;
        modesetting.enable = true;
        powerManagement.enable = true;
        prime = {
          offload.enable = true;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:45:0:0";
        };
      };

      # -- CPU & SSD maintenance -------------
      hardware.cpu.intel.updateMicrocode = true;
      services.fstrim.enable = true;

      services.btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
        fileSystems = [ "/" ];
      };

      boot.tmp.useTmpfs = true;
    };
}
