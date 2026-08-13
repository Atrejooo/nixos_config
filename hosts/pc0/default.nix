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
        config.style.theme = "forest";
        config.style.keyboard = "qwerty";
        config.new-desktop.niri.extra = /* kdl */ ''
          output "DP-3" {
              mode "2560x1440@165.001"
              scale 1.2
              position x=0 y=1200
          }
          output "DP-2" {
              mode "2560x1440@165.001"
              scale 1.2
              transform "180"
              position x=0 y=0
          }
        '';
      }

      pc0-disko
      pc0-hardware

      base
      terminal
      new-desktop
      home-manager

      # desktop apps
      firefox
      signal

      # agents
      opencode

      # games
      steam
      r2modman
      minecraft
    ];
  };
}
