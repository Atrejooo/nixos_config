{
  flake.nixosModules.base =
    { pkgs, ... }:
    {
      environment.systemPackages = [ pkgs.git ];

      # TODO set git config --global init.defaultBranch to main

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
