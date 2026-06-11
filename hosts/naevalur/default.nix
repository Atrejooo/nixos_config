{
  self,
  inputs,
  shared,
  ...
}:
{
  flake.nixosConfigurations.naevalur = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit shared; };
    modules = with self.nixosModules; [
      {
        config.style.theme = "celeste";
        config.style.keyboard = "colemak";
      }
      naevalur-disko
      naevalur-hardware
      home-manager
      base
      terminal
      desktop
      steam
      minecraft
    ];
  };
}
