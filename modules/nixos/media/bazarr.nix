{
  flake.modules.nixos.bazarr =
    { config, ... }:
    {
      homepage.services.bazarr = {
        siteMonitor = "http://127.0.0.1:6767";
        homepage = {
          name = "Bazarr";
          description = "Subtitle management";
          category = "Media";
        };
      };

      systemd.services.bazarr = config.utils.dependsOnPostgres // {
        serviceConfig.SupplementaryGroups = [ "external" ];
      };

      services = {
        bazarr = {
          enable = true;
          settings = {
            backup.folder = "/var/lib/bazarr/backup";
            postgresql = {
              enabled = true;
              host = "/run/postgresql";
              port = 5432;
              database = "bazarr";
              username = "bazarr";
            };
            translator.lingarr_url = "";
          };
        };
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "bazarr";
          port = 6767;
          auth = true;
        };
        postgresql = config.utils.mkPostgres "bazarr";
      };
    };
}
