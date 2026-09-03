{
  nixosModules.sftpgo =
    { config, ... }:
    let
      sftpPort = 2022;
      httpPort = 8095;
      webdavPort = 10080;
    in
    {
      homepage.services.sftpgo = {
        dataDir = "/srv/sftpgo";
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
          serviceConfig.EnvironmentFile = config.age.secrets."sftpgo.env".path;
          requires = [
            "authelia.service"
            "caddy.service"
          ];
          after = [
            "mnt-external.mount"
            "authelia.service"
            "caddy.service"
          ];
        };
        tmpfiles.rules = [
          "d /srv/sftpgo 0750 sftpgo sftpgo -"
          "d /srv/qbittorrent 0755 root root -"
          "d /srv/qbittorrent/watch 0755 root root -"
        ];
      };

      services = {
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
          dataDir = "/srv/sftpgo";
          extraReadWriteDirs = [
            "/mnt/external"
            "/srv/syncthing"
            "/srv/qbittorrent/watch"
          ];
          settings = {
            sftpd = {
              bindings = [
                {
                  port = sftpPort;
                  address = "";
                }
              ];
              host_keys = [
                "/srv/sftpgo/id_ecdsa"
                "/srv/sftpgo/id_ed25519"
                "/srv/sftpgo/id_rsa"
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
