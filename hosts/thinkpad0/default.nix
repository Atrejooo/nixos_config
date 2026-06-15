{
  self,
  inputs,
  shared,
  ...
}:
{
  flake.nixosConfigurations.thinkpad0 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit shared; };
    modules = with self.nixosModules; [
      {
        config.style.theme = "pale";
        config.style.keyboard = "qwerty";
      }
      # thinkpad0-disko
      thinkpad0-hardware
      # home-manager
      base
      terminal
      # desktop
      # desktop-home
      # steam
      # minecraft
    ];
  };
}
