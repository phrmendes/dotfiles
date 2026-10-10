{
  nixosModules.homepage =
    { lib, config, ... }:
    let
      port = 8082;

      colors = config.lib.stylix.colors;
      rgb = base: "${colors.${base + "-rgb-r"}} ${colors.${base + "-rgb-g"}} ${colors.${base + "-rgb-b"}}";

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
            customCSS = ''
              :root {
                --color-50: ${rgb "base07"};
                --color-100: ${rgb "base06"};
                --color-200: ${rgb "base05"};
                --color-300: ${rgb "base04"};
                --color-400: ${rgb "base03"};
                --color-500: ${rgb "base0A"};
                --color-600: ${rgb "base02"};
                --color-700: ${rgb "base01"};
                --color-800: ${rgb "base00"};
                --color-900: ${rgb "base01"};
                --color-logo-start: ${rgb "base0A"};
                --color-logo-stop: ${rgb "base09"};
              }
            '';
            widgets = [
              {
                search = {
                  provider = "custom";
                  url = "https://search.${config.caddy.domain}/search?q=";
                  target = "_blank";
                  focus = true;
                };
              }
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
              theme = "dark";
              color = "slate";

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
