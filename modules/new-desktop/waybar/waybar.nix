{
  inputs,
  shared,
  ...
}:
{
  flake.nixosModules.new-desktop =
    {
      pkgs,
      config,
      ...
    }:
    let
      theme = shared.themes.${config.style.theme};

      style = import ./_style.nix { inherit theme; };
      settings = import ./_config.nix { inherit pkgs theme; };

      waybar = inputs.wrapper-modules.wrappers.waybar.wrap {
        inherit pkgs settings;
        # upstream wrapper ignores "style.css".content and generates an empty
        # style file, so point --style at the actual css file instead
        "style.css" = {
          content = style;
          path = pkgs.writeText "waybar-style.css" style;
        };
      };
    in
    {
      environment.systemPackages = [ waybar ];
    };
}
