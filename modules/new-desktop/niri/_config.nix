{
  config,
  theme,
  ...
}:
/* kdl */ ''
  ${config.new-desktop.niri.extra}
  ${import ./_layout.nix { inherit theme; }}
  ${import ./_rules.nix}
  ${import ./_binds.nix}
  ${import ./_input.nix}

  spawn-at-startup "waybar"

  screenshot-path "~/me/imgs/screenshots/screenshot_%Y_%m_%d_%H_%M_%S.png"

  // no client side decorations
  prefer-no-csd

  workspace "1"
  workspace "2"
  workspace "3"
  workspace "4"
  workspace "5"

  cursor {
      xcursor-theme "BreezeX-RosePine-Linux"
      xcursor-size 24
      hide-when-typing
      hide-after-inactive-ms 3000
  }

  overview {
      zoom 0.35
      workspace-shadow {
          // off
          softness 40
          spread 10
          offset x=0 y=10
          color "#${theme.darkBase}50"
      }
  }

  gestures {
      hot-corners {
          off
      }
  }
  hotkey-overlay {
      skip-at-startup
  }
  switch-events {
      lid-close { spawn "veila" "lock" "--wait-ready"; }
  }
''
