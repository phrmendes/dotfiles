{ config, ... }:
let
  inherit (config) dotfilesLib;
in
{
  modules.nixos.server.deluge =
    { config, ... }:
    let
      webPort = 8112;
      torrentingPort = 51413;
      domain = config.server.caddy.domain;
    in
    {
      server.homepage.services.deluge = {
        url = "deluge.${domain}";
        monitoredServices = [
          "deluged"
          "deluge-web"
        ];
        homepage = {
          name = "Deluge";
          description = "Torrent client";
          icon = "sh-deluge";
          category = "Media";
        };
      };

      services.caddy.virtualHosts = config.server.caddy.mkVhost "deluge" webPort;

      networking.firewall = dotfilesLib.mkFirewallPort torrentingPort;

      users.users.deluge.extraGroups = [ "external" ];

      systemd.tmpfiles.rules = [ "d /srv/deluge 0750 deluge deluge -" ];

      services.deluge = {
        enable = true;
        declarative = true;
        dataDir = "/srv/deluge";
        authFile = config.age.secrets."deluge.txt".path;
        web = {
          enable = true;
          port = webPort;
        };
        openFirewall = false;
        config = {
          download_location = "/mnt/external/downloads";
          torrentfiles_location = "/mnt/external/downloads/.incomplete";
          listen_ports = [
            torrentingPort
            torrentingPort
          ];
          allow_remote = false;
          max_active_downloading = 5;
          seed_time_limit = 0;
        };
      };
    };
}
