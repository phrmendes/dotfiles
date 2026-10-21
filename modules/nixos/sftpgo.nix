{
  flake.modules.nixos.sftpgo =
    { config, ... }:
    let
      sftpPort = 2022;
      httpPort = 8095;
      webdavPort = 10080;
    in
    {
      age.secrets."sftpgo.env" = config.utils.mkSecretReadable {
        file = ../../secrets/sftpgo.age.env;
        owner = "sftpgo";
      };

      homepage.services.sftpgo = {
        url = "sftpgo.${config.caddy.domain}";
        homepage = {
          name = "SFTPGo";
          description = "File transfer server";
          icon = "sh-sftpgo";
          category = "Files";
        };
      };

      networking.firewall.allowedTCPPorts = [ sftpPort ];
      users.users.sftpgo.extraGroups = [ "external" ];

      systemd = {
        services.sftpgo = {
          serviceConfig = {
            EnvironmentFile = config.age.secrets."sftpgo.env".path;
            Restart = "on-failure";
            RestartSec = 5;
          };
          requires = [
            "authelia.service"
            "caddy.service"
            "postgresql.target"
          ];
          after = [
            "mnt-external.mount"
            "authelia.service"
            "caddy.service"
            "postgresql.target"
          ];
        };
        tmpfiles.rules = [
          "d /var/lib/sftpgo 0750 sftpgo sftpgo -"
          "d /var/lib/qbittorrent 0755 root root -"
          "d /var/lib/qbittorrent/watch 0755 root root -"
        ];
      };

      services = {
        postgresql = config.utils.mkPostgres "sftpgo";
        caddy.virtualHosts =
          (config.caddy.mkVhost {
            name = "sftpgo";
            port = httpPort;
          })
          // {
            "webdav.${config.caddy.domain}" = {
              extraConfig = ''
                reverse_proxy 127.0.0.1:${toString webdavPort} {
                  header_up Host {host}
                }
              '';
            };
          };
        sftpgo = {
          enable = true;
          dataDir = "/var/lib/sftpgo";
          extraReadWriteDirs = [
            "/mnt/external"
            "/var/lib/syncthing"
            "/var/lib/qbittorrent/watch"
          ];
          settings = {
            data_provider = {
              driver = "postgresql";
              name = "sftpgo";
              host = "/run/postgresql";
              port = 5432;
              username = "sftpgo";
            };
            sftpd = {
              bindings = [
                {
                  port = sftpPort;
                  address = "";
                }
              ];
              host_keys = [
                "/var/lib/sftpgo/id_ecdsa"
                "/var/lib/sftpgo/id_ed25519"
                "/var/lib/sftpgo/id_rsa"
              ];
            };
            webdavd.bindings = [
              {
                port = webdavPort;
                address = "127.0.0.1";
              }
            ];
            httpd.bindings = [
              {
                port = httpPort;
                address = "127.0.0.1";
                enable_web_admin = true;
                enable_web_client = true;
                oidc = {
                  client_id = "sftpgo";
                  config_url = "https://auth.${config.caddy.domain}";
                  redirect_base_url = "https://sftpgo.${config.caddy.domain}";
                  username_field = "preferred_username";
                  implicit_roles = true;
                  scopes = [
                    "openid"
                    "profile"
                    "email"
                  ];
                };
              }
            ];
          };
        };
      };
    };
}
