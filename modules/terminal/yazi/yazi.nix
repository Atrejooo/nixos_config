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
        self.packages.${pkgs.stdenv.hostPlatform.system}."yazi-${config.style.keyboard}-${config.style.theme}"
        pkgs.dragon-drop
        pkgs.gzip
        pkgs.p7zip
      ];
    };

  perSystem =
    {
      pkgs,
      ...
    }:
    let
      mk =
        keyboard: theme:
        inputs.wrapper-modules.wrappers.yazi.wrap {
          inherit pkgs;
          settings = {
            yazi = import ./_config.nix;
            keymap = import ./_keymap.nix keyboard;
            theme = import ./_theme.nix shared.themes.${theme};
          };
        };
    in
    {
      packages = shared.mkVariants {
        basename = "yazi";
        inherit mk;
      };
    };
}
