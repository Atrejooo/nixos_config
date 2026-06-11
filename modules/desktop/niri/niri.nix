{
  self,
  inputs,
  shared,
  ...
}:
{
  flake.nixosModules.desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      wallpaper =
        if config.style.theme == "pale" then
          ../wallpapers/nature_of_fear.png
        else
          ../wallpapers/nature_of_fear.png;
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
      environment.systemPackages = [
        pkgs.hyprpicker
        pkgs.wl-clipboard
        pkgs.wlsunset
        pkgs.xwayland-satellite
        pkgs.grim
        pkgs.slurp
        pkgs.swayidle
        pkgs.awww
        pkgs.brightnessctl
        pkgs.rose-pine-cursor
        pkgs.wl-mirror
        pkgs.jq
      ];
      programs.niri = {
        enable = true;
        package =
          self.packages.${pkgs.stdenv.hostPlatform.system}."niri-${config.style.keyboard}-${config.style.theme}";
      };
      # Launch the awww daemon and set the wallpaper
      systemd.user.services =
        wallpaper-layer {
          namespace = "backdrop";
          image = wallpaper;
        }
        # swayidle idle daemon
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
      # Set the login command to launch niri
      login.sessionCommand = "niri-session";
    };

  perSystem =
    {
      pkgs,
      ...
    }:
    let
      mk =
        keyboard: theme:
        inputs.wrapper-modules.wrappers.niri.wrap {
          inherit pkgs;
          settings = {
            cursor = {
              xcursor-theme = "BreezeX-RosePine-Linux";
              xcursor-size = 24;
              hide-after-inactive-ms = 1000;
            };
            overview = {
              zoom = 0.35;
            };
            # laptop switches
            switch-events = {
              lid-close = {
                spawn = [
                  "veila"
                  "lock"
                  "--wait-ready"
                ];
              };
            };
            gestures.hot-corners.off = _: { };
            hotkey-overlay.skip-at-startup = _: { };
            prefer-no-csd = _: { };
            screenshot-path = "~/pictures/screenshots/screenshot_%Y-%m-%d_%H-%M-%S.png";
            animations = {
              slowdown = 0.8;
            };
            workspaces = {
              "1" = _: { };
              "2" = _: { };
              "3" = _: { };
              "4" = _: { };
              "5" = _: { };
            };

            spawn-at-startup = [ "waybar" ];
            spawn-sh-at-startup = [ ];
            input = import ./_input.nix;
            layout = import ./_layout.nix shared.themes.${theme};
            binds = import ./_binds.nix keyboard;
            window-rules = import ./_window_rules.nix;
            layer-rules = import ./_layer_rules.nix;
          };
        };
    in
    {
      packages = shared.mkVariants {
        basename = "niri";
        inherit mk;
      };
    };
}
