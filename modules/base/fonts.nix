{
  flake.nixosModules.base =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      fonts.packages = [
        pkgs.nerd-fonts.symbols-only
      ];
    };
}
