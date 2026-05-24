{ config, ... }:
let
  inherit (config) settings;
in
{
  modules.nixos.server.media =
    { config, ... }:
    let
      domain = config.server.caddy.domain;
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
          dataDir = "/srv/prowlarr";
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

      users.users.jellyfin.extraGroups = [ "media" ];

      systemd = {
        services = {
          sonarr.serviceConfig.SupplementaryGroups = [ "media" ];
          radarr.serviceConfig.SupplementaryGroups = [ "media" ];
          prowlarr.serviceConfig.SupplementaryGroups = [ "media" ];
          bazarr.serviceConfig.SupplementaryGroups = [ "media" ];
        };
        tmpfiles.rules = [
          "d /mnt/external/movies 2775 ${settings.user} media -"
          "a+ /mnt/external/movies - - - - g:media:rwx,d:g:media:rwx"
          "d /mnt/external/tvshows 2775 ${settings.user} media -"
          "a+ /mnt/external/tvshows - - - - g:media:rwx,d:g:media:rwx"
          "d /mnt/external/downloads 2775 ${settings.user} media -"
          "a+ /mnt/external/downloads - - - - g:media:rwx,d:g:media:rwx"
          "d /mnt/external/comics 2775 ${settings.user} media -"
          "a+ /mnt/external/comics - - - - g:media:rwx,d:g:media:rwx"
          "d /srv/sonarr 0750 sonarr sonarr -"
          "d /srv/radarr 0750 radarr radarr -"
          "d /srv/prowlarr 0750 prowlarr prowlarr -"
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
          settings = {
            auth = {
              method = "Forms";
              required = "Enabled";
            };
            log = {
              analyticsEnabled = false;
              level = "info";
            };
            update.mechanism = "external";
            app.instanceName = "Sonarr";
          };
        };
        radarr = {
          enable = true;
          dataDir = "/srv/radarr";
          settings = {
            auth = {
              method = "Forms";
              required = "Enabled";
            };
            log = {
              analyticsEnabled = false;
              level = "info";
            };
            update.mechanism = "external";
            app.instanceName = "Radarr";
          };
        };
        prowlarr = {
          enable = true;
          dataDir = "/srv/prowlarr";
          settings = {
            auth = {
              method = "Forms";
              required = "Enabled";
            };
            log = {
              analyticsEnabled = false;
              level = "info";
            };
            update.mechanism = "external";
            app.instanceName = "Prowlarr";
          };
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
