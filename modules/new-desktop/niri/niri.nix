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
        toggleOutputScale = lib.mkOption {
          type = lib.types.float;
          default = 1.0;
          description = "Output scale to toggle to via the bind";
        };
        browser-cmd = lib.mkOption {
          type = lib.types.str;
          default = "zen";
          description = "output settings for niri";
        };
      };

      config = {
        environment.systemPackages = [
          pkgs.awww
          pkgs.rose-pine-cursor

          pkgs.brightnessctl
          pkgs.playerctl
          pkgs.pavucontrol

          pkgs.swayidle

          pkgs.xwayland-satellite

          pkgs.wl-clipboard
          pkgs.wl-mirror
          pkgs.wlsunset

          pkgs.hyprpicker
          pkgs.feh
          pkgs.mpv
          # gtk mpv wrapper
          # pkgs.celluloid

          # Toggles output scale of the focused output in niri from toggleOutputScale to configured scale
          (pkgs.writeShellApplication {
            name = "niri-toggle-output-scale";
            runtimeInputs = with pkgs; [
              coreutils
              jq
            ];
            text = ''
              set -euo pipefail

              toggle_scale="${toString config.new-desktop.niri.toggleOutputScale}"

              name="$(niri msg --json focused-output | jq -r .name)"
              state_dir="''${XDG_RUNTIME_DIR:-/tmp}/niri-scale-toggle"
              state_file="$state_dir/$name"
              mkdir -p "$state_dir"

              if [ -f "$state_file" ]; then
                target="$(cat "$state_file")"
                rm -f "$state_file"
              else
                original="$(niri msg --json outputs | jq -r --arg name "$name" '.[$name].logical.scale')"
                printf '%s\n' "$original" > "$state_file"
                target="$toggle_scale"
              fi

              niri msg output "$name" scale "$target"
            '';
          })
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
            image = theme.wallpaper;
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
