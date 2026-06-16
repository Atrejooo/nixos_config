{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.git ];

      programs.git = {
        enable = true;
        config = {
          pull.rebase = true;
        };
      };
    };
}
