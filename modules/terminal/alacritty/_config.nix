theme: {
  terminal.shell = "fish";
  mouse.hide_when_typing = true;

  window = {
    opacity = 0.7;
    padding = {
      x = 4;
      y = 4;
    };
  };

  font = {
    normal = {
      family = "Mango";
      style = "Regular";
    };
    bold = {
      style = "Regular";
    };
    italic = {
      style = "Regular";
    };
    bold_italic = {
      style = "Regular";
    };
    offset = {
      x = 0;
      y = 0;
    };
    size = 15;
    builtin_box_drawing = false;
  };

  colors = {
    cursor = {
      text = "CellBackground";
      cursor = "#${theme.textWhite}";
    };
    vi_mode_cursor = {
      text = "CellBackground";
      cursor = "#${theme.textWhite}";
    };
    selection = {
      text = "CellForeground";
      background = "#${theme.textSelect}";
    };
    footer_bar = {
      foreground = "#${theme.textEmph0}";
      background = "#${theme.lightBase}";
    };

    primary = {
      foreground = "#${theme.textMain}";
      background = "#${theme.darkBase}";
      dim_foreground = "#${theme.lightMain}";
      bright_foreground = "#${theme.lightHighlight}";
    };

    hints = {
      start = {
        foreground = "#${theme.textDark}";
        background = "#${theme.textYellow}";
      };
      end = {
        foreground = "#${theme.textDark}";
        background = "#${theme.textOrange}";
      };
    };

    search = {
      matches = {
        foreground = "CellBackground";
        background = "#${theme.textEmph0}";
      };
      focused_match = {
        foreground = "CellBackground";
        background = "#${theme.textYellow}";
      };
    };

    normal = {
      black = "#${theme.textDark}";
      red = "#${theme.textRed}";
      green = "#${theme.textGreen}";
      yellow = "#${theme.textYellow}";
      blue = "#${theme.textBlue}";
      magenta = "#${theme.textMagenta}";
      cyan = "#${theme.textCyan}";
      white = "#${theme.textWhite}";
    };

    bright = {
      black = "#${theme.textPale}";
      red = "#${theme.textRed}";
      green = "#${theme.textGreen}";
      yellow = "#${theme.textYellow}";
      blue = "#${theme.textBlue}";
      magenta = "#${theme.textMagenta}";
      cyan = "#${theme.textCyan}";
      white = "#${theme.textWhite}";
    };
  };

}
