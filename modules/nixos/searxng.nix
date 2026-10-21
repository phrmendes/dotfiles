{
  nixosModules.searxng =
    { config, ... }:
    let
      port = 8889;
    in
    {
      homepage.services.searxng = {
        url = "search.${config.caddy.domain}";
        siteMonitor = "https://search.${config.caddy.domain}/healthz";
        homepage = {
          name = "SearXNG";
          description = "Private metasearch engine";
          icon = "searxng.png";
          category = "Services";
        };
      };

      services.caddy.virtualHosts = config.caddy.mkVhost {
        name = "search";
        inherit port;
      };

      services.searx = {
        enable = true;
        redisCreateLocally = true;
        environmentFile = config.age.secrets."searxng.env".path;

        settings = {
          general = {
            instance_name = "SearXNG";
            enable_metrics = false;
          };

          server = {
            base_url = "https://search.${config.caddy.domain}/";
            secret_key = "$SEARX_SECRET_KEY";
            bind_address = "127.0.0.1";
            inherit port;
            limiter = true;
            image_proxy = true;
          };

          ui.simple_style = "dark";

          search = {
            safe_search = 0;
            autocomplete = "google";
            default_lang = "en";
          };

          engines = [
            {
              name = "google cse";
              weight = 2.0;
            }
            {
              name = "startpage";
              disabled = false;
              weight = 1.8;
            }
            {
              name = "google";
              disabled = false;
              weight = 1.5;
            }
            {
              name = "google news";
              weight = 1.5;
            }
            {
              name = "google videos";
              weight = 1.5;
            }
            {
              name = "google scholar";
              weight = 1.5;
            }

            {
              name = "duckduckgo";
              weight = 0.4;
            }
            {
              name = "brave";
              weight = 0.4;
            }
            {
              name = "mojeek";
              weight = 0.2;
            }
            {
              name = "wikipedia";
              weight = 0.4;
            }
          ];

          ui.default_locale = "en";
        };

        limiterSettings.botdetection.trusted_proxies = [
          "127.0.0.0/8"
          "::1"
        ];
      };
    };
}
