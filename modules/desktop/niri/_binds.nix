keyboard:
let
  colemak = {
    "Mod+N".focus-column-left = _: { };
    "Mod+E".focus-window-down = _: { };
    "Mod+I".focus-window-up = _: { };
    "Mod+O".focus-column-right = _: { };
    "Mod+Ctrl+N".move-column-left = _: { };
    "Mod+Ctrl+E".move-window-down = _: { };
    "Mod+Ctrl+I".move-window-up = _: { };
    "Mod+Ctrl+O".move-column-right = _: { };
    "Mod+Shift+N".set-column-width = "-10%";
    "Mod+Shift+E".set-window-height = "+10%";
    "Mod+Shift+I".set-window-height = "-10%";
    "Mod+Shift+O".set-column-width = "+10%";

  };
  qwerty = {
    "Mod+H".focus-column-left = _: { };
    "Mod+J".focus-window-down = _: { };
    "Mod+K".focus-window-up = _: { };
    "Mod+L".focus-column-right = _: { };
    "Mod+Ctrl+H".move-column-left = _: { };
    "Mod+Ctrl+J".move-window-down = _: { };
    "Mod+Ctrl+K".move-window-up = _: { };
    "Mod+Ctrl+L".move-column-right = _: { };
    "Mod+Shift+H".set-column-width = "-10%";
    "Mod+Shift+J".set-window-height = "+10%";
    "Mod+Shift+K".set-window-height = "-10%";
    "Mod+Shift+L".set-column-width = "+10%";

  };
  base = {
    # toggle input inhibition for stuff like virtual or remote machines
    "Mod+Escape" = _: {
      props.allow-inhibiting = false;
      content.toggle-keyboard-shortcuts-inhibit = _: { };
    };

    # top row left
    "Mod+Q".spawn-sh = "alacritty -e yazi";
    "Mod+Shift+Q".spawn-sh = "kitty -e yazi";
    "Mod+W".spawn = "firefox";
    "Mod+F".spawn = "alacritty";
    "Mod+P".spawn-sh = "alacritty -e sh -c \"r && sleep 0.1\"";
    "Mod+G".spawn = "signal-desktop";
    "Mod+Shift+Ctrl+L".spawn-sh = "veila lock";

    # middle row left
    "Mod+A".spawn-sh =
      "if pgrep -x wlsunset >/dev/null; then pkill wlsunset; else wlsunset -t 3500 -S 00:00 -s 00:00 & fi";
    "Mod+S" = _: {
      props.allow-when-locked = true;
      content.spawn-sh = "grim -g \"$(slurp)\" - | wl-copy";
    };
    "Mod+Ctrl+S".spawn-sh = "grim -g $(slurp)";
    "Mod+Shift+S" = _: {
      props.allow-when-locked = true;
      content.spawn-sh = "grim - | wl-copy";
    };
    "Mod+Ctrl+Shift+S".spawn-sh = "grim";
    "Mod+R".spawn-sh = "hyprpicker -aq";

    # bottom row left
    "Mod+C" = _: {
      props.repeat = false;
      content.close-window = _: { };
    };
    "Mod+V".toggle-window-floating = _: { };
    "Mod+Ctrl+V".switch-focus-between-floating-and-tiling = _: { };
    "Mod+Shift+V".fullscreen-window = _: { };
    "Mod+Alt+V" = _: {
      props.repeat = false;
      content.spawn-sh = "wl-mirror $(niri msg --json focused-output | jq -r .name)";
    };
    "Mod+B" = _: {
      props.repeat = false;
      content.toggle-overview = _: { };
    };

    # dangerous keybinds
    "Mod+Shift+Ctrl+I".quit = _: { skip-confirmation = true; };
    "Mod+Shift+Ctrl+Y".spawn-sh = "shutdown now";
    "Mod+Shift+Ctrl+Z".spawn-sh = "veila lock --wait-ready && systemctl suspend";

    # workspaces / windows / columns
    "Mod+1".focus-workspace = "1";
    "Mod+2".focus-workspace = "2";
    "Mod+3".focus-workspace = "3";
    "Mod+4".focus-workspace = "4";
    "Mod+5".focus-workspace = "5";

    "Mod+Shift+1".move-window-to-workspace = "1";
    "Mod+Shift+2".move-window-to-workspace = "2";
    "Mod+Shift+3".move-window-to-workspace = "3";
    "Mod+Shift+4".move-window-to-workspace = "4";
    "Mod+Shift+5".move-window-to-workspace = "5";

    "Mod+WheelScrollDown" = _: {
      props.cooldown-ms = 150;
      content.focus-workspace-down = _: { };
    };
    "Mod+WheelScrollUp" = _: {
      props.cooldown-ms = 150;
      content.focus-workspace-up = _: { };
    };
    "Mod+Shift+WheelScrollDown" = _: {
      props.cooldown-ms = 150;
      content.move-window-to-workspace-down = _: { };
    };
    "Mod+Shift+WheelScrollUp" = _: {
      props.cooldown-ms = 150;
      content.move-window-to-workspace-up = _: { };
    };

    "Mod+Comma".consume-window-into-column = _: { };
    "Mod+Period".expel-window-from-column = _: { };

    "Mod+M".switch-preset-column-width = _: { };
    "Mod+Shift+M".switch-preset-column-width-back = _: { };

    "Mod+K".switch-preset-window-height = _: { };
    "Mod+Shift+K".switch-preset-window-height-back = _: { };
    "Mod+Ctrl+K".reset-window-height = _: { };

    "Mod+U".focus-workspace-down = _: { };
    "Mod+Y".focus-workspace-up = _: { };
    "Mod+Shift+U".move-window-to-workspace-down = _: { };
    "Mod+Shift+Y".move-window-to-workspace-up = _: { };
    "Mod+Ctrl+U".move-workspace-down = _: { };
    "Mod+Ctrl+Y".move-workspace-up = _: { };

    # special keys
    XF86AudioRaiseVolume = _: {
      props.allow-when-locked = true;
      content.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.0";
    };
    XF86AudioLowerVolume = _: {
      props.allow-when-locked = true;
      content.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-";
    };
    "Shift+XF86AudioRaiseVolume" = _: {
      props.allow-when-locked = true;
      content.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.05+ -l 1.0";
    };
    "Shift+XF86AudioLowerVolume" = _: {
      props.allow-when-locked = true;
      content.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.05-";
    };
    XF86AudioMute = _: {
      props.allow-when-locked = true;
      content.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    };
    "Shift+XF86AudioMute" = _: {
      props.allow-when-locked = true;
      content.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
    };
    XF86AudioMicMute = _: {
      props.allow-when-locked = true;
      content.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
    };
    XF86AudioPlay = _: {
      props.allow-when-locked = true;
      content.spawn-sh = "playerctl play-pause";
    };
    XF86AudioStop = _: {
      props.allow-when-locked = true;
      content.spawn-sh = "playerctl stop";
    };
    XF86AudioPrev = _: {
      props.allow-when-locked = true;
      content.spawn-sh = "playerctl previous";
    };
    XF86AudioNext = _: {
      props.allow-when-locked = true;
      content.spawn-sh = "playerctl next";
    };
    XF86MonBrightnessUp = _: {
      props.allow-when-locked = true;
      content.spawn-sh = "brightnessctl --class=backlight set +10%";
    };
    XF86MonBrightnessDown = _: {
      props.allow-when-locked = true;
      content.spawn-sh = "brightnessctl --class=backlight set 10%-";
    };
    "Shift+XF86MonBrightnessUp" = _: {
      props.allow-when-locked = true;
      content.spawn-sh = "brightnessctl --class=backlight set +1%";
    };
    "Shift+XF86MonBrightnessDown" = _: {
      props.allow-when-locked = true;
      content.spawn-sh = "brightnessctl --class=backlight set 1%-";
    };
  };
in
base
// (
  if keyboard == "colemak" then
    colemak
  else if keyboard == "qwerty" then
    qwerty
  else
    builtins.trace "warning (niri): unknown keyboard layout ${keyboard}" { }
)
