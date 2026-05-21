_: {
  modules.nixos.server.sftpgo =
    { config, ... }:
    let
      sftpPort = 2022;
      httpPort = 8095;
      webdavPort = 10080;
    in
    {
      server.homepage.services.sftpgo = {
        dataDir = "/srv/sftpgo";
        url = "sftpgo.${config.server.caddy.domain}";
        monitoredServices = [ "sftpgo" ];
        homepage = {
          name = "SFTPGo";
          description = "File transfer server";
          icon = "sh-sftpgo";
          category = "Downloads";
        };
      };

      services.caddy.virtualHosts = (config.server.caddy.mkVhost "sftpgo" httpPort) // {
        "webdav.${config.server.caddy.domain}" = {
          useACMEHost = config.server.caddy.domain;
          extraConfig = ''
            reverse_proxy 127.0.0.1:${toString webdavPort} {
              header_up Host {host}
            }
          '';
        };
      };

      networking.firewall.allowedTCPPorts = [ sftpPort ];

      systemd.tmpfiles.rules = [ "d /srv/sftpgo 0750 sftpgo sftpgo -" ];

      users.users.sftpgo.extraGroups = [ "media" ];

      services.sftpgo = {
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
            }
          ];
        };
      };
    };
}
