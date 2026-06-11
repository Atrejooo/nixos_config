{
  self,
  shared,
  inputs,
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
        self.packages.${pkgs.stdenv.hostPlatform.system}."zellij-${config.style.keyboard}-${config.style.theme}"
      ];
    };

  perSystem =
    { pkgs, ... }:
    let
      kdlFormat = inputs.wrapper-modules.lib.toKdl;
      mk =
        keyboard: theme:
        let
          configContent = kdlFormat (_: {
            version = 1;
            content = import ./_config.nix {
              theme = shared.themes.${theme};
              keyboard = shared.keyboards.${keyboard};
              layout_dir = ./layouts;
            };
          });
          configPath = pkgs.writeText "config.kdl" configContent;
        in
        inputs.wrapper-modules.lib.wrapPackage {
          inherit pkgs;
          package = pkgs.zellij;
          flags = {
            "--config" = "${configPath}";
          };
        };
    in
    {
      packages = shared.mkVariants {
        basename = "zellij";
        inherit mk;
      };
    };
}
