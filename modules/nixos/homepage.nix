{
  nixosModules.homepage =
    { lib, config, ... }:
    let
      port = 8082;

      homepageService = { name, ... }: {
        options = {
          dataDir = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
          };
          url = lib.mkOption {
            type = lib.types.str;
          };
          homepage = lib.mkOption {
            type = lib.types.submodule {
              options = {
                enable = lib.mkOption {
                  type = lib.types.bool;
                  default = true;
                };
                name = lib.mkOption {
                  type = lib.types.str;
                  default = name;
                };
                description = lib.mkOption {
                  type = lib.types.str;
                  default = "";
                };
                icon = lib.mkOption {
                  type = lib.types.str;
                  default = "${name}.svg";
                };
                category = lib.mkOption {
                  type = lib.types.str;
                  default = "Services";
                };
                widget = lib.mkOption {
                  type = lib.types.nullOr lib.types.attrs;
                  default = null;
                };
              };
            };
            default = { };
          };
        };
      };

      categories = [
        "Media"
        "Files"
        "Services"
        "Monitoring"
      ];

      servicesForCategory =
        cat:
        config.homepage.services
        |> lib.filterAttrs (_: v: v.homepage.enable && v.homepage.category == cat)
        |> lib.mapAttrsToList (
          _: v: {
            "${v.homepage.name}" = {
              href = "https://${v.url}";
              icon = v.homepage.icon;
              description = v.homepage.description;
              siteMonitor = "https://${v.url}";
            }
            // (lib.optionalAttrs (v.homepage.widget != null) { widget = v.homepage.widget; });
          }
        );
    in
    {
      options.homepage.services = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule homepageService);
        default = { };
      };

      config = {
        systemd.services.homepage-dashboard.environment.HOMEPAGE_ALLOWED_HOSTS =
          lib.mkForce "homepage.${config.caddy.domain},localhost:${toString port},127.0.0.1:${toString port}";

        services = {
          caddy.virtualHosts = config.caddy.mkVhost {
            name = "homepage";
            inherit port;
          };
          homepage-dashboard = {
            enable = true;
            listenPort = port;
            widgets = [
              {
                datetime = {
                  text_size = "xl";
                  format = {
                    timeStyle = "short";
                    hourCycle = "h23";
                  };
                };
              }
              {
                openmeteo = {
                  label = "São Paulo";
                  latitude = -23.5505;
                  longitude = -46.6333;
                  timezone = "America/Sao_Paulo";
                  units = "metric";
                  cache = 5;
                };
              }
            ];
            settings = {
              headerStyle = "clean";

              statusStyle = "dot";
              hideVersion = true;
              layout = map (cat: {
                "${cat}" = {
                  style = "row";
                  columns = 3;
                  header = true;
                };
              }) categories;
            };
            services = map (cat: { "${cat}" = servicesForCategory cat; }) categories;
          };
        };
      };
    };
}
