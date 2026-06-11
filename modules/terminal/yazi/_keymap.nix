keyboard:
let
  merge =
    a: b:
    a
    // b
    // (builtins.mapAttrs (
      bName: bValue:
      let
        aValue = a.${bName} or null;
      in
      if builtins.isAttrs aValue && builtins.isAttrs bValue then
        merge aValue bValue
      else if builtins.isList aValue && builtins.isList bValue then
        aValue ++ bValue
      else
        bValue
    ) b);
  base = {
    mgr = {
      prepend_keymap = [
        {
          on = "Y";
          run = ''shell  "dragon-drop -x -A \"$@\"" --confirm'';
          desc = "dragon drop it!";
        }
        {
          on = "T";
          run = ''shell "alacritty --working-directory \"%d\"" --confirm'';
          desc = "New Terminal in current directory.";
        }
        {
          on = "A";
          run = ''shell "archiver  \"$@\" # enter format (7z, tar.gz, zip)" --cursor=9 --interactive'';
          desc = "Archive selected file(s) with format prompt";
        }
      ];
    };
  };
  qwerty = {
    mgr = {
      prepend_keymap = [
        {
          on = "K";
          run = "arrow -4";
          desc = "Move cursor a tiny bit!";
        }
        {
          on = "J";
          run = "arrow 4";
          desc = "Move cursor a tiny bit!";
        }
      ];
    };
  };
  colemak = {
    mgr = {
      prepend_keymap = [
        {
          on = "i";
          run = "arrow prev";
          desc = "Previous file";
        }
        {
          on = "e";
          run = "arrow next";
          desc = "Next file";
        }
        {
          on = "n";
          run = "leave";
          desc = "Back to the parent directory";
        }
        {
          on = "o";
          run = "enter";
          desc = "Enter the child directory";
        }
        {
          on = "I";
          run = "arrow -4";
          desc = "Move cursor a tiny bit!";
        }
        {
          on = "E";
          run = "arrow 4";
          desc = "Move cursor a tiny bit!";
        }
        {
          on = "N";
          run = "back";
          desc = "Back to previous directory";
        }
        {
          on = "O";
          run = "forward";
          desc = "Forward to next directory";
        }
        {
          on = "l";
          run = "open";
          desc = "Open selected files";
        }
        {
          on = "L";
          run = "open --interactive";
          desc = "Open selected files interactively";
        }
        {
          on = "k";
          run = "find_arrow";
          desc = "Next found";
        }
        {
          on = "K";
          run = "find_arrow --previous";
          desc = "Previous found";
        }
      ];
    };
    tasks = {
      prepend_keymap = [
        {
          on = "i";
          run = "arrow prev";
          desc = "Previous task";
        }
        {
          on = "e";
          run = "arrow next";
          desc = "Next task";
        }
      ];
    };
    spot = {
      prepend_keymap = [
        {
          on = "i";
          run = "arrow prev";
          desc = "Previous line";
        }
        {
          on = "e";
          run = "arrow next";
          desc = "Next line";
        }
        {
          on = "n";
          run = "swipe prev";
          desc = "Swipe to previous file";
        }
        {
          on = "o";
          run = "swipe next";
          desc = "Swipe to next file";
        }
      ];
    };
    pick = {
      prepend_keymap = [
        {
          on = "i";
          run = "arrow prev";
          desc = "Previous option";
        }
        {
          on = "e";
          run = "arrow next";
          desc = "Next option";
        }
      ];
    };
    input = {
      prepend_keymap = [
        {
          on = "n";
          run = "move -1";
          desc = "Move back a character";
        }
        {
          on = "o";
          run = "move 1";
          desc = "Move forward a character";
        }
        {
          on = "h";
          run = "insert";
          desc = "Enter insert mode";
        }
        {
          on = "H";
          run = [
            "move first-char"
            "insert"
          ];
          desc = "Move to the BOL, and enter insert mode";
        }
        {
          on = "k";
          run = "forward --end-of-word";
          desc = "Move forward to the end of the current or next word";
        }
        {
          on = "K";
          run = "forward --far --end-of-word";
          desc = "Move forward to the end of the current or next WORD";
        }
        {
          on = "<C-k>";
          run = "move eol";
          desc = "Move to the EOL";
        }
        {
          on = "<C-n>";
          run = "backspace";
          desc = "Delete the character before the cursor";
        }
      ];

    };
    confirm = {
      prepend_keymap = [
        {
          on = "i";
          run = "arrow prev";
          desc = "Previous line";
        }
        {
          on = "e";
          run = "arrow next";
          desc = "Next line";
        }
      ];

    };
    cmp = {
      prepend_keymap = [
        {
          on = "<A-i>";
          run = "arrow prev";
          desc = "Previous item";
        }
        {
          on = "<A-e>";
          run = "arrow next";
          desc = "Next item";
        }
      ];

    };
    help = {
      prepend_keymap = [
        {
          on = "i";
          run = "arrow prev";
          desc = "Previous line";
        }
        {
          on = "e";
          run = "arrow next";
          desc = "Next line";
        }
      ];
    };
  };
in
merge base (
  if keyboard == "colemak" then
    colemak
  else if keyboard == "qwerty" then
    qwerty
  else
    builtins.trace "warning (helix): unknown keyboard layout ${keyboard}" { }
)
