let
  dataDir = "/srv/authelia";
in
{
  nixosModules.authelia =
    { config, ... }:
    let
      domain = config.caddy.domain;
    in
    {
      systemd.tmpfiles.rules = [
        "d ${dataDir} 0700 authelia authelia -"
      ];

      homepage.services.authelia = {
        url = "auth.${config.caddy.domain}";
        monitoredServices = [ "authelia" ];
        homepage = {
          name = "Authelia";
          description = "Authentication portal";
          icon = "sh-authelia";
          category = "Services";
        };
      };

      systemd.services.authelia.serviceConfig.ReadWritePaths = [ dataDir ];

      services = {
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "auth";
          port = 9099;
          auth = false;
        };
        authelia.instances.default = {
          name = "";
          enable = true;
          settings = {
            theme = "auto";
            server.address = "tcp://127.0.0.1:9099/";
            storage.local.path = "${dataDir}/db.sqlite3";
            notifier.filesystem.filename = "${dataDir}/notification.txt";
            authentication_backend.file = {
              path = config.age.secrets."users.yaml".path;
              watch = false;
            };
            default_2fa_method = "webauthn";
            log = {
              level = "info";
              format = "text";
            };
            access_control = {
              default_policy = "deny";
              rules = [
                {
                  domain = "*.${domain}";
                  policy = "two_factor";
                }
              ];
            };
            session.cookies = [
              {
                name = "authelia_session";
                domain = domain;
                authelia_url = "https://auth.${domain}";
                expiration = "1h";
                inactivity = "5m";
                remember_me = "1M";
              }
            ];
          };
          settingsFiles = [ config.age.secrets."authelia.yaml".path ];
          secrets = {
            manual = true;
          };
        };
      };
    };
}
