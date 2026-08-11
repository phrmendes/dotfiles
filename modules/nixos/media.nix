{ config, ... }:
let
  inherit (config) settings;
in
{
  nixosModules.media =
    {
      config,
      ...
    }:
    let
      domain = config.caddy.domain;
    in
    {
      homepage.services = {
        sonarr = {
          dataDir = "/srv/sonarr";
          url = "sonarr.${domain}";
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
          homepage = {
            name = "Radarr";
            description = "Movie management";
            icon = "sh-radarr";
            category = "Media";
          };
        };
        prowlarr = {
          url = "prowlarr.${domain}";
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
          sonarr.serviceConfig.SupplementaryGroups = [ "external" ];
          radarr.serviceConfig.SupplementaryGroups = [ "external" ];
          prowlarr.serviceConfig.SupplementaryGroups = [ "external" ];
          bazarr.serviceConfig.SupplementaryGroups = [ "external" ];
        };
        tmpfiles.rules = [
          "d /mnt/external/movies 2775 ${settings.user} external -"
          "d /mnt/external/tvshows 2775 ${settings.user} external -"
          "d /mnt/external/downloads 2775 ${settings.user} external -"
          "d /mnt/external/downloads/.incomplete 2770 transmission external -"
          "d /mnt/external/comics 2775 ${settings.user} external -"
          "d /srv/sonarr 0750 sonarr sonarr -"
          "d /srv/radarr 0750 radarr radarr -"
          "d /srv/bazarr 0750 bazarr bazarr -"
          "d /srv/jellyfin 0750 jellyfin jellyfin -"
        ];
      };

      services = {
        caddy.virtualHosts =
          (config.caddy.mkVhost {
            name = "sonarr";
            port = 8989;
            auth = true;
          })
          // (config.caddy.mkVhost {
            name = "radarr";
            port = 7878;
            auth = true;
          })
          // (config.caddy.mkVhost {
            name = "prowlarr";
            port = 9696;
            auth = true;
          })
          // (config.caddy.mkVhost {
            name = "bazarr";
            port = 6767;
            auth = true;
          })
          // (config.caddy.mkVhost {
            name = "jellyfin";
            port = 8096;
          });
        sonarr = {
          enable = true;
          dataDir = "/srv/sonarr";
          settings = {
            server.bindAddress = "127.0.0.1";
            Auth.Method = "External";
          };
        };
        radarr = {
          enable = true;
          dataDir = "/srv/radarr";
          settings = {
            server.bindAddress = "127.0.0.1";
            Auth.Method = "External";
          };
        };
        prowlarr = {
          enable = true;
          settings = {
            server.bindAddress = "127.0.0.1";
            Auth.Method = "External";
          };
        };
        flaresolverr.enable = true;
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
