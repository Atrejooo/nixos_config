{
  self,
  ...
}:
{
  flake.nixosModules.goose =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.goose-cli
      ];
    };

  perSystem =
    { pkgs, ... }:
    {
      packages.goose-cli = pkgs.callPackage ../../pkgs/goose-cli/package.nix { };
    };
}
