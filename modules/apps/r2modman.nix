{
  flake.nixosModules.r2modman = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.r2modman
    ];
  };
}
