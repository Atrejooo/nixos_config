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
    # "bluetooth"
    "privacy"
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
  bluetooth = {
    format = "󰂲";
    format-disabled = "󰂲";
    format-off = "󰂲";
    format-on = "";
    format-connected = "󰂱";
    format-connected-battery = "󰂱 ({device_battery_percentage}% )";
    tooltip-format = "Daemon is not running";
    tooltip-format-disabled = "Bluetooth is disabled\n{controller_alias}= {controller_address} {controller_address_type}";
    tooltip-format-off = "Bluetooth is turned off";
    tooltip-format-on = "Bluetooth is turned on\n{controller_alias}= {controller_address} {controller_address_type}";
    tooltip-format-connected = "Bluetooth is turned on\n{controller_alias}= {controller_address} {controller_address_type}\n{device_enumerate}";
    tooltip-format-enumerate-connected = "{device_alias} {device_address} {device_address_type}";
    on-click = "bluetoothctl power off";
    on-click-right = "bluetoothctl power on";
  };
  privacy = {
    modules = [
      {
        type = "screenshare";
      }
      {
        type = "audio-in";
      }
    ];
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
    "format-bluetooth" = " ";
    "format-bluetooth-muted" = "X";
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
        days = "<span color='#${theme.textMain}'>{}</span>";
        weeks = "<span color='#${theme.lightMain}'>W{}</span>";
        weekdays = "<span color='#${theme.textEmph0}'>{}</span>";
        today = "<span color='#${theme.textEmph1}'>{}</span>";
      };
    };
    actions = {
      "on-click-right" = "mode";
      "on-scroll-up" = "shift_up";
      "on-scroll-down" = "shift_down";
    };
  };
}
