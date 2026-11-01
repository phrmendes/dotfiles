{
  flake.modules.nixos.calibre =
    {
      config,
      ...
    }:
    let
      port = 8080;
      library = "/mnt/external/calibre";
      userDb = "/var/lib/calibre/users.sqlite";
    in
    {
      homepage.services.calibre = {
        siteMonitor = "https://calibre.${config.caddy.domain}/health";
        homepage = {
          name = "Calibre";
          description = "Ebook library";
          icon = "sh-calibre";
          category = "Files";
        };
      };

      users = {
        groups.calibre = { };
        users.calibre = {
          isSystemUser = true;
          group = "calibre";
          home = "/var/lib/calibre";
          createHome = true;
          extraGroups = [ "external" ];
        };
      };

      systemd = {
        tmpfiles.rules = [ "d ${library} 2775 calibre calibre -" ];
        services.caddy.serviceConfig.EnvironmentFile = [ "/var/lib/caddy/calibre-auth.env" ];
        services.calibre-server = {
          unitConfig.RequiresMountsFor = [ "/mnt/external" ];
          unitConfig.ConditionPathExists = [
            "${library}/metadata.db"
            userDb
          ];
        };
      };

      services = {
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "calibre";
          inherit port;
          auth = true;
          headers.Authorization = "Basic {env.CALIBRE_AUTH}";
          extraConfig = ''
            @opds-trusted {
              path /opds /opds/* /get /comic-manifest /cdb/add-book/*
              remote_ip 192.168.10.0/24 10.10.10.3/32
            }
            handle @opds-trusted {
              reverse_proxy 127.0.0.1:${toString port} {
                header_up Authorization "Basic {env.CALIBRE_AUTH}"
              }
              import security-headers
            }

            @opds-blocked path /opds /opds/* /get /comic-manifest /cdb/add-book/*
            handle @opds-blocked {
              respond "Forbidden" 403
            }

            @health path /health
            handle @health {
              rewrite * /
              reverse_proxy 127.0.0.1:${toString port}
            }
          '';
        };

        calibre-server = {
          enable = true;
          host = "127.0.0.1";
          inherit port;
          libraries = [ library ];
          user = "calibre";
          group = "calibre";
          auth = {
            enable = true;
            mode = "basic";
            inherit userDb;
          };
        };
      };
    };
}
