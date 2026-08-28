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
        pkgs.aider-chat
      ];
    };
}
