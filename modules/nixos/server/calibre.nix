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
        services.calibre-server = {
          unitConfig.RequiresMountsFor = [ "/mnt/external" ];
          unitConfig.ConditionPathExists = [ userDb ];
        };
      };

      services = {
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "calibre";
          inherit port;
          auth = true;
          extraConfig = ''
            @opds path /opds /opds/* /get /comic-manifest
            handle @opds {
              reverse_proxy 127.0.0.1:${toString port}
              import security-headers
            }

            @health path /health
            handle @health {
              reverse_proxy 127.0.0.1:${toString port} {
                @unauthorized status 401
                handle_response @unauthorized {
                  respond "OK" 200
                }
              }
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
