{ config, ... }:
let
  inherit (config) dotfilesLib;
in
{
  modules.nixos.server.transmission =
    {
      config,
      pkgs,
      ...
    }:
    let
      webPort = 9091;
      torrentingPort = 51413;
      domain = config.server.caddy.domain;
      notifyScript = pkgs.writeShellApplication {
        name = "transmission-notify";
        runtimeInputs = [ pkgs.local.telegram-notify ];
        text = ''
          telegram-notify info "Download Complete" "$TR_TORRENT_NAME — saved to $TR_TORRENT_DIR"
        '';
      };
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
          rpc-authentication-required = true;
          rpc-host-whitelist = "transmission.${domain}";
          rpc-host-whitelist-enabled = true;
          download-dir = "/mnt/external/downloads";
          incomplete-dir = "/mnt/external/downloads/.incomplete";
          incomplete-dir-enabled = true;
          peer-port = torrentingPort;
          peer-port-random-on-start = false;
          ratio-limit = 0;
          ratio-limit-enabled = true;
          script-torrent-done-enabled = true;
          script-torrent-done-filename = "${notifyScript}/bin/transmission-notify";
        };
      };

      systemd.services.transmission.serviceConfig.EnvironmentFile =
        config.age.secrets."telegram.env".path;
    };
}
