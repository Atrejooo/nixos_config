theme:
let
  emphColors = {
    emphasis_0 = "#${theme.textEmph0}";
    emphasis_1 = "#${theme.textEmph1}";
    emphasis_2 = "#${theme.textEmph2}";
    emphasis_3 = "#${theme.textEmph2}";
  };
in
{
  text_unselected = {
    base = "#${theme.textMain}";
    background = "#${theme.darkBase}";
  }
  // emphColors;
  text_selected = {
    base = "#${theme.textMain}";
    background = "#${theme.textSelect}";
  }
  // emphColors;
  ribbon_selected = {
    base = "#${theme.textEmph0}";
    background = "#${theme.lightBase}";
  }
  // emphColors;
  ribbon_unselected = {
    base = "#${theme.textMain}";
    background = "#${theme.darkMain}";
  }
  // emphColors;
  table_title = {
    base = "#${theme.textMain}";
    background = "#${theme.darkMain}";
  }
  // emphColors;
  table_cell_selected = {
    base = "#${theme.textMain}";
    background = "#${theme.darkMain}";
  }
  // emphColors;
  table_cell_unselected = {
    base = "#${theme.textMain}";
    background = "#${theme.lightBase}";
  }
  // emphColors;
  list_selected = {
    base = "#${theme.textMain}";
    background = "#${theme.textSelect}";
  }
  // emphColors;
  list_unselected = {
    base = "#${theme.textMain}";
    background = "#${theme.darkMain}";
  }
  // emphColors;
  frame_selected = {
    base = "#${theme.darkMain}";
    background = 0;
    emphasis_0 = "#${theme.textEmph0}";
    emphasis_1 = "#${theme.textEmph1}";
    emphasis_2 = "#${theme.textEmph2}";
    emphasis_3 = 0;
  };
  frame_highlight = {
    base = "#${theme.textYellow}";
    background = 0;
    emphasis_0 = "#${theme.textEmph0}";
    emphasis_1 = "#${theme.textYellow}";
    emphasis_2 = "#${theme.textYellow}";
    emphasis_3 = "#${theme.textYellow}";
  };
  exit_code_success = {
    base = "#${theme.textGreen}";
    background = 0;
  }
  // emphColors;
  exit_code_error = {
    base = "#${theme.textRed}";
    background = 0;
    emphasis_0 = "#${theme.textOrange}";
    emphasis_1 = 0;
    emphasis_2 = 0;
    emphasis_3 = 0;
  };
  multiplayer_user_colors = {
    player_1 = "#${theme.textEmph0}";
    player_2 = "#${theme.textEmph1}";
    player_3 = "#${theme.textEmph2}";
    player_4 = "#${theme.textRed}";
    player_5 = "#${theme.textOrange}";
    player_6 = "#${theme.textYellow}";
    player_7 = "#${theme.textGreen}";
    player_8 = "#${theme.textCyan}";
    player_9 = "#${theme.textBlue}";
    player_10 = "#${theme.textMagenta}";
  };
}
