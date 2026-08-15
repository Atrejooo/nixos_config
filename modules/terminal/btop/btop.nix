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
      config,
      ...
    }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}."btop-${config.style.theme}"
      ];
    };

  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      mk =
        theme:
        inputs.wrapper-modules.wrappers.btop.wrap {
          inherit pkgs;
          settings = import ./_config.nix theme;
          themes = import ./_theme.nix {
            inherit lib;
            name = theme;
            theme = shared.themes.${theme};
          };
        };
    in
    {
      packages = shared.mkThemeVariants {
        basename = "btop";
        inherit mk;
      };
    };
}
