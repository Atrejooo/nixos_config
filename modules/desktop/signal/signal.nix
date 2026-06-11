{
  flake.nixosModules.desktop =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        pkgs.signal-desktop
      ];
    };

}
