{
  nixosModules.transmission =
    { config, ... }:
    let
      inherit (config) utils;
      webPort = 9091;
      torrentingPort = 51413;
      domain = config.caddy.domain;
    in
    {
      homepage.services.transmission = {
        url = "transmission.${domain}";
        homepage = {
          name = "Transmission";
          description = "Torrent client";
          icon = "sh-transmission";
          category = "Media";
        };
      };

      networking.firewall = utils.mkFirewallPort torrentingPort;

      users.users.transmission.extraGroups = [ "external" ];

      systemd.tmpfiles.rules = [
        "d /srv/transmission 0750 transmission transmission -"
        "d /srv/transmission/.config 0750 transmission transmission -"
        "d /srv/transmission/.config/transmission-daemon 0750 transmission transmission -"
      ];

      services = {
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "transmission";
          port = webPort;
          auth = true;
        };
        transmission = {
          enable = true;
          home = "/srv/transmission";
          openFirewall = false;
          settings = {
            rpc-bind-address = "127.0.0.1";
            rpc-port = webPort;
            rpc-authentication-required = false;
            rpc-host-whitelist = "transmission.${domain}";
            rpc-host-whitelist-enabled = true;
            download-dir = "/mnt/external/downloads";
            incomplete-dir = "/mnt/external/downloads/.incomplete";
            incomplete-dir-enabled = true;
            peer-port = torrentingPort;
            peer-port-random-on-start = false;
            upnp-enabled = false;
            natpmp-enabled = false;
            ratio-limit = 0;
            ratio-limit-enabled = true;
          };
        };
      };

      systemd.services.transmission.after = [ "mnt-external.mount" ];
    };
}
