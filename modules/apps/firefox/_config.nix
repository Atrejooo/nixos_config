lib:
let
  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  prefs = {
    # dark theme
    "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    # block all ai 'features' by default
    "browser.ai.control.default" = "blocked";
    # block sponsored
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.system.showSponsored" = false;
    # Check these out at about:config
    # refers to https://wiki.archlinux.org/title/Firefox/Privacy
    "dom.security.https_only_mode" = true;
    # better load time and protection :)
    "privacy.trackingprotection.enabled" = true;
    # experimental setting but can be good
    "privacy.resistFingerprinting" = true;
    # overriedes user agent (platform must match user agent or figerprinting becomes unique)
    # The value Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101 Firefox/102.0 is used as the user agent for the Tor browser, thus being very common.
    "general.useragent.override" =
      "Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101 Firefox/102.0";
    # The value Win32 is used as the platform for the Tor browser
    "general.platform.override" = "Win32";
    # hide ip
    "media.peerconnection.ice.default_address_only" = true;
    "media.peerconnection.enabled" = true; # (breaks discord)
    # hide previous website
    "network.http.sendRefererHeader" = 0;
    # used for fingerprinting
    "privacy.donottrackheader.enabled" = false;
    # route DNS request over encrypted connection with cloudfare server
    # TODO research how to set it to fall back to normal dns resolver as this sometimes makes the browser unusable
    "network.trr.mode" = 3;
    # enable Encrypted Client Hello (ECH)
    "network.dns.echconfig.enabled" = true;
    "network.dns.http3_echconfig.enabled" = true;
    # send no information to 3rd paries for security checks
    "browser.safebrowsing.malware.enabled" = false;
    "browser.safebrowsing.phishing.enabled" = false;
    "browser.safebrowsing.downloads.enabled" = false;

    # passwords and autofill
    "signon.rememberSignons" = false;
    "browser.formfill.enable" = false;
    "extensions.formautofill.creditCards.enabled" = false;
    "extensions.formautofill.addresses.enabled" = false;

    # visuals and features
    "sidebar.verticalTabs" = true;
  };

  extensions = [
    # To add additional extensions, find it on addons.mozilla.org, find
    # the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
    # Then go to https://addons.mozilla.org/api/v5/addons/addon/!SHORT_ID!/ to get the guid
    (extension "ublock-origin" "uBlock0@raymondhill.net")
    (extension "darkreader" "addon@darkreader.org")
    (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
    (extension "hide-youtube-shorts" "{88ebde3a-4581-4c6b-8019-2a05a9e3e938}")
    (extension "return-youtube-dislikes" "{762f9885-5a13-4abd-9c77-433dcd38b8fd}")
    (extension "sponsorblock" "sponsorBlocker@ajay.app")
    (extension "video-downloadhelper" "{b9db16a4-6edc-47ec-a1f4-b86292ed211d}")
  ];
in
{
  extraPrefs = lib.concatLines (
    lib.mapAttrsToList (
      name: value: "lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});"
    ) prefs
  );

  extraPolicies = {
    DisableTelemetry = true;
    ExtensionSettings = builtins.listToAttrs extensions;
    SearchEngines = {
      Default = "DuckDuckGo";
      Remove = [
        "Google"
        "Bing"
      ];
      Add = [
        {
          Name = "nixpkgs packages";
          URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
          IconURL = "https://wiki.nixos.org/favicon.ico";
          Alias = "@np";
        }
        {
          Name = "NixOS options";
          URLTemplate = "https://search.nixos.org/options?query={searchTerms}";
          IconURL = "https://wiki.nixos.org/favicon.ico";
          Alias = "@no";
        }
        {
          Name = "NixOS Wiki";
          URLTemplate = "https://wiki.nixos.org/w/index.php?search={searchTerms}";
          IconURL = "https://wiki.nixos.org/favicon.ico";
          Alias = "@nw";
        }
        {
          Name = "noogle";
          URLTemplate = "https://noogle.dev/q?term={searchTerms}";
          IconURL = "https://noogle.dev/favicon.ico";
          Alias = "@ng";
        }
      ];
    };
  };
}
