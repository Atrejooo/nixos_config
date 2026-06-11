{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.base =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.fastfetch
      ];
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.fastfetch = inputs.wrapper-modules.wrappers.fastfetch.wrap {
        settings = import ./_config.nix lib;
        inherit pkgs;
      };
    };
}
