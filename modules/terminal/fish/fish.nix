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
          nixos-test = "sudo nixos-rebuild test --flake /etc/nixos";
          nixos-switch = "sudo nixos-rebuild switch --flake /etc/nixos";
          nixos-status = "sudo git -C /etc/nixos status";
          nixos-add = "sudo git -C /etc/nixos add";
          nixos-commit = "sudo git -C /etc/nixos commit -m";
          nixos-edit = "sudo hx /etc/nixos";
        };
      };
    };
}
