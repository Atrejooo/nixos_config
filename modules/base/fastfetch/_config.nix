lib:
let
  r = count: what: lib.strings.replicate count what;
  makeHeader =
    name:
    "{#dim_blue}[+${r 22 "-"}<{{  {#reset_blue}${padCenter 16 name}{#dim_blue}  }>${r 22 "-"}+]{#}";
  footer = "{#dim_blue}\\${r 10 "_"}${r 50 " "}${r 10 "_"}/{#}";
  makeKey = name: "    > ${name}";
  padCenter =
    width: s:
    let
      len = builtins.stringLength s;
      total = width - len;
      left = total / 2;
      right = total - left;
    in
    lib.strings.replicate left " " + s + lib.strings.replicate right " ";
in
{
  logo = {
    # small nixos ascii art logo from https://gitlab.com/ntgn/ascii-art
    # regular sized nixos ascii art logo by me, CC0 license
    source = "${./nix_logo.txt}";
    height = 20;
    padding = {
      top = 3;
      left = 1;
      right = 1;
    };
    color = {
      "1" = "dim_blue";
      "2" = "reset_blue";
      "3" = "dim_blue";
      "4" = "reset_blue";
      "5" = "dim_blue";
      "6" = "reset_blue";
    };
  };
  display = {
    separator = "";
    percent = {
      type = [
        "num"
        "bar"
      ];
    };
    bar = {
      char = {
        elapsed = "#";
        total = "-";
      };
      border = {
        left = "[";
        right = "]";
      };
      color = {
        elapsed = "blue";
        border = "magenta";
        total = "magenta";
      };
      width = 8;
    };
    key = {
      width = 20;
    };
  };
  modules = [
    {
      type = "title";
      format = "${makeHeader "Software Info"}";
    }
    {
      type = "title";
      key = makeKey "User@Host";
      format = "{1}@{2}";
      keyColor = "magenta";
    }
    {
      type = "os";
      key = makeKey "OS";
      keyColor = "blue";
    }
    {
      type = "command";
      key = makeKey "OS Age";
      keyColor = "blue";
      text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
    }
    {
      type = "packages";
      key = makeKey "Packages";
      keyColor = "blue";
    }
    {
      type = "kernel";
      key = makeKey "Kernel";
      keyColor = "cyan";
    }
    {
      type = "bootmgr";
      key = makeKey "Boot";
      keyColor = "cyan";
      format = "{1}";
    }
    {
      type = "wm";
      key = makeKey "WM";
      keyColor = "cyan";
    }
    {
      type = "uptime";
      key = makeKey "Uptime";
      keyColor = "green";
    }
    {
      type = "terminal";
      key = makeKey "Terminal";
      keyColor = "green";
    }
    {
      type = "shell";
      key = makeKey "Shell";
      keyColor = "green";
    }
    {
      type = "break";
    }
    {
      type = "title";
      format = "${makeHeader "Hardware Info"}";
    }
    {
      type = "host";
      key = makeKey "Host";
      keyColor = "magenta";
    }
    {
      type = "display";
      key = makeKey "Display";
      keyColor = "magenta";
    }
    {
      type = "cpu";
      key = makeKey "CPU";
      keyColor = "blue";
    }
    {
      type = "gpu";
      key = makeKey "GPU";
      keyColor = "blue";
    }
    {
      type = "memory";
      key = makeKey "Memory";
      keyColor = "cyan";
    }
    {
      type = "swap";
      key = makeKey "Swap";
      keyColor = "cyan";
    }
    {
      type = "disk";
      key = makeKey "Disk";
      keyColor = "green";
    }
    {
      type = "btrfs";
      key = makeKey "Allocated";
      keyColor = "green";
      format = "{11} {6} / {7} ({9})";
    }
    {
      type = "battery";
      key = makeKey "Battery";
      keyColor = "green";
      format = "{4} [{2} - {3}] {10}";
    }
    {
      type = "poweradapter";
      key = makeKey "Power Adapter";
      keyColor = "green";
    }
    {
      type = "break";
    }
    {
      type = "colors";
      paddingLeft = 5;
      symbol = "diamond";
    }
    {
      type = "break";
    }
    {
      type = "custom";
      format = footer;
    }
  ];

}
