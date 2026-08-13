{
  flake.nixosModules.steam = { pkgs, ... }: {
    programs.steam.enable = true;

    # For a problem where mouse input wasn't collected in some steam games,
    # when using fractional output scaling in niri.
    #
    # If using an iteger scale (i.e. 1, 2) is not an option use gamescope:
    #
    # NOTE: I added a shell script "niri-toggle-output-scale" that
    # toggles between the cofgiured display scale and the scale from the toggleOutputScale niri option
    #
    # gamescope wraps Proton games as native Wayland clients of niri, avoiding
    # broken mouse input under fractional scaling via xwayland-satellite
    # (xwayland-satellite#199).
    # Per-game Steam launch option can call it.
    # Under game -> properties -> general -> launch options set:
    #
    #   gamescope -f -w 2560 -h 1440 -W 2560 -H 1440 -- %command%
    #
    # programs.gamescope.enable = true;
  };
}
