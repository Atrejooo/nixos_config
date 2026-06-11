{
  self,
  inputs,
  shared,
  ...
}:
{
  flake.nixosConfigurations.pc0 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit shared; };
    modules = with self.nixosModules; [
      {
        config.style.theme = "pale";
        config.style.keyboard = "qwerty";
        config.desktop.outputs = {
          "DP-2" = {
            mode = "2560x1440@165.001";
            scale = 1.2;
          };
        };
      }
      pc0-disko
      pc0-hardware
      home-manager
      base
      terminal
      desktop
      steam
      minecraft
    ];
  };
}
