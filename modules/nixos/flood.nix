{
  nixosModules.flood =
    { config, ... }:
    let
      inherit (config) utils;
      webPort = 9091;
      floodPort = 3001;
      torrentingPort = 51413;
      domain = config.caddy.domain;
    in
    {
      homepage.services.flood = {
        url = "flood.${domain}";
        homepage = {
          name = "Flood";
          description = "Torrent client";
          icon = "sh-flood";
          category = "Media";
        };
      };

      networking.firewall = utils.mkFirewallPort torrentingPort;

      users.users.transmission.extraGroups = [ "external" ];

      services = {
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "flood";
          port = floodPort;
          auth = true;
        };
        flood = {
          enable = true;
          host = "127.0.0.1";
          port = floodPort;
          extraArgs = [
            "--auth"
            "none"
            "--trurl"
            "http://127.0.0.1:${toString webPort}/transmission/rpc"
          ];
        };
        transmission = {
          enable = true;
          openFirewall = false;
          settings = {
            rpc-bind-address = "127.0.0.1";
            rpc-port = webPort;
            rpc-authentication-required = false;
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
