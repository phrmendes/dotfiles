{ config, ... }:
let
  inherit (config) settings;
in
{
  flake.modules.nixos.calibre =
    { config, ... }:
    let
      port = 8080;
      root = "/mnt/external/calibre";
      library = "${root}/library";
      userDb = "/var/lib/calibre/users.sqlite";
      authFile = "/var/lib/caddy/calibre-auth.env";
    in
    {
      homepage.services.calibre = {
        siteMonitor = "https://calibre.${config.caddy.domain}/health";
        homepage = {
          name = "Calibre";
          description = "Ebook library";
          icon = "sh-calibre";
          category = "Media";
        };
      };

      systemd = {
        tmpfiles.rules = [
          "d ${root} 2775 ${settings.user} external -"
          "d ${library} 2775 ${settings.user} external -"
        ];

        services = {
          caddy.serviceConfig.EnvironmentFile = [ authFile ];

          calibre-server = {
            unitConfig.RequiresMountsFor = [ "/mnt/external" ];
            unitConfig.ConditionPathExists = [
              "${library}/metadata.db"
              userDb
            ];
          };
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
              path /opds /opds/* /get /get/* /comic-manifest /cdb/add-book/*
              remote_ip 192.168.10.0/24 10.10.10.3/32
            }
            handle @opds-trusted {
              reverse_proxy 127.0.0.1:${toString port} {
                header_up Authorization "Basic {env.CALIBRE_AUTH}"
              }
              import security-headers
            }

            @opds-blocked path /opds /opds/* /get /get/* /comic-manifest /cdb/add-book/*
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
          user = settings.user;
          group = "users";
          auth = {
            enable = true;
            mode = "basic";
            inherit userDb;
          };
        };
      };
    };
}
