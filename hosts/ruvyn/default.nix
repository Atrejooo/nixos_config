{
  self,
  inputs,
  shared,
  ...
}:
{
  flake.nixosConfigurations.ruvyn = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit shared; };
    modules = with self.nixosModules; [
      {
        config.style.theme = "celeste";
        config.style.keyboard = "colemak";
      }
      ruvyn-disko
      ruvyn-hardware
      home-manager
      base
      terminal
      desktop
    ];
  };
}
