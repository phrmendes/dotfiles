let
  dataDir = "/var/lib/authelia";
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
        homepage = {
          name = "Authelia";
          description = "Authentication portal";
          icon = "sh-authelia";
          category = "Services";
        };
      };

      systemd.services.authelia = {
        after = [ "postgresql.target" ];
        requires = [ "postgresql.target" ];
        serviceConfig.ReadWritePaths = [ dataDir ];
      };

      services = {
        postgresql = config.utils.mkPostgres "authelia";
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "auth";
          port = 9099;
        };
        authelia.instances.default = {
          name = "";
          enable = true;
          settings = {
            theme = "dark";
            server.address = "tcp://127.0.0.1:9099/";
            storage.postgres = {
              address = "unix:///run/postgresql";
              database = "authelia";
              username = "authelia";
            };
            notifier.filesystem.filename = "${dataDir}/notification.txt";
            authentication_backend.file = {
              path = config.age.secrets."users.yaml".path;
              watch = false;
            };
            default_2fa_method = "webauthn";
            webauthn = {
              enable_passkey_login = true;
              experimental_enable_passkey_uv_two_factors = true;
              selection_criteria = {
                discoverability = "preferred";
                user_verification = "required";
              };
            };
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
                inherit domain;
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
