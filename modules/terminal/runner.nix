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
        self.packages.${pkgs.stdenv.hostPlatform.system}.runner
      ];
    };

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages.runner = pkgs.writeShellApplication {
        name = "r";
        runtimeInputs = with pkgs; [
          fzf
          dex
        ];
        text = ''
          #!/usr/bin/env bash
          selected_app=$(find /run/current-system/sw/share/applications/ | fzf --style=minimal --color='
                                 hl:magenta hl+:magenta
                                 pointer:magenta marker:magenta
                                 header:blue
                                 current-bg:#223344
                                 spinner:cyan info:cyan
                                 prompt:blue query:magenta
                                 border:blue
                                 label:magenta
                               ' --border=sharp --padding=0 --margin=5%,25%,5%,25% --border-label="@ Runner @")

          if [[ -n "$selected_app" ]]; then
              setsid dex "$selected_app" > /dev/null 2> /dev/null &
          fi
        '';
      };
    };
}
