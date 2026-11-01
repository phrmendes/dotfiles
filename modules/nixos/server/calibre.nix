{
  flake.modules.nixos.calibre =
    {
      config,
      ...
    }:
    let
      port = 8080;
      library = "/mnt/external/calibre";
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
          unitConfig.ConditionPathExists = [ "${library}/metadata.db" ];
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
              import authelia-auth
              reverse_proxy 127.0.0.1:${toString port}
              import security-headers
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
        };
      };
    };
}
