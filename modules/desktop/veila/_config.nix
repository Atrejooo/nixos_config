theme: {
  background = {
    mode = "file";
    path = ../wallpapers/amora-b-celeste-8.jpg;
  };
  weather.enabled = false;
  visuals = {
    now_playing.enabled = false;
    username.enabled = false;
    avatar.enabled = false;
    weather.enabled = false;
    clock = {
      font_family = "Geom";
      format = "24h";
      meridiem_font_size = 22;
      meridiem_x = 6;
      meridiem_y = 7;
      font_weight = 600;
      color = "#${theme.textMain}cc";
      font_size = 88;
      halign = "center";
      valign = "top";
      x = 0;
      y = 40;
    };
    date = {
      font_family = "Geom";
      format = "long";
      font_weight = 600;
      font_size = 18;
      color = "#${theme.textMain}cc";
      halign = "center";
      valign = "top";
      x = 0;
      y = 140;
    };
    input = {
      placeholder = "Password pls...";
      background_color = "#${theme.darkMain}20";
      width = 340;
      height = 62;
      radius = 20;
      border_width = 4;
      border_color = "#${theme.lightMain}90";
      mask_color = "#ffffff";
      font_family = "Mango";
      font_weight = 400;
      font_size = 24;
      halign = "center";
      valign = "bottom";
      x = 0;
      y = -64;
    };

    status = {
      mode = "inline";
      rejected_color = "#${theme.textRed}";
      pending_color = "#${theme.textBlue}";
    };

    eye = {
      color = "#${theme.lightMain}dd";
    };

    caps_lock = {
      color = "#${theme.lightMain}dd";
    };

    placeholder = {
      color = "#${theme.textMain}cc";
    };

    keyboard = {
      background_size = 46;
      radius = 23;
      background_color = "#${theme.darkBase}70";
      color = "#${theme.textMagenta}dd";
      size = 16;
      halign = "right";
      valign = "top";
      x = -24;
      y = 21;
    };

    battery = {
      enabled = true;
      background_color = "#${theme.darkBase}70";
      background_size = 46;
      radius = 23;
      color = "#${theme.textMagenta}dd";
      size = 20;
      halign = "right";
      valign = "top";
      x = -78;
      y = 21;
    };
  };
}
