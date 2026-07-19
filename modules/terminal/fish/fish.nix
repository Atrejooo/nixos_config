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
        abbreviations = rec {
          nixos-add = "git -C ~/.nixos add";
          nixos-commit = "git -C ~/.nixos commit -m";
          nixos-edit = "cd ~/.nixos && zellij";
          nixos-gcc = "sudo nix-collect-garbage --delete-older-than 10d";
          nixos-status = "git -C ~/.nixos status";
          nixos-switch = "sudo nixos-rebuild switch --flake ~/.nixos";
          nixos-test = "sudo nixos-rebuild test --flake ~/.nixos";
          nixos-update = "cd ~/.nixos && sudo nix flake update && ${nixos-switch}";
        };
      };
    };
}
