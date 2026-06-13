{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.terminal =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.fish
        pkgs.zoxide
      ];
    };

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.fish = inputs.wrapper-modules.wrappers.fish.wrap {
        inherit pkgs;
        flags."--no-config" = false;
        configFile.content = builtins.readFile ./config.fish;
        abbreviations = {
          nixos-add = "sudo git -C /etc/nixos add";
          nixos-commit = "sudo git -C /etc/nixos commit -m";
          nixos-edit = "cd /etc/nixos && sudo zellij";
          nixos-gcc = "sudo nix-collect-garbage --delete-older-than 10d";
          nixos-paste = "wl-paste | sudo tee /etc/nixos/.paste > /dev/null";
          nixos-read = "cd /etc/nixos && zellij";
          nixos-status = "sudo git -C /etc/nixos status";
          nixos-switch = "sudo nixos-rebuild switch --flake /etc/nixos";
          nixos-test = "sudo nixos-rebuild test --flake /etc/nixos";
        };
      };
    };
}
