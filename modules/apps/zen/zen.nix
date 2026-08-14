{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.zen =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.zen-browser
      ];
    };

  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    {
      packages.zen-browser =
        pkgs.wrapFirefox inputs.zen-browser.packages.${system}.zen-browser-unwrapped
          (import ./_config.nix lib);
    };
}
