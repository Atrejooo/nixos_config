{
  flake.nixosModules.terminal =
    {
      pkgs,
      ...
    }:
    {
      services.udisks2.enable = true;
      environment.systemPackages = [
        pkgs.bat
        pkgs.btop
        pkgs.dust
        pkgs.fd
        pkgs.fzf
        pkgs.python3
        pkgs.ripgrep
        pkgs.tig
        pkgs.tokei
      ];
    };
}
