{
  description = "Configs for my personal NixOS systems following the dendritic pattern.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrapper-modules = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # veila = {
    #   url = "github:naurissteins/Veila";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      # define attributes available in every module
      _module.args.shared = rec {
        # color schemes
        themes = {
          celeste = import ./themes/celeste.nix;
        };

        # physical keyboard layouts
        keyboards = {
          qwerty = import ./keyboards/qwerty.nix;
          colemak = import ./keyboards/colemak.nix;
        };

        # generate package variants for every theme
        mkThemeVariants =
          { basename, mk }:
          let
            themeVariants = builtins.attrNames themes;
            combos = map (theme: {
              name = "${basename}-${theme}";
              value = mk theme;
            }) themeVariants;
          in
          builtins.listToAttrs combos;

        # generate package variants for every theme-keyboard combi
        mkVariants =
          { basename, mk }:
          let
            keymapVariants = builtins.attrNames keyboards;

            perKeyboard = map (
              keyboard:
              mkThemeVariants {
                basename = "${basename}-${keyboard}";
                mk = mk keyboard;
              }
            ) keymapVariants;
          in
          builtins.foldl' (acc: v: acc // v) { } perKeyboard;
      };

      imports = [
        (inputs.import-tree [
          ./modules
          ./hosts
        ])
      ];
    };
}
