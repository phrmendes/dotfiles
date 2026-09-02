{
  nixosModules.miniflux =
    { config, ... }:
    let
      port = 8088;
    in
    {
      homepage.services.miniflux = {
        url = "miniflux.${config.caddy.domain}";
        homepage = {
          name = "Miniflux";
          description = "Feed reader";
          icon = "sh-miniflux";
          category = "Services";
        };
      };

      users.users.miniflux = {
        isSystemUser = true;
        group = "miniflux";
      };
      users.groups.miniflux = { };

      services.caddy.virtualHosts = config.caddy.mkVhost {
        name = "miniflux";
        inherit port;
      };

      services.miniflux = {
        enable = true;
        config = {
          LISTEN_ADDR = "127.0.0.1:${toString port}";
          DATABASE_URL = "user=miniflux host=/run/postgresql dbname=miniflux";
          OAUTH2_PROVIDER = "oidc";
          OAUTH2_CLIENT_ID = "miniflux";
          OAUTH2_OIDC_DISCOVERY_ENDPOINT = "https://auth.${config.caddy.domain}";
          OAUTH2_REDIRECT_URL = "https://miniflux.${config.caddy.domain}/oauth2/oidc/callback";
          OAUTH2_USER_CREATION = 1;
          RUN_MIGRATIONS = 1;
        };
      };

      systemd.services.miniflux = {
        serviceConfig = {
          DynamicUser = false;
          EnvironmentFile = config.age.secrets."miniflux.env".path;
        };
      };
    };
}
