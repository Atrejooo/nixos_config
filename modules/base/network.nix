{
  flake.nixosModules.base = {
    # have all connections managed by networkmanager
    # using systemd-resolved with security settings for dns
    # exclusively via cloudflare
    networking = {
      nameservers = [
        "1.1.1.1#one.one.one.one"
        "1.0.0.1#one.one.one.one"
      ];
      networkmanager = {
        enable = true;
        unmanaged = [ ];
        dns = "systemd-resolved";
      };

      useDHCP = false;
      firewall.enable = true;
    };

    services.resolved = {
      enable = true;

      settings.Resolve = {
        fallbackDns = [ ];
        dnssec = "true";
        domains = [ "~." ];
        dnsovertls = "true";
        LLMNR = "false";
      };
    };

    # do not wait to be online for boot
    systemd = {
      services.NetworkManager-wait-online.enable = false;
      network.wait-online.enable = false;
    };
  };
}
