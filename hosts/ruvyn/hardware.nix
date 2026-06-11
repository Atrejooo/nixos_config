{
  flake.nixosModules.ruvyn-hardware =
    { pkgs, lib, ... }:
    {
      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      networking.hostName = "ruvyn";

      boot.loader = {
        grub.enable = false;
        systemd-boot.enable = true;
        # set console size
        systemd-boot.consoleMode = "0";
        efi.canTouchEfiVariables = true;
      };

      boot.kernelPackages = pkgs.linuxPackages;
      hardware.enableRedistributableFirmware = true;

      # initial ramdisk
      boot.initrd.availableKernelModules = [
        # from nixos-generate-config
        "nvme"
        "sd_mod"
        "vmd"
        "xhci_pci"
        "thunderbolt"
        "usb_storage"
        "usbhid" # usb keyboard
      ];

      # Needed unfree packages
      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "nvidia-x11"
          "nvidia-settings"
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
        powerManagement.enable = false;
      };

      # Intel CPU updates
      hardware.cpu.intel.updateMicrocode = true;

      # Trim SSD
      services.fstrim.enable = true;

      # Scrub Btrfs
      services.btrfs.autoScrub = {
        enable = true;
        interval = "monthly";
        fileSystems = [ "/" ];
      };

      # Keep /tmp on disk, but clean it on boot
      boot.tmp.cleanOnBoot = true;
    };
}
