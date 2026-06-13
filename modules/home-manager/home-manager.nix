{ inputs, ... }:
{
  flake.nixosModules.home-manager =
    { pkgs, ... }:
    {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.aki = {
          home.stateVersion = "26.05";
          gtk = {
            enable = true;
            colorScheme = "dark";
            theme = {
              name = "catppuccin-frappe-blue-standard";
              package = pkgs.catppuccin-gtk;
            };
          };
          xdg.userDirs = {
            enable = true;
            createDirectories = true;
            desktop = "$HOME/downloads";
            documents = "$HOME/downloads";
            download = "$HOME/downloads";
            music = "$HOME/downloads";
            pictures = "$HOME/downloads";
            projects = "$HOME/downloads";
            publicShare = "$HOME/downloads";
            templates = "$HOME/downloads";
            videos = "$HOME/downloads";
          };
        };
      };
    };
}
