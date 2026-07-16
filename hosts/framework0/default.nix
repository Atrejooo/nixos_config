{
  self,
  inputs,
  shared,
  ...
}:
{
  flake.nixosConfigurations.framework0 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit shared; };
    modules = with self.nixosModules; [
      {
        config.style.theme = "pale";
        config.style.keyboard = "qwerty";
      }
      framework0-hardware
      home-manager
      base
      terminal
      desktop
      # desktop-home
      # steam
      # minecraft
    ];
  };
}
