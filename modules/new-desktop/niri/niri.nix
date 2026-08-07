{
  self,
  inputs,
  shared,
  ...
}:
{
  flake.nixosModules.new-desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      theme = shared.themes.${config.style.theme};

      wallpaper =
        if config.style.theme == "pale" then
          ../../desktop/wallpapers/nature_of_fear.png
        else if config.style.theme == "forest" then
          ../../desktop/wallpapers/forest_light.jpg
        else
          ../../desktop/wallpapers/nature_of_fear.png;

      wallpaper-layer =
        { namespace, image }:
        {
          "awww-${namespace}" = {
            partOf = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            requisite = [ "graphical-session.target" ];
            wantedBy = [ "niri.service" ];
            serviceConfig = {
              Type = "simple";
              ExecStart = "${lib.getExe' pkgs.awww "awww-daemon"} --no-cache --namespace ${namespace}";
            };
          };
          "wallpaper-${namespace}" = {
            partOf = [ "awww-${namespace}.service" ];
            after = [ "awww-${namespace}.service" ];
            wantedBy = [ "niri.service" ];
            serviceConfig = {
              Type = "oneshot";
              ExecStart = pkgs.writeShellScript "wallpaper-${namespace}" ''
                max_retries=60
                retry=0
                sleep 0.02
                while ! ${lib.getExe' pkgs.awww "awww"} img -t center --transition-duration 0.5 --namespace ${namespace} ${image}; do
                  retry=$((retry + 1))
                  if [ "$retry" -ge "$max_retries" ]; then
                    exit 1
                  fi
                  sleep 0.02
                done
              '';
            };
          };
        };
    in
    {
      options.new-desktop.niri = {
        extra = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "Extra kdl settings";
        };
      };

      config = {
        environment.systemPackages = [
          pkgs.awww
          pkgs.brightnessctl
          pkgs.hyprpicker
          pkgs.jq
          pkgs.playerctl
          pkgs.rose-pine-cursor
          pkgs.slurp
          pkgs.swayidle
          pkgs.wl-clipboard
          pkgs.wl-mirror
          pkgs.wlsunset
          pkgs.xwayland-satellite
        ];

        services.keyd = {
          enable = true;
          keyboards = {
            default = {
              ids = [ "*" ];
              settings = {
                main = {
                  capslock = "esc";
                };
              };
            };
          };
        };

        programs.niri = {
          enable = true;
          package = inputs.wrapper-modules.wrappers.niri.wrap {
            inherit pkgs;
            "config.kdl" = {
              content = import ./_config.nix {
                inherit lib config theme;
              };
            };
          };
        };

        systemd.user.services =
          wallpaper-layer {
            namespace = "backdrop";
            image = wallpaper;
          }
          // {
            swayidle = {
              partOf = [ "graphical-session.target" ];
              after = [ "graphical-session.target" ];
              requisite = [ "graphical-session.target" ];
              wantedBy = [ "niri.service" ];
              serviceConfig = {
                Type = "simple";
                ExecStart = "${lib.getExe pkgs.swayidle} -w timeout 300 'veila lock --wait-ready' timeout 500 'niri msg action power-off-monitors' timeout 600 'systemctl suspend'";
              };
            };
          };

        login.sessionCommand = "niri-session";
      };
    };
}
