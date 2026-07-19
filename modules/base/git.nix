{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.git ];

      programs.git = {
        enable = true;
        config = {
          pull.rebase = true;
          user = {
            name = "aki";
            email = "wouldnt.you@like2.know";
          };
        };
      };
    };
}
