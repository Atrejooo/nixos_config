{
  flake.nixosModules.base =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        pkgs.git
      ];
    };
}
