{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.server.media =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      domain = config.server.caddy.domain;
      arrNotify = pkgs.writeShellApplication {
        name = "arr-notify";
        runtimeInputs = [ pkgs.local.telegram-notify ];
        text = ''
          case "$sonarr_eventtype$radarr_eventtype" in
            Grab*)
              telegram-notify info "Media Grabbed" "$sonarr_seriesname$radarr_movietitle — $sonarr_releasetitle$radarr_releasetitle"
              ;;
            Download*)
              telegram-notify info "Download Complete" "$sonarr_seriesname$radarr_movietitle — $sonarr_episodefile_relativpath$radarr_moviefile_relativpath"
              ;;
            Import*)
              telegram-notify info "Imported" "$sonarr_seriesname$radarr_movietitle added to library"
              ;;
            ImportFailure*)
              telegram-notify error "Import Failed" "$sonarr_seriesname$radarr_movietitle — $sonarr_importerror$radarr_importerror"
              ;;
            *)
              exit 0
              ;;
          esac
        '';
      };
      arrNotifyScript = {
        enable = true;
        name = "Telegram Notify";
        implementation = "CustomScript";
        configContract = "CustomScriptSettings";
        settings = {
          path = lib.getExe arrNotify;
          onGrab = true;
          onDownload = true;
          onImport = true;
          onUpgrade = false;
          onRename = false;
          onMovieDelete = false;
          onSeriesDelete = false;
        };
      };
    in
    {
      server.homepage.services = {
        sonarr = {
          dataDir = "/srv/sonarr";
          url = "sonarr.${domain}";
          monitoredServices = [ "sonarr" ];
          homepage = {
            name = "Sonarr";
            description = "TV series management";
            icon = "sh-sonarr";
            category = "Media";
          };
        };
        radarr = {
          dataDir = "/srv/radarr";
          url = "radarr.${domain}";
          monitoredServices = [ "radarr" ];
          homepage = {
            name = "Radarr";
            description = "Movie management";
            icon = "sh-radarr";
            category = "Media";
          };
        };
        prowlarr = {
          url = "prowlarr.${domain}";
          monitoredServices = [ "prowlarr" ];
          homepage = {
            name = "Prowlarr";
            description = "Indexer management";
            icon = "sh-prowlarr";
            category = "Media";
          };
        };
        bazarr = {
          dataDir = "/srv/bazarr";
          url = "bazarr.${domain}";
          monitoredServices = [ "bazarr" ];
          homepage = {
            name = "Bazarr";
            description = "Subtitle management";
            icon = "sh-bazarr";
            category = "Media";
          };
        };
        jellyfin = {
          dataDir = "/srv/jellyfin";
          url = "jellyfin.${domain}";
          monitoredServices = [ "jellyfin" ];
          homepage = {
            name = "Jellyfin";
            description = "Media server";
            icon = "sh-jellyfin";
            category = "Media";
          };
        };
      };

      users.users.jellyfin.extraGroups = [ "external" ];

      systemd = {
        services = {
          sonarr.serviceConfig = {
            SupplementaryGroups = [ "external" ];
            EnvironmentFile = config.age.secrets."telegram.env".path;
          };
          radarr.serviceConfig = {
            SupplementaryGroups = [ "external" ];
            EnvironmentFile = config.age.secrets."telegram.env".path;
          };
          prowlarr.serviceConfig.SupplementaryGroups = [ "external" ];
          bazarr.serviceConfig.SupplementaryGroups = [ "external" ];
        };
        tmpfiles.rules = [
          "d /mnt/external/movies 2775 ${settings.user} external -"
          "d /mnt/external/tvshows 2775 ${settings.user} external -"
          "d /mnt/external/downloads 2775 ${settings.user} external -"
          "d /mnt/external/comics 2775 ${settings.user} external -"
          "d /srv/sonarr 0750 sonarr sonarr -"
          "d /srv/radarr 0750 radarr radarr -"
          "d /srv/bazarr 0750 bazarr bazarr -"
          "d /srv/jellyfin 0750 jellyfin jellyfin -"
        ];
      };

      services = {
        caddy.virtualHosts =
          (config.server.caddy.mkVhost "sonarr" 8989)
          // (config.server.caddy.mkVhost "radarr" 7878)
          // (config.server.caddy.mkVhost "prowlarr" 9696)
          // (config.server.caddy.mkVhost "bazarr" 6767)
          // (config.server.caddy.mkVhost "jellyfin" 8096);
        sonarr = {
          enable = true;
          dataDir = "/srv/sonarr";
          settings.server.bindAddress = "127.0.0.1";
          settings.customScripts = [ arrNotifyScript ];
        };
        radarr = {
          enable = true;
          dataDir = "/srv/radarr";
          settings.server.bindAddress = "127.0.0.1";
          settings.customScripts = [ arrNotifyScript ];
        };
        prowlarr = {
          enable = true;
          settings.server.bindAddress = "127.0.0.1";
        };
        bazarr = {
          enable = true;
          dataDir = "/srv/bazarr";
        };
        jellyfin = {
          enable = true;
          dataDir = "/srv/jellyfin";
        };
      };
    };
}
