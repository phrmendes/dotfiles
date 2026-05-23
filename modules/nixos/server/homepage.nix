_: {
  modules.nixos.server.homepage =
    { lib, config, ... }:
    let
      port = 8082;

      categories = [
        "Media"
        "Files"
        "Services"
        "Monitoring"
      ];

      servicesForCategory =
        cat:
        config.server.homepage.services
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
      services.caddy.virtualHosts = config.server.caddy.mkVhost "homepage" port;

      systemd.services.homepage-dashboard.environment.HOMEPAGE_ALLOWED_HOSTS =
        lib.mkForce "homepage.${config.server.caddy.domain},localhost:${toString port},127.0.0.1:${toString port}";

      services.homepage-dashboard = {
        enable = true;
        listenPort = port;
        widgets = [
          {
            search = {
              provider = "duckduckgo";
              focus = true;
              showSearchSuggestions = true;
              target = "_blank";
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

          statusStyle = "dot";
          hideVersion = true;
          layout = map (cat: {
            "${cat}" = {
              style = "column";
              header = true;
            };
          }) categories;
        };
        services = map (cat: { "${cat}" = servicesForCategory cat; }) categories;
      };
    };
}
