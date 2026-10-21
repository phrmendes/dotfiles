{ config, ... }:
let
  inherit (config) settings;
in
{
  flake.modules.nixos.media =
    {
      config,
      lib,
      ...
    }:
    let
      inherit (config.utils) mkPostgres;
      domain = config.caddy.domain;
      arrs = [
        "sonarr"
        "radarr"
        "prowlarr"
      ];
      postgres = name: {
        postgres = {
          host = "/run/postgresql";
          port = 5432;
          user = name;
          maindb = name;
          logdb = "${name}_log";
        };
      };
      dependsOnPostgres = {
        after = [ "postgresql.target" ];
        requires = [ "postgresql.target" ];
      };
    in
    {
      homepage.services = {
        sonarr = {
          url = "sonarr.${domain}";
          homepage = {
            name = "Sonarr";
            description = "TV series management";
            icon = "sh-sonarr";
            category = "Media";
          };
        };
        radarr = {
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
          url = "bazarr.${domain}";
          homepage = {
            name = "Bazarr";
            description = "Subtitle management";
            icon = "sh-bazarr";
            category = "Media";
          };
        };
        jellyfin = {
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
          sonarr = {
            serviceConfig.SupplementaryGroups = [ "external" ];
          }
          // dependsOnPostgres;
          radarr = {
            serviceConfig.SupplementaryGroups = [ "external" ];
          }
          // dependsOnPostgres;
          prowlarr = {
            serviceConfig.SupplementaryGroups = [ "external" ];
          }
          // dependsOnPostgres;
          bazarr = {
            serviceConfig.SupplementaryGroups = [ "external" ];
            environment = {
              POSTGRES_ENABLED = "true";
              POSTGRES_HOST = "/run/postgresql";
              POSTGRES_PORT = "5432";
              POSTGRES_DATABASE = "bazarr";
              POSTGRES_USERNAME = "bazarr";
            };
          }
          // dependsOnPostgres;
          postgresql-setup.script = lib.mkAfter (
            map (name: ''psql -tAc 'ALTER DATABASE "${name}_log" OWNER TO "${name}"' '') arrs
            |> lib.concatStringsSep "\n"
          );
        };
        tmpfiles.rules = [
          "d /mnt/external/movies 2775 ${settings.user} external -"
          "d /mnt/external/tvshows 2775 ${settings.user} external -"
          "d /mnt/external/downloads 2775 ${settings.user} external -"
          "d /mnt/external/downloads/.incomplete 2770 transmission external -"
          "d /mnt/external/comics 2775 ${settings.user} external -"
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
          dataDir = "/var/lib/sonarr";
          settings = {
            server.bindAddress = "127.0.0.1";
            Auth.Method = "External";
          }
          // postgres "sonarr";
        };
        radarr = {
          enable = true;
          dataDir = "/var/lib/radarr";
          settings = {
            server.bindAddress = "127.0.0.1";
            Auth.Method = "External";
          }
          // postgres "radarr";
        };
        prowlarr = {
          enable = true;
          settings = {
            server.bindAddress = "127.0.0.1";
            Auth.Method = "External";
          }
          // postgres "prowlarr";
        };
        postgresql = lib.mkMerge (
          map mkPostgres (arrs ++ [ "bazarr" ]) ++ [ { ensureDatabases = map (name: "${name}_log") arrs; } ]
        );
        flaresolverr.enable = true;
        bazarr.enable = true;
        jellyfin.enable = true;
      };
    };
}
