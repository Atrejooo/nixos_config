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
        self.packages.${pkgs.stdenv.hostPlatform.system}.yank-file
      ];
    };

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.yank-file = pkgs.writeShellApplication {
        name = "yank-file";
        runtimeInputs = with pkgs; [
          coreutils
          wl-clipboard
        ];

        text = ''
          #!/usr/bin/env bash
          set -euo pipefail

          if [ "$#" -eq 0 ]; then
            echo "Usage: yank-file <file1> [file2 ...]"
            exit 1
          fi

          uri_list=()

          for file in "$@"; do
            file_path="$(realpath -- "$file" 2>/dev/null || true)"

            if [ ! -e "$file_path" ]; then
              echo "Error: File '$file' does not exist."
              exit 1
            fi

            uri_list+=("file://$file_path")
          done

          tmpfile="$(mktemp)"

          printf "%s\n" "''${uri_list[@]}" > "$tmpfile"

          wl-copy --type text/uri-list < "$tmpfile"

          rm -f "$tmpfile"

          echo "Copied to clipboard:"
          printf "  - %s\n" "''${uri_list[@]}"
        '';
      };
    };
}
