{
  ...
}:
{
  flake.nixosModules.opencode =
    {
      pkgs,
      ...
    }:
    {
      environment.systemPackages = [
        pkgs.opencode
        pkgs.goose-cli
        pkgs.aider-chat
      ];
    };
}
