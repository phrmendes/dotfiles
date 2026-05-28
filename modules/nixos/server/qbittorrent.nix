{ config, ... }:
let
  inherit (config) dotfilesLib;
in
{
  modules.nixos.server.qbittorrent =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      webuiPort = 8080;
      torrentingPort = 51413;
      domain = config.server.caddy.domain;
    in
    {
      server.homepage.services.qbittorrent = {
        url = "qbittorrent.${domain}";
        monitoredServices = [ "qbittorrent" ];
        homepage = {
          name = "qBittorrent";
          description = "Torrent client";
          icon = "sh-qbittorrent";
          category = "Media";
        };
      };

      services.caddy.virtualHosts = config.server.caddy.mkVhost "qbittorrent" webuiPort;

      users.users.qbittorrent.extraGroups = [ "external" ];

      networking.firewall = dotfilesLib.mkFirewallPort torrentingPort;

      services.qbittorrent = {
        enable = true;
        profileDir = "/srv/qbittorrent";
        inherit webuiPort torrentingPort;
        serverConfig = {
          LegalNotice.Accepted = true;
          BitTorrent.Session = {
            DefaultSavePath = "/mnt/external/downloads";
            TempPath = "/mnt/external/downloads/.incomplete";
            TempPathEnabled = true;
            Port = torrentingPort;
            MaxActiveDownloads = 5;
            GlobalMaxSeedsRatio = "0";
          };
          Core = {
            AutoRunOnTorrentFinishedEnabled = true;
            AutoRunOnTorrentFinishedProgram =
              let
                qbtDone = pkgs.writeShellApplication {
                  name = "qbt-done";
                  runtimeInputs = [ pkgs.local.telegram-notify ];
                  text = ''telegram-notify info "Download Complete" "$1 — saved to $2"'';
                };
              in
              ''${lib.getExe qbtDone} "%N" "%D"'';
          };
          Preferences.WebUI = {
            Port = webuiPort;
            HostHeaderValidation = false;
            LocalHostAuth = false;
          };
        };
      };
    };
}
