{
  flake.nixosModules.pc0-hardware =
    { pkgs, lib, ... }:
    {
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      networking.hostName = "pc0";

      # systemd-boot is chainloaded by the primary boot manager GRUB (external)
      boot.loader = {
        grub.enable = false;
        systemd-boot.enable = true;
        # set console size
        systemd-boot.consoleMode = "0";
        efi.canTouchEfiVariables = true;

        systemd-boot.edk2-uefi-shell.enable = true;

        systemd-boot.windows = {
          "11-home" = {
            title = "Windows 11 Home";
            efiDeviceHandle = "HD1b";
            sortKey = "z_windows";
          };
        };
      };

      boot.kernelPackages = pkgs.linuxPackages;
      hardware.enableRedistributableFirmware = true;

      # initial ramdisk
      boot.initrd.availableKernelModules = [
        "ahci" # standard SATA controllers
        "nvme" # disk
        "sd_mod" # maybe not needed?
        "xhci_pci" # usb controller
        "usbhid" # keyboard
        "usb_storage" # boot from usb (helpful for recovery, unused normally)
      ];

      # Needed unfree packages
      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "nvidia-x11"
          "nvidia-settings"
          "steam"
          "steam-unwrapped"
          "bambu-studio"
        ];
      # Enable OpenGL
      hardware.graphics = {
        enable = true;
      };

      # Load nvidia driver for Xorg and Wayland
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        # Turing or newer has open drivers.
        open = true;

        # Modesetting is required.
        modesetting.enable = true;

        # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/.
        powerManagement.enable = true;
      };

      # AMD CPU updates
      hardware.cpu.intel.updateMicrocode = true;

      # Trim SSD
      services.fstrim.enable = true;

      # Scrub Btrfs
      services.btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
        fileSystems = [ "/" ];
      };

      # Keep /tmp in RAM
      boot.tmp.useTmpfs = true;
    };
}
