{
  self,
  inputs,
  shared,
  ...
}:
{
  flake.nixosConfigurations.pc_0 = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit shared; };
    modules = with self.nixosModules; [
      {
        config.style.theme = "pale";
        config.style.keyboard = "qwerty";
      }
      pc_0-disko
      pc_0-hardware
      home-manager
      base
      terminal
      desktop
      steam
      minecraft
    ];
  };
}
