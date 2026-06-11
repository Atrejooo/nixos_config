{ lib, keyboard }:
{
  theme = "dynamic-theme";

  editor.file-picker = {
    hidden = false;
  };

  editor = {
    line-number = "relative";
    bufferline = "multiple";
    mouse = false;
  };

  editor.cursor-shape = {
    insert = "bar";
    normal = "block";
    select = "underline";
  };

  editor.statusline = {
    left = [
      "mode"
      "spinner"
    ];
    center = [ "file-name" ];
    right = [
      "diagnostics"
      "register"
      "selections"
      "position"
      "file-encoding"
      "file-line-ending"
      "file-type"
    ];
    separator = "│";
  };

  keys =
    let
      base = {
        normal = {
          X = "extend_line_above";
          V = "extend_to_line_bounds";
          space.w = ":w";
          "#" = "shell_keep_pipe";
        };
        select = {
          X = "extend_line_above";
          V = "extend_to_line_bounds";
        };
      };

      qwerty = {
        normal = {
          H = ":buffer-previous";
          L = ":buffer-next";
        };
      };

      colemak = {
        normal = {
          N = ":buffer-previous";
          E = "join_selections";
          I = "no_op";
          O = ":buffer-next";
          n = "move_char_left";
          e = "move_visual_line_down";
          i = "move_visual_line_up";
          o = "move_char_right";

          j = "move_next_word_end";
          J = "move_next_long_word_end";
          h = "insert_mode";
          H = "insert_at_line_start";
          l = "open_below";
          L = "open_above";
          k = "search_next";
          K = "search_prev";

          g = {
            n = "goto_line_start";
            e = "move_line_up";
            i = "move_line_down";
            o = "goto_line_end";
            h = "no_op";
            j = "no_op";
            k = "no_op";
            l = "goto_last_line";
            p = "goto_implementation";
          };
        };

        select = {
          n = "extend_char_left";
          e = "extend_line_down";
          i = "extend_line_up";
          o = "extend_char_right";
          N = "no_op";
          E = "join_selections";
          I = "no_op";
          O = "no_op";

          j = "extend_next_word_end";
          J = "extend_next_long_word_end";
          h = "insert_mode";
          H = "append_mode";
          l = "open_below";
          L = "open_above";
          k = "extend_search_next";
          K = "extend_search_prev";

          g = {
            n = "extend_to_line_start";
            e = "extend_visual_line_up";
            i = "extend_visual_line_down";
            o = "extend_to_line_end";

            h = "no_op";
            j = "no_op";
            k = "no_op";
            l = "extend_to_last_line";
          };
        };
      };
    in
    lib.recursiveUpdate base (
      if keyboard == "colemak" then
        colemak
      else if keyboard == "qwerty" then
        qwerty
      else
        builtins.trace "warning (helix): unknown keyboard layout ${keyboard}" { }
    );
}
