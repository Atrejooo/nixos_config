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
          pkgs.wtype

          pkgs.hyprpicker
          pkgs.chameleos
          pkgs.feh
          pkgs.mpv
          # gtk mpv wrapper
          # pkgs.celluloid

          (pkgs.writeShellApplication {
            name = "niri-toggle-chamel";
            runtimeInputs = with pkgs; [
              chameleos
              procps
            ];
            text = ''
              set -euo pipefail
              color="''${1:-#ff3065}"
              if pgrep chameleos > /dev/null 2>&1; then
                pkill chameleos
              else
                chameleos --stroke-color "$color" --stroke-width 5 &
                sleep 0.1
                chamel toggle
              fi
            '';
          })

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

          # Force kills the focused window with SIGKILL, resolving XWayland clients
          (pkgs.writeShellApplication {
            name = "niri-force-kill-focused";
            runtimeInputs = with pkgs; [
              coreutils
              jq
              xprop
            ];
            text = ''
              set -euo pipefail

              pid="$(niri msg --json focused-window | jq -r '.pid // empty')"
              [ -n "$pid" ] || exit 0

              if [ -r "/proc/$pid/comm" ] && grep -qi xwayland "/proc/$pid/comm"; then
                if ! wid="$(xprop -root -notype _NET_ACTIVE_WINDOW 2>/dev/null | grep -o '0x[0-9a-fA-F]\+')" || [ -z "$wid" ]; then
                  exit 0
                fi
                if ! real_pid="$(xprop -id "$wid" -notype _NET_WM_PID 2>/dev/null | grep -oE '[0-9]+')" || [ -z "$real_pid" ]; then
                  exit 0
                fi
              else
                real_pid="$pid"
              fi

              kill -9 "$real_pid"
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

        systemd.user.services = {
          awww = {
            partOf = [ "graphical-session.target" ];
            after = [ "graphical-session.target" ];
            requisite = [ "graphical-session.target" ];
            wantedBy = [ "niri.service" ];
            serviceConfig = {
              Type = "simple";
              ExecStart = "${lib.getExe' pkgs.awww "awww-daemon"}";
            };
          };

          wallpaper = {
            partOf = [ "awww.service" ];
            after = [ "awww.service" ];
            wantedBy = [ "niri.service" ];
            serviceConfig = {
              Type = "oneshot";
              ExecStart = pkgs.writeShellScript "wallpaper" ''
                max_retries=60
                retry=0
                sleep 0.02
                while ! ${lib.getExe' pkgs.awww "awww"} img -t fade --transition-duration 0.5 ${theme.wallpaper}; do
                  retry=$((retry + 1))
                  if [ "$retry" -ge "$max_retries" ]; then
                    exit 1
                  fi
                  sleep 0.02
                done
              '';
            };
          };

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
