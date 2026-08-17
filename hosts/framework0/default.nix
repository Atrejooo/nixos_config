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
        config.new-desktop.niri.browser-cmd = "firefox";
        config.new-desktop.niri.extra = /* kdl */ ''
          output "eDP-1" {
              scale 1.5
          }
        '';
      }
      framework0-hardware

      base
      terminal
      new-desktop
      home-manager

      # desktop apps
      zen
      firefox
      signal

      # agents
      opencode

      # games
      steam
      # minecraft
    ];
  };
}
