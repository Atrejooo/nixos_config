theme: {
  add_newline = true;
  palette = "colors";
  format = ''
    [╭](fg:txt_emph_0)[](fg:txt_main)$os$username$sudo[ ](fg:txt_main bg:light_base)$directory[ ](fg:light_base)$git_branch
    [╰](fg:txt_emph_0)$character'';
  palettes.colors = {
    dark_base = "#${theme.darkBase}";
    dark_main = "#${theme.darkMain}";
    light_base = "#${theme.lightBase}";
    light_main = "#${theme.lightMain}";
    light_highlight = "#${theme.lightHighlight}";
    txt_main = "#${theme.textMain}";
    txt_dark = "#${theme.textDark}";
    txt_emph_0 = "#${theme.textEmph0}";
    txt_emph_1 = "#${theme.textEmph1}";
    txt_red = "#${theme.textRed}";
  };
  character = {
    success_symbol = "[>](txt_emph_0)";
    error_symbol = "[>](txt_red)";
  };
  os = {
    disabled = false;
    style = "bg:txt_main fg:dark_main";
  };
  sudo = {
    disabled = false;
    format = "[  ]($style)";
    style = "fg:light_base bg:txt_main";
  };
  username = {
    style_user = "bg:txt_main fg:dark_main";
    style_root = "bg:txt_main fg:dark_main";

    format = "[$user]($style)";
    show_always = true;
  };
  directory = {
    read_only = " c#";
    format = "[$path](fg:txt_main bg:light_base)";
    truncation_length = 3;
    truncate_to_repo = true;
    truncation_symbol = "../";
  };
  git_branch = {
    format = "[](fg:txt_main)[](fg:light_base bg:txt_main )[](fg:txt_main bg:light_base)[(fg:txt_main bg:light_base) $branch](fg:txt_main bg:light_base)[](fg:light_base) ";
  };
  os.symbols = {
    NixOS = " ";
    Arch = "󰣇 ";

    # other cause why not
    Alpine = " ";
    Amazon = " ";
    Android = " ";
    Artix = "󰣇 ";
    CentOS = " ";
    Debian = "󰣚 ";
    EndeavourOS = " ";
    Fedora = "󰣛 ";
    Gentoo = "󰣨 ";
    Linux = "󰌽 ";
    Macos = "󰀵 ";
    Manjaro = " ";
    Mint = "󰣭 ";
    Pop = " ";
    Raspbian = "󰐿 ";
    RedHatEnterprise = "󱄛 ";
    Redhat = "󱄛 ";
    SUSE = " ";
    Ubuntu = "󰕈 ";
    Windows = "󰍲 ";
  };
}
