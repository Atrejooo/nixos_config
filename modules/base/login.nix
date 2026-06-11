{
  flake.nixosModules.base =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.login;
    in
    {
      options.login.sessionCommand = lib.mkOption {
        type = lib.types.str;
        default = "";
        example = "niri-session";
        description = "The command to be run by tuigreet.";
      };

      config = {
        services.greetd = {
          enable = true;
          settings = {
            default_session = {
              command = "${lib.getExe pkgs.tuigreet} --time --asterisks  --container-padding 2 --no-xsession-wrapper --cmd ${cfg.sessionCommand}";
              user = "greeter";
            };
          };
        };

        systemd = {
          services.greetd.serviceConfig = {
            Type = "idle";
            StandardInput = "tty";
            StandardOutput = "tty";
            StandardError = "journal";
            TTYReset = true;
            TTYVHangup = true;
            TTYVTDisallocate = true;
          };
        };

        assertions = [
          {
            assertion = cfg.sessionCommand != null && cfg.sessionCommand != "";
            message = "login.sessionCommand must be set (e.g. niri-session when using niri).";
          }
        ];
      };
    };
}
