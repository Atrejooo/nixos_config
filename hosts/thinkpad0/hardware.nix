{
  flake.nixosModules.thinkpad0-hardware =
    { pkgs, lib, ... }:
    {
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      # Rename host as you like – here kept similar to original
      networking.hostName = "thinkpad0";

      # Systemd‑boot (UEFI)
      boot.loader = {
        grub.enable = false;
        systemd-boot.enable = true;
        systemd-boot.consoleMode = "0";
        efi.canTouchEfiVariables = true;
        # systemd-boot.edk2-uefi-shell.enable = true;
      };

      # Kernel & firmware
      boot.kernelPackages = pkgs.linuxPackages;
      hardware.enableRedistributableFirmware = true;

      # Initrd modules: include i915 for early Intel GPU modesetting
      boot.initrd.availableKernelModules = [
        "ahci" # SATA controller (usually needed for optical/USB-SATA)
        "nvme" # NVMe SSD
        "sd_mod" # Generic SCSI/SD block device
        "xhci_pci" # USB 3.x host controller
        "rtsx_pci_sdmmc" # for sd card readers
        "usbhid" # USB keyboards
        "usb_storage" # boot from USB (recovery)
        "i915" # Intel GPU early KMS
      ];

      # Unfree packages needed
      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "nvidia-x11"
          "nvidia-settings"
          "steam"
          "steam-unwrapped"
          "bambu-studio"
        ];

      # OpenGL & general graphics
      hardware.graphics.enable = true;

      # NVIDIA Optimus (Intel + MX330) configuration
      services.xserver.videoDrivers = [ "nvidia" ]; # enables the proprietary NVIDIA X driver

      hardware.nvidia = {
        # MX330 (GP108) is Pascal – open kernel modules are not supported.
        # Keep the proprietary driver only.
        open = false;

        # Required for Wayland and for PRIME offloading
        modesetting.enable = true;

        # Power management helps with suspend/resume corruption
        powerManagement.enable = true;
        # Optionally enable fine‑grained power control (supported on Pascal)
        # powerManagement.finegrained = true;

        # PRIME offload: Intel GPU drives the display, NVIDIA is used for on‑demand rendering
        prime = {
          offload.enable = true;

          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:45:0:0";
        };
      };

      # Intel microcode updates
      hardware.cpu.intel.updateMicrocode = true;

      # SSD maintenance
      services.fstrim.enable = true;

      # Btrfs scrubbing (keep if you use Btrfs)
      services.btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
        fileSystems = [ "/" ];
      };

      # Keep /tmp in RAM
      boot.tmp.useTmpfs = true;
    };
}
