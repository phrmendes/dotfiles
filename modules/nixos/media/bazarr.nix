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
        environment = {
          POSTGRES_ENABLED = "true";
          POSTGRES_HOST = "/run/postgresql";
          POSTGRES_PORT = "5432";
          POSTGRES_DATABASE = "bazarr";
          POSTGRES_USERNAME = "bazarr";
        };
      };

      services = {
        bazarr.enable = true;
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "bazarr";
          port = 6767;
          auth = true;
        };
        postgresql = config.utils.mkPostgres "bazarr";
      };
    };
}
