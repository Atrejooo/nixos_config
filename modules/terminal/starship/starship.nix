{
  self,
  inputs,
  shared,
  ...
}:
{
  flake.nixosModules.terminal =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}."starship-${config.style.theme}"
      ];
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    let
      mk =
        theme:
        inputs.wrapper-modules.wrappers.starship.wrap {
          inherit pkgs;
          settings = import ./_config.nix shared.themes.${theme};
        };
    in
    {
      packages = shared.mkThemeVariants {
        basename = "starship";
        inherit mk;
      };
    };
}
