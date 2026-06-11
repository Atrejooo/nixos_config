{
  self,
  ...
}:
{
  flake.nixosModules.terminal =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.archiver
      ];
    };

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.archiver = pkgs.writeShellApplication {
        name = "archiver";
        runtimeInputs = with pkgs; [
          p7zip
          gnutar
        ];

        text = ''
          #!/usr/bin/env bash
          set -euo pipefail

          if [ $# -eq 0 ]; then
              echo "Usage: archiver [7z|zip|tar.gz] <files/dirs>"
              echo "If no format given, uses 7z by default"
              exit 1
          fi

          case "$1" in
              7z|zip|tar.gz)
                  format="$1"
                  shift
                  ;;
              *)
                  # first arg is not a format, so default to 7z
                  format="7z"
                  ;;
          esac

          name="archive_$(date +%Y%m%d_%H%M)"

          case "$format" in
              7z)
                  7z a -r -t7z -spf -mx=9 -m0=lzma2 -mfb=64 -md=32m -ms=on "''${name}.7z" -- "$@"
                  ;;
              zip)
                  7z a -r -tzip "''${name}.zip" -- "$@"
                  ;;
              tar.gz)
                  tar czf "''${name}.tar.gz" "$@"
                  ;;
              *)
                  echo "Error: Use 7z, zip, or tar.gz"
                  exit 1
                  ;;
          esac

          echo "Created: ''${name}.''${format}"
        '';
      };
    };
}
