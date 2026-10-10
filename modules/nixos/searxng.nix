{
  nixosModules.searxng =
    { config, ... }:
    let
      port = 8888;
    in
    {
      homepage.services.searxng = {
        url = "search.${config.caddy.domain}";
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

          search = {
            safe_search = 1;
            autocomplete = "duckduckgo";
            default_lang = "auto";
          };

          ui.default_locale = "en";
        };

        limiterSettings.botdetection.trusted_proxies = [
          "127.0.0.0/8"
          "::1"
        ];
      };
    };
}
