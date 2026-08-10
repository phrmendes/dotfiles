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

      services = {
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "auth";
          port = 9091;
          auth = false;
        };
        authelia.instances.default = {
          name = "";
          enable = true;

          settings = {
            theme = "auto";
            server.address = "tcp://127.0.0.1:9091/";
            storage.local.path = "${dataDir}/db.sqlite3";
            notifier.filesystem.filename = "${dataDir}/notification.txt";
            default_2fa_method = "webauthn";
            log = {
              level = "info";
              format = "text";
            };
            authentication_backend.file = {
              path = config.age.secrets."authelia-users.yaml".path;
              watch = false;
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

          secrets = {
            jwtSecretFile = config.age.secrets."authelia-jwt-secret".path;
            storageEncryptionKeyFile = config.age.secrets."authelia-storage-key".path;
          };
        };
      };
    };
}
