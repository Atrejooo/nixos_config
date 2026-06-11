{
  flake.nixosModules.base = {
    # add required / useful experimental features
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    # initial version as recommended here https://nixos.org/manual/nixos/stable/options.html#opt-system.stateVersion
    system.stateVersion = "26.05";

    # use rust implementation of sudo
    security.sudo-rs.enable = true;

    # set timezone to CEST
    time.timeZone = "Europe/Berlin";

    # set keymap
    console.earlySetup = true;
    console.keyMap = "de";

    # set locale
    i18n.defaultLocale = "en_GB.UTF-8";
    # (BEWARE: requires a different format with the added /UTF-8)
    i18n.extraLocales = [ "de_DE.UTF-8/UTF-8" ];
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
    };
    # user
    users.users.cephyr = {
      isNormalUser = true;
      description = "Primary user";

      extraGroups = [
        "wheel"
        "networkmanager"
      ];
    };
  };
}
