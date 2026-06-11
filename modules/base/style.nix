{
  flake.nixosModules.base =
    {
      lib,
      shared,
      ...
    }:
    {
      options.style = {
        keyboard = lib.mkOption {
          type = lib.types.enum (builtins.attrNames shared.keyboards);
        };
        theme = lib.mkOption {
          type = lib.types.enum (builtins.attrNames shared.themes);
        };
      };
    };
}
