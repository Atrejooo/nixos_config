{ browser-cmd, theme }: /* kdl */ ''
  binds {
      "Mod+Q" { spawn "alacritty"; }
      "Mod+W" { spawn "${browser-cmd}"; }

      "Mod+R" { spawn-sh "alacritty -e sh -c \"r && sleep 0.1\""; }

      "Mod+C" repeat=false { close-window; }
      "Mod+X" repeat=false { spawn-sh "pkill waybar || waybar"; }

      "Mod+G" { switch-preset-column-width; }
      "Mod+Shift+G" { switch-preset-column-width-back; }

      "Mod+O" repeat=false { toggle-overview; }

      // toggle focus to the other monitor
      "Mod+Tab" { focus-monitor-previous; }

      // move focused window to the other monitor
      "Mod+Shift+Tab" { move-window-to-monitor-previous; }

      "Mod+F" { maximize-window-to-edges; }
      "Mod+Shift+F" { fullscreen-window; }
      "Mod+Ctrl+F" { toggle-window-floating; }

      "Mod+S" { screenshot; }
      "Mod+Shift+S" { screenshot-screen write-to-disk=false; }
      "Mod+Ctrl+S" { screenshot-screen; }

      "Mod+A" repeat=false { spawn-sh "niri-toggle-chamel '#${theme.textEmph1}'"; }
      "Mod+Shift+A" repeat=false { spawn-sh "hyprpicker -aq"; }
      
      // mirror screen
      "Mod+Alt+M" repeat=false { spawn-sh "wl-mirror $(niri msg --json focused-output | jq -r .name)"; }

      // toggle output scale
      "Mod+P" repeat=false { spawn "niri-toggle-output-scale"; }

      "Mod+E" { spawn-sh "alacritty -e yazi"; }
      "Mod+Shift+E" { spawn-sh "kitty -e yazi"; }
      "Mod+T" { spawn "signal-desktop"; }

      "Mod+B" { spawn-sh "pkill wlsunset || wlsunset -t 2500 -T 3000 -g 0.7"; }

      "Mod+Shift+M" { quit skip-confirmation=true; }
      "Mod+Shift+Ctrl+M" { spawn-sh "shutdown now"; }
      "Mod+N" { spawn-sh "veila lock"; }
      "Mod+Shift+N" { spawn-sh "veila lock --wait-ready && systemctl suspend"; }

      "Mod+1" { focus-workspace "1"; }
      "Mod+2" { focus-workspace "2"; }
      "Mod+3" { focus-workspace "3"; }
      "Mod+4" { focus-workspace "4"; }
      "Mod+5" { focus-workspace "5"; }
      "Mod+6" { focus-workspace "6"; }
      "Mod+7" { focus-workspace "7"; }
      "Mod+8" { focus-workspace "8"; }
      "Mod+9" { focus-workspace "9"; }
      "Mod+Shift+1" { move-window-to-workspace "1"; }
      "Mod+Shift+2" { move-window-to-workspace "2"; }
      "Mod+Shift+3" { move-window-to-workspace "3"; }
      "Mod+Shift+4" { move-window-to-workspace "4"; }
      "Mod+Shift+5" { move-window-to-workspace "5"; }
      "Mod+Shift+6" { move-window-to-workspace "6"; }
      "Mod+Shift+7" { move-window-to-workspace "7"; }
      "Mod+Shift+8" { move-window-to-workspace "8"; }
      "Mod+Shift+9" { move-window-to-workspace "9"; }

      "Mod+WheelScrollDown" cooldown-ms=150 { focus-workspace-down; }
      "Mod+WheelScrollUp" cooldown-ms=150 { focus-workspace-up; }
      "Mod+Shift+WheelScrollDown" cooldown-ms=150 { move-window-to-workspace-down; }
      "Mod+Shift+WheelScrollUp" cooldown-ms=150 { move-window-to-workspace-up; }

      "Mod+Comma" { consume-window-into-column; }
      "Mod+Period" { expel-window-from-column; }

      "Mod+H" { focus-column-left; }
      "Mod+J" { focus-window-down; }
      "Mod+K" { focus-window-up; }
      "Mod+L" { focus-column-right; }
      "Mod+Ctrl+H" { move-column-left; }
      "Mod+Ctrl+J" { move-window-down; }
      "Mod+Ctrl+K" { move-window-up; }
      "Mod+Ctrl+L" { move-column-right; }
      "Mod+Shift+H" { set-column-width "-10%"; }
      "Mod+Shift+J" { set-window-height "+10%"; }
      "Mod+Shift+K" { set-window-height "-10%"; }
      "Mod+Shift+L" { set-column-width "+10%"; }

      "Mod+U" { focus-workspace-down; }
      "Mod+D" { focus-workspace-up; }
      "Mod+Shift+U" { move-window-to-workspace-down; }
      "Mod+Shift+D" { move-window-to-workspace-up; }
      "Mod+Ctrl+U" { move-workspace-down; }
      "Mod+Ctrl+D" { move-workspace-up; }

      "Mod+Escape" allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }

      
      // laptop buttons
      XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.0"; }
      XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"; }
      Shift+XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.05+ -l 1.0"; }
      Shift+XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.05-"; }
      XF86AudioMute allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
      Shift+XF86AudioMute allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
      XF86AudioMicMute allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }
      XF86AudioPlay allow-when-locked=true { spawn-sh "playerctl play-pause"; }
      XF86AudioStop allow-when-locked=true { spawn-sh "playerctl stop"; }
      XF86AudioPrev allow-when-locked=true { spawn-sh "playerctl previous"; }
      XF86AudioNext allow-when-locked=true { spawn-sh "playerctl next"; }
      XF86MonBrightnessUp allow-when-locked=true { spawn-sh "brightnessctl --class=backlight set +10%"; }
      XF86MonBrightnessDown allow-when-locked=true { spawn-sh "brightnessctl --class=backlight set 10%-"; }
      Shift+XF86MonBrightnessUp allow-when-locked=true { spawn-sh "brightnessctl --class=backlight set +1%"; }
      Shift+XF86MonBrightnessDown allow-when-locked=true { spawn-sh "brightnessctl --class=backlight set 1%-"; }
  }
''
