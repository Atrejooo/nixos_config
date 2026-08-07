{
  pkgs,
  theme,
}:
{
  layer = "top";
  position = "top";
  height = 30;
  "modules-left" = [
    "user"
    "battery"
    "custom/system-info"
  ];
  "modules-center" = [
    "niri/workspaces"
  ];
  "modules-right" = [
    "backlight"
    "pulseaudio"
    "network"
    "clock"
  ];
  user = {
    format = " {user}";
    tooltip = false;
  };
  battery = {
    interval = 3;
    states = {
      critical = 10;
    };
    format = "{capacity} {icon}";
    "format-warning" = "{capacity} {icon}";
    "format-critical" = "{capacity} {icon}";
    "format-full" = "󰇵{icon}";
    "format-charging" = "{capacity} {icon}";
    "format-plugged" = "{capacity} {icon}";
    "format-icons" = [
      " "
      " "
      " "
      " "
      " "
    ];
  };
  "custom/system-info" = {
    format = "";
    tooltip = true;
    "tooltip-format" = "{text}";
    exec = pkgs.writeShellScript "waybar-system-info" (builtins.readFile ./system-info.sh);
    "return-type" = "json";
    interval = 3;
  };
  "niri/workspaces" = {
    format = "";
  };
  backlight = {
    format = "{icon}";
    "tooltip-format" = " {percent}";
    "format-icons" = [
      ""
      ""
      ""
      ""
      ""
      ""
      ""
      ""
      ""
    ];
  };
  pulseaudio = {
    format = "{icon}";
    "format-bluetooth" = "󱃓 ";
    "format-bluetooth-muted" = "󱃓  ";
    "format-muted" = "X ";
    "format-source" = " {volume}";
    "format-source-muted" = "";
    tooltip = true;
    "tooltip-format" = " {volume}\n{format_source}";
    "format-icons" = [
      "⠀⠀"
      "⠄⠀"
      "⠆⠀"
      "⠇⠀"
      "⡇⠀"
      "⡧⠀"
      "⡷⠀"
      "⡿⠀"
      "⣿⠀"
      "⣿⠄"
      "⣿⠆"
      "⣿⠇"
      "⣿⡇"
      "⣿⡧"
      "⣿⡷"
      "⣿⡿"
      "⣿⣿"
    ];
    "on-click" = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
    "on-scroll-up" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+";
    "on-scroll-down" = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-";
  };
  network = {
    "format-wifi" = "{icon}";
    "format-ethernet" = "󰈀";
    "tooltip-format-wifi" = "{essid}\n{icon} {signalStrength}%\nip: {ipaddr}/{cidr}";
    "tooltip-format-ethernet" = "Ethernet: {ifname} via {gwaddr}\nIP: {ipaddr}/{cidr}";
    "tooltip-format-disconnected" = "disconnected";
    "format-linked" = "{ifname} (No IP)";
    "format-disconnected" = "󰤭";
    "format-icons" = [
      "󰤯"
      "󰤟"
      "󰤢"
      "󰤥"
      "󰤨"
    ];
  };
  clock = {
    format = "{:%H:%M}";
    "tooltip-format" = "<small><span font_desc='Mango 16'>{calendar}</span></small>";
    calendar = {
      mode = "year";
      "mode-mon-col" = 3;
      "weeks-pos" = "right";
      "on-scroll" = 1;
      format = {
        months = "<span color='#${theme.lightMain}'>{}</span>";
        days = "<span color='#${theme.lightMain}'>{}</span>";
        weeks = "<span color='#${theme.lightMain}'>W{}</span>";
        weekdays = "<span color='#${theme.lightMain}'>{}</span>";
        today = "<span color='#${theme.lightMain}'>{}</span>";
      };
    };
    actions = {
      "on-click-right" = "mode";
      "on-scroll-up" = "shift_up";
      "on-scroll-down" = "shift_down";
    };
  };
}
