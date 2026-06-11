theme: {
  add_newline = true;
  palette = "colors";
  format = ''
    [╭](fg:txt_highlight)$os$username$sudo$directory$git_branch[](fg:purple)
    [╰](fg:txt_highlight)$character'';
  palettes.colors = {
    dark_base = "#${theme.darkBase}";
    dark_main = "#${theme.darkMain}";
    light_base = "#${theme.lightBase}";
    light_main = "#${theme.lightMain}";
    light_highlight = "#${theme.lightHighlight}";
    txt_main = "#${theme.textMain}";
    txt_dark = "#${theme.textDark}";
    txt_highlight = "#${theme.textEmph0}";
    txt_red = "#${theme.textRed}";
  };
  character = {
    success_symbol = "[>](txt_highlight)";
    error_symbol = "[>](txt_red)";
  };
  os = {
    disabled = false;
    format = "[](fg:blue)[$symbol]($style)";
    style = "bg:blue fg:dark_main";
  };
  sudo = {
    disabled = false;
    format = "[ as sudo ]($style)";
    style = "fg:blue bg:dark_main";
  };
  username = {
    format = "[](fg:dark_main bg:blue)[$user]($style)";
    style_user = "fg:txt_main bg:dark_main";
    style_root = "fg:txt_main bg:dark_main";
    show_always = true;
  };
  directory = {
    read_only = " c#";
    truncate_to_repo = true;
    truncation_symbol = "…/";
    style = "fg:dark_main bg:purple";
    format = "[](fg:purple bg:dark_main)[ in $path$read_only ]($style)";
  };
  git_branch = {
    style = "fg:green bg:dark_main";
    format = "[](fg:dark_main bg:purple)[on $symbol$branch(:$remote_branch) ]($style)[](fg:purple bg:dark_main)";
    truncation_symbol = "…/";
    symbol = "";
  };
  os.symbols = {
    NixOS = " ";
    Windows = "󰍲 ";
    Ubuntu = "󰕈 ";
    SUSE = " ";
    Raspbian = "󰐿 ";
    Mint = "󰣭 ";
    Macos = "󰀵 ";
    Manjaro = " ";
    Linux = "󰌽 ";
    Gentoo = "󰣨 ";
    Fedora = "󰣛 ";
    Alpine = " ";
    Amazon = " ";
    Android = " ";
    Arch = "󰣇 ";
    Artix = "󰣇 ";
    EndeavourOS = " ";
    CentOS = " ";
    Debian = "󰣚 ";
    Redhat = "󱄛 ";
    RedHatEnterprise = "󱄛 ";
    Pop = " ";
  };
}
