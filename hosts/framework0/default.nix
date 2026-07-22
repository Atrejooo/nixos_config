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
        config.style.theme = "forest";
        config.style.keyboard = "qwerty";
        config.new-desktop.niri.extra = ''
          output "eDP-1" {
              scale 1.5
          }
        '';
      }
      framework0-hardware
      home-manager
      base
      terminal
      # desktop
      new-desktop
      firefox
      opencode
      # steam
      # minecraft
    ];
  };
}
