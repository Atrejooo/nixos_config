{
  flake.nixosModules.terminal =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        pkgs.typst
        pkgs.tinymist
        pkgs.typstyle
        pkgs.typst-live
      ];
    };
}
