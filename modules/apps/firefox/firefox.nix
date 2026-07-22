{
  self,
  ...
}:
{
  flake.nixosModules.firefox =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.firefox
        self.packages.${pkgs.stdenv.hostPlatform.system}.gopen
      ];
    };

  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    {
      packages.firefox = pkgs.wrapFirefox pkgs.firefox-unwrapped (import ./_config.nix lib);
      packages.gopen = pkgs.writeShellApplication {
        name = "gopen";
        text = builtins.readFile ./gopen.sh;
      };
    };
}
