{ config, ... }:
let
  inherit (config) dotfilesLib;
in
{
  modules.nixos.server.transmission =
    { config, ... }:
    let
      webPort = 9091;
      torrentingPort = 51413;
      domain = config.server.caddy.domain;
    in
    {
      server.homepage.services.transmission = {
        url = "transmission.${domain}";
        monitoredServices = [ "transmission" ];
        homepage = {
          name = "Transmission";
          description = "Torrent client";
          icon = "sh-transmission";
          category = "Media";
        };
      };

      services.caddy.virtualHosts = config.server.caddy.mkVhost "transmission" webPort;

      networking.firewall = dotfilesLib.mkFirewallPort torrentingPort;

      users.users.transmission.extraGroups = [ "external" ];

      systemd.tmpfiles.rules = [
        "d /srv/transmission 0750 transmission transmission -"
        "d /srv/transmission/.config 0750 transmission transmission -"
        "d /srv/transmission/.config/transmission-daemon 0750 transmission transmission -"
      ];

      services.transmission = {
        enable = true;
        home = "/srv/transmission";
        credentialsFile = config.age.secrets."transmission.json".path;
        openFirewall = false;
        settings = {
          rpc-bind-address = "127.0.0.1";
          rpc-port = webPort;
          rpc-host-whitelist = "transmission.${domain}";
          rpc-host-whitelist-enabled = true;
          download-dir = "/mnt/external/downloads";
          incomplete-dir = "/mnt/external/downloads/.incomplete";
          incomplete-dir-enabled = true;
          peer-port = torrentingPort;
          peer-port-random-on-start = false;
          ratio-limit = 0;
          ratio-limit-enabled = true;
        };
      };
    };
}
