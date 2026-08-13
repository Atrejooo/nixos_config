{ theme }:
/* css */ ''
  @define-color dark_base #${theme.darkBase};
  @define-color dark_main #${theme.darkMain};
  @define-color light_base #${theme.lightBase};
  @define-color light_main #${theme.lightMain};
  @define-color light_highlight #${theme.lightHighlight};
  @define-color text_main #${theme.textMain};
  @define-color text_emph_a #${theme.textEmph0};
  @define-color text_emph_b #${theme.textEmph1};
  @define-color text_emph_c #${theme.textEmph2};
  @define-color text_pale #${theme.textPale};
  @define-color text_select #${theme.textSelect};
  @define-color text_dark #${theme.textDark};
  @define-color text_white #${theme.textWhite};
  @define-color text_red #${theme.textRed};
  @define-color text_orange #${theme.textOrange};
  @define-color text_yellow #${theme.textYellow};
  @define-color text_green #${theme.textGreen};
  @define-color text_cyan #${theme.textCyan};
  @define-color text_blue #${theme.textBlue};
  @define-color text_magenta #${theme.textMagenta};

  /* -- bar and container -- */
  * {
      border: none;
      border-radius: 0;
      min-height: 0;
      margin: 0;
      padding: 0;
  }

  window#waybar {
      background: transparent;
      animation: waybar-fade-in 0.5s ease;
      font-family: "Mango", "Symbols Nerd Font Mono";
      /* border-radius: 0px 0px 12px 12px; */
      background-image: linear-gradient(
          to bottom,
          alpha(@dark_base, 0.6) 10%,
          alpha(@dark_base, 0.4) 50%,
          alpha(@dark_base, 0.3) 70%,
          alpha(@dark_main, 0.2) 85%,
          alpha(@light_main, 0.1) 95%,
          alpha(@light_main, 0.3) 100%
      );
  }

  /* simple little fade in */
  /* not as cool what hyprland has but for now it shall suffice */
  @keyframes waybar-fade-in {
      from {
          opacity: 0;
      }
      to {
          opacity: 1;
      }
  }

  /* -- user module (nixos logo + username) -- */
  #custom-nixos-logo,
  #user {
      color: @text_emph_a;
      font-size: 20px;
      padding: 0 10px 0 14px;
  }

  /* -- ascii wigits -- */
  #backlight,
  #battery,
  #bluetooth,
  #clock,
  #custom-system-info,
  #network,
  #privacy,
  #pulseaudio {
      color: @text_main;
      font-size: 20px;
      padding: 0 6px;
      transition: all 0.4s ease;
  }

  #backlight:hover,
  #battery:hover,
  #bluetooth:hover,
  #clock:hover,
  #custom-nixos-logo:hover,
  #custom-system-info:hover,
  #network:hover,  
  #privacy:hover,
  #pulseaudio:hover {
      color: @text_emph_a;
      text-shadow: 0 0 6px @text_emph_a;
  }

  /* -- battery critical blink (steps() limits cpu usage) -- */
  @keyframes blink {
      to {
          color: @text_main;
          text-shadow: 0 0 6px alpha(@light_highlight, 0.8);
      }
  }

  #battery.critical:not(.charging) {
      color: @text_red;
      text-shadow: 3px 3px 3px alpha(@text_red, 0.3);
      animation-name: blink;
      animation-duration: 0.5s;
      animation-timing-function: steps(12);
      animation-iteration-count: infinite;
      animation-direction: alternate;
  }

  /* -- tooltip / popup styling -- */
  tooltip,
  tooltip.background {
      background: alpha(@dark_base, 0.5);
      border: 3px solid @light_base;
      border-radius: 12px;
      padding: 8px;
      color: @text_main;
      font-family: "Mango", "Symbols Nerd Font Mono";
  }

  /* fix for an issue with gtk reserving space for a box shadow which made it draw a gray box */
  tooltip decoration {
      background-color: transparent;
      border: none;
      border-radius: 12px;
      box-shadow: none;
      margin: 0;
      padding: 0;
  }

  tooltip label {
      font-family: "Mango", "Symbols Nerd Font Mono";
      font-size: 17px;
      padding: 4px;
      color: @text_main;
  }

  /* -- workspace buttons -- */
  #workspaces {
      /* adds space for the underglow to not get cut off at the edges of the outer workspace buttons */
      padding: 0 32px;
  }

  /* base */
  #workspaces button {
      background: transparent;
      background-image: none;
      border: none;
      box-shadow: none;
      padding: 0;
      transition: all 0.4s ease;
  }

  #workspaces button:hover {
      background: transparent;
      background-image: none;
      border: none;
      box-shadow: none;
  }

  #workspaces button label {
      background: transparent;
      background-image: linear-gradient(
          to bottom,
          alpha(@dark_base, 0.5) 10%,
          alpha(@dark_base, 0.3) 50%,
          alpha(@light_base, 0.2) 80%,
          alpha(@light_main, 0.1) 90%,
          alpha(@light_main, 0.4) 100%
      );
      border-radius: 10px;
      min-width: 30px;
      /* min-height: 16px; */
      margin: 4px 3px;
      font-size: 0;
      transition: all 0.4s ease;
  }

  #workspaces button.focused label {
      background: alpha(@light_highlight, 0.7);
      min-width: 50px;
      border-radius: 12px;
      box-shadow: 0 4px 12px 2px alpha(@light_highlight, 0.75);
  }

  #workspaces button:hover label {
      background: alpha(@light_main, 0.9);
      background-image: none;
      min-width: 44px;
      border-radius: 12px;
      box-shadow: 0 4px 12px 2px alpha(@light_highlight, 0.5);
      transition:
          min-width 0.5s cubic-bezier(0.34, 1.56, 0.64, 1),
          border-radius 0.5s cubic-bezier(0.34, 1.56, 0.64, 1),
          background-color 0.4s ease,
          box-shadow 0.3s ease 0s;
  }

  #workspaces button.focused:hover label {
      background: alpha(@light_highlight, 0.7);
      background-image: none;
      min-width: 58px;
      border-radius: 14px;
      box-shadow: 0 4px 16px 4px alpha(@light_highlight, 0.95);
      transition:
          min-width 0.1s cubic-bezier(0.34, 1.56, 0.64, 1),
          border-radius 0.1s cubic-bezier(0.34, 1.56, 0.64, 1),
          box-shadow 0.4s ease;
  }

  #workspaces button.urgent label {
      background-color: @text_emph_b;
      background-image: none;
      color: @text_dark;
      animation: urgent-pulse 1s linear infinite;
  }

  /* rotating box shadow */
  @keyframes urgent-pulse {
      0% {
          box-shadow: 3px 0 10px 2px alpha(@text_emph_b, 0.95);
      }
      12.5% {
          box-shadow: 2.1px 2.1px 10px 2px alpha(@text_emph_b, 0.95);
      }
      25% {
          box-shadow: 0 3px 10px 2px alpha(@text_emph_b, 0.95);
      }
      37.5% {
          box-shadow: -2.1px 2.1px 10px 2px alpha(@text_emph_b, 0.95);
      }
      50% {
          box-shadow: -3px 0 10px 2px alpha(@text_emph_b, 0.95);
      }
      62.5% {
          box-shadow: -2.1px -2.1px 10px 2px alpha(@text_emph_b, 0.95);
      }
      75% {
          box-shadow: 0 -3px 10px 2px alpha(@text_emph_b, 0.95);
      }
      87.5% {
          box-shadow: 2.1px -2.1px 10px 2px alpha(@text_emph_b, 0.95);
      }
      100% {
          box-shadow: 3px 0 10px 2px alpha(@text_emph_b, 0.95);
      }
  }
''
