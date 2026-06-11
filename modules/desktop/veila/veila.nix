{
  inputs,
  shared,
  ...
}:
{
  flake.nixosModules.desktop =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      tomlFormat = pkgs.formats.toml { };
      theme = shared.themes."${config.style.theme}";
      veilaConfig = tomlFormat.generate "veila-config.toml" (import ./_config.nix theme);
    in
    {
      imports = [ inputs.veila.nixosModules.default ];
      programs.veila.enable = true;
      systemd.user.services.veilad = {
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        requisite = [ "graphical-session.target" ];
        wantedBy = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${
            lib.getExe' inputs.veila.packages.${pkgs.stdenv.hostPlatform.system}.default "veilad"
          } --config=${veilaConfig}";
        };
      };
    };
}
