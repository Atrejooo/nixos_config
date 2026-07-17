{ config, lib, ... }:

let
  labels = import ./_labels.nix;
  hostConfigs = config.hostInstall;
in
{
  options.hostInstall = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options.diskDevice = lib.mkOption { type = lib.types.str; };
        options.swapSize = lib.mkOption {
          type = lib.types.str;
          default = "32G";
        };
        options.username = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
        };
      }
    );
    default = { };
    description = "Per-host install configuration for the installer app.";
  };

  config.perSystem =
    { pkgs, ... }:
    let
      wrapper = pkgs.writeShellApplication {
        name = "install-system";
        text = ''
          set -euo pipefail

          # -- parse --host --
          HOST=""; ARGS=()
          while [[ $# -gt 0 ]]; do
            case "$1" in
              --host=*) HOST="''${1#--host=}"; shift ;;
              --host)   HOST="$2"; shift 2 ;;
              --help|-h)
                echo "Usage: nix run .#install -- --host <host> [options]"
                echo "Hosts: ${toString (builtins.attrNames hostConfigs)}"
                exit 0 ;;
              *) ARGS+=("$1"); shift ;;
            esac
          done

          # -- resolve host config (baked-in from Nix) --
          case "$HOST" in
            ${lib.concatStringsSep "\n        " (
              lib.mapAttrsToList (name: cfg: ''
                ${name})
                  DISK="${cfg.diskDevice}"
                  SWAP="${cfg.swapSize}"
                  ;;
              '') hostConfigs
            )}
            *)
              echo "Unknown host: $HOST"
              echo "Known: ${toString (builtins.attrNames hostConfigs)}"
              exit 1
              ;;
          esac

          exec ${pkgs.writeShellScript "install-sh" (builtins.readFile ./install.sh)} \
            --disk "$DISK" \
            --host "$HOST" \
            --swap-size "$SWAP" \
            --luks-partlabel "${labels.luksPartlabel}" \
            --efi-label "${labels.efiLabel}" \
            --luks-name "${labels.luksName}" \
            "''${ARGS[@]}"
        '';
      };
    in
    {
      apps.install = {
        type = "app";
        meta.description = "Install NixOS on a host (disk, LUKS, Btrfs, nixos-install)";
        program = "${wrapper}/bin/install-system";
      };
    };
}
