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
        self.packages.${pkgs.stdenv.hostPlatform.system}."helix-${config.style.keyboard}-${config.style.theme}"
        pkgs.nixfmt
        pkgs.nixd
        pkgs.netcat-openbsd
      ];
      environment.variables = {
        EDITOR = "hx";
        VISUAL = "hx";
      };
    };

  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      mk =
        keyboard: theme:
        inputs.wrapper-modules.wrappers.helix.wrap {
          inherit pkgs;
          settings = import ./_config.nix {
            inherit lib;
            inherit keyboard;
          };
          languages = import ./_languages.nix;
          themes = import ./_themes.nix shared.themes.${theme};
        };
    in
    {
      packages = shared.mkVariants {
        basename = "helix";
        inherit mk;
      };
    };
}
