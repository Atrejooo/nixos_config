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
          "DP-3" = {
            mode = "2560x1440@165.001";
            scale = 1.2;
          };
          "DP-2" = {
            mode = "2560x1440@165.001";
            scale = 1.2;
            transform = "180";
            position = _: {
              props.x = 0;
              props.y = -1200;
            };
          };
        };
      }
      pc0-disko
      pc0-hardware
      home-manager
      base
      terminal
      desktop
      # desktop-home
      steam
      minecraft
    ];
  };
}
