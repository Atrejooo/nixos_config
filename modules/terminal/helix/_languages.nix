{ pkgs, ... }:
{
  language-server.gdscript-lsp = {
    command = "nc";
    args = [
      "127.0.0.1"
      "6005"
    ];
  };
  # color code previews
  language-server.uwu_colors = {
    command = "${pkgs.uwu-colors}/bin/uwu_colors";
  };

  language = [
    {
      name = "c-sharp";
      auto-format = true;
      scope = "source.cs";
      file-types = [ "cs" ];
      roots = [
        "*.sln"
        "*.csproj"
        ".git"
      ];
      formatter = {
        command = "csharpier";
        args = [
          "format"
          "--write-stdout"
        ];
      };
      language-servers = [ "csharp-ls" ];
    }
    {
      name = "gdscript";
      auto-format = true;
      scope = "source.gd";
      roots = [
        "project.godot"
        ".git"
      ];
      file-types = [ "gd" ];
      formatter = {
        command = "gdscript-formatter";
        args = [ "--reorder-code" ];
      };
      language-servers = [ "gdscript-lsp" ];
    }
    {
      name = "nix";
      auto-format = true;
      scope = "source.nix";
      roots = [
        "flake.nix"
        ".git"
      ];
      file-types = [ "nix" ];
      formatter = {
        command = "nixfmt";
      };
      language-servers = [
        "nixd"
        "uwu_colors"
      ];
    }

    # {
    #   name = "toml";
    #   file-types = [ "toml" ];
    #   language-servers = [
    #     "uwu_colors"
    #   ];
    # }
    # {
    #   name = "txt";
    #   file-types = [ "txt" ];
    #   language-servers = [
    #     "uwu_colors"
    #   ];
    # }
    # {
    #   name = "md";
    #   file-types = [ "txt" ];
    #   language-servers = [
    #     "uwu_colors"
    #   ];
    # }
  ];
}
