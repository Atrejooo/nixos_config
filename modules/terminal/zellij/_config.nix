{
  theme,
  keyboard,
  layout_dir,
}:
{

  web_client.font = "monospace";
  default_shell = "fish";
  default_layout = "dev";

  layout_dir = layout_dir;

  mouse_mode = false;
  pane_frames = false;
  copy_command = "wl-copy";
  show_startup_tips = false;

  theme = "nixos";
  themes.nixos = import ./_theme.nix theme;

  keybinds = _: {
    props = [ { clear-defaults = true; } ];
    content = import ./_binds.nix keyboard;
  };

}
