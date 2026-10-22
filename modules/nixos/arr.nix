let
  mkArr =
    {
      name,
      title,
      description,
      port,
      dataDir ? null,
    }:
    { config, lib, ... }:
    {
      homepage.services.${name} = {
        url = "${name}.${config.caddy.domain}";
        homepage = {
          name = title;
          inherit description;
          icon = "sh-${name}";
          category = "Media";
        };
      };

      systemd.services = {
        ${name} = config.utils.dependsOnPostgres // {
          serviceConfig.SupplementaryGroups = [ "external" ];
        };
        postgresql-setup.script = lib.mkAfter ''psql -tAc 'ALTER DATABASE "${name}_log" OWNER TO "${name}"' '';
      };

      services = {
        caddy.virtualHosts = config.caddy.mkVhost {
          inherit name port;
          auth = true;
        };
        ${name} = {
          enable = true;
          settings = {
            server.bindAddress = "127.0.0.1";
            Auth.Method = "External";
            postgres = {
              host = "/run/postgresql";
              port = 5432;
              user = name;
              maindb = name;
              logdb = "${name}_log";
            };
          };
        }
        // lib.optionalAttrs (dataDir != null) { inherit dataDir; };
        postgresql = lib.mkMerge [
          (config.utils.mkPostgres name)
          { ensureDatabases = [ "${name}_log" ]; }
        ];
      };
    };
in
{
  flake.modules.nixos = {
    sonarr = mkArr {
      name = "sonarr";
      title = "Sonarr";
      description = "TV series management";
      port = 8989;
      dataDir = "/var/lib/sonarr";
    };
    radarr = mkArr {
      name = "radarr";
      title = "Radarr";
      description = "Movie management";
      port = 7878;
      dataDir = "/var/lib/radarr";
    };
    prowlarr = mkArr {
      name = "prowlarr";
      title = "Prowlarr";
      description = "Indexer management";
      port = 9696;
    };
    flaresolverr.services.flaresolverr.enable = true;
  };
}
