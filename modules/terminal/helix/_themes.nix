theme: {
  dynamic-theme = {
    palette = {
      fg = "#${theme.textMain}";
      bg = "#${theme.darkMain}";
      bg_light = "#${theme.lightBase}";

      sel = "#${theme.textSelect}";
      emph_0 = "#${theme.textEmph0}";
      emph_1 = "#${theme.textEmph1}";
      emph_2 = "#${theme.textEmph2}";
      pale = "#${theme.textPale}";
      dark = "#${theme.textDark}";

      white = "#${theme.textWhite}";
      red = "#${theme.textRed}";
      orange = "#${theme.textOrange}";
      yellow = "#${theme.textYellow}";
      green = "#${theme.textGreen}";
      cyan = "#${theme.textCyan}";
      blue = "#${theme.textBlue}";

      type = "#${theme.lspType}";
      string = "#${theme.lspString}";
      primitive = "#${theme.lspPrimitive}";
      macro = "#${theme.lspMacro}";
      keyword = "#${theme.lspKeyword}";
      builtin = "#${theme.lspBuiltin}";
      func = "#${theme.lspFunction}";
      property = "#${theme.lspProperty}";
      exception = "#${theme.lspException}";
      variable = "#${theme.lspVariable}";
    };

    "attribute" = "macro";
    "type" = "type";
    "type.builtin" = "builtin";
    "constructor" = "type";
    "constant" = "type";
    "constant.builtin" = "emph_0";
    "constant.character" = "string";
    "constant.character.escape" = "fg";
    "constant.numeric" = "primitive";
    "string" = "string";
    "comment" = {
      fg = "pale";
    };
    "variable" = "variable";
    "variable.other.member" = "property";
    "variable.builtin" = "builtin";
    "label" = "macro";
    "punctuation" = "fg";
    "punctuation.special" = "highlight";
    "keyword" = "keyword";
    "operator" = "func";
    "function" = "func";
    "function.builtin" = "builtin";
    "function.macro" = "macro";
    "tag" = "type";
    "namespace" = "fg";
    "special" = "macro";

    diff.plus = "green";
    diff.minus = "orange";
    diff.delta = "blue";

    "markup" = {
      bg = "bg";
    };

    "ui.background" = { };

    "ui.cursor" = {
      fg = "dark";
      bg = "emph_0";
    };
    "ui.cursor.primary" = {
      fg = "dark";
      bg = "white";
    };
    "ui.cursor.match" = {
      fg = "emph_1";
    };

    "ui.linenr" = {
      fg = "pale";
    };

    "ui.statusline" = {
      fg = "fg";
      bg = "bg_light";
    };
    "ui.statusline.inactive" = {
      fg = "pale";
      bg = "bg";
    };
    "ui.statusline.normal" = {
      fg = "emph_0";
      modifiers = [ "bold" ];
    };
    "ui.statusline.insert" = {
      fg = "emph_1";
      modifiers = [ "bold" ];
    };
    "ui.statusline.select" = {
      fg = "emph_2";
      modifiers = [ "bold" ];
    };

    "ui.bufferline" = {
      fg = "pale";
      bg = "bg";
    };
    "ui.bufferline.active" = {
      fg = "emph_0";
      bg = "bg_light";
    };
    "ui.bufferline.background" = {
      fg = "pale";
      bg = "bg";
    };

    "ui.popup" = {
      bg = "bg";
    };
    "ui.popup.info" = {
      fg = "fg";
      bg = "";
    };

    "ui.window" = {
      fg = "fb";
    };
    "ui.help" = {
      fg = "fg";
      bg = "";
    };

    "ui.text" = "fg";
    "ui.text.focus" = {
      fg = "emph_0";
    };
    "ui.text.inactive" = {
      fg = "pale";
    };
    "ui.text.directory" = {
      fg = "type";
    };

    "ui.virtual" = {
      fg = "pale";
    };
    "ui.virtual.jump-label" = {
      fg = "emph_2";
    };

    "ui.menu" = {
      bg = "bg";
    };
    "ui.menu.selected" = {
      fg = "fg";
      bg = "sel";
    };
    "ui.menu.scroll" = {
      fg = "fg";
    };

    "ui.selection" = {
      bg = "sel";
    };

    "ui.highlight" = {
      bg = "bg_light";
    };
    "ui.highlight.frameline" = {
      bg = "bg_light";
    };

    "error" = "red";
    "warning" = "yellow";
    "info" = "blue";
    "hint" = "cyan";

    "diagnostic.error" = {
      underline = {
        color = "red";
        style = "curl";
      };
    };
    "diagnostic.warning" = {
      underline = {
        color = "yellow";
        style = "curl";
      };
    };
    "diagnostic.info" = {
      underline = {
        color = "blue";
        style = "curl";
      };
    };
    "diagnostic.hint" = {
      underline = {
        color = "cyan";
        style = "curl";
      };
    };
    "diagnostic.unnecessary" = {
      modifiers = [ "dim" ];
    };

    rainbow = [
      "red"
      "peach"
      "yellow"
      "green"
      "sapphire"
      "lavender"
    ];
  };
}
