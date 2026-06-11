{
  self,
  ...
}:
{
  flake.nixosModules.base =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    {
      fonts.packages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.mango-font
      ];
    };

  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.mango-font = pkgs.stdenvNoCC.mkDerivation {
        pname = "mango-font";
        version = "1.0";
        # yes a ttf is in fact not an archive...
        # WHY do i have to tell nix that???
        dontUnpack = true;
        src = ./Mango.ttf;

        installPhase = ''
          mkdir -p $out/share/fonts/truetype/
          cp -r $src $out/share/fonts/truetype/Mango.ttf
        '';

        meta = with lib; {
          description = "Mango Font";
          platforms = platforms.all;
        };
      };
    };
}
