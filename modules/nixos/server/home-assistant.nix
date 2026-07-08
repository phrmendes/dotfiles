_: {
  modules.nixos.server.home-assistant =
    { config, ... }:
    let
      port = 8123;
    in
    {
      server.homepage.services.home-assistant = {
        url = "home-assistant.${config.server.caddy.domain}";
        monitoredServices = [ "home-assistant" ];
        homepage = {
          name = "Home Assistant";
          description = "Home automation";
          icon = "sh-home-assistant";
          category = "Services";
        };
      };

      services.caddy.virtualHosts = config.server.caddy.mkVhost "home-assistant" port;

      services.home-assistant = {
        enable = true;
        openFirewall = true;
        configDir = "/srv/home-assistant";
        extraComponents = [
          "default_config"
          "met"
          "mobile_app"
          "tuya"
        ];
        config = {
          homeassistant = {
            name = "Home";
            latitude = -23.5505;
            longitude = -46.6333;
            unit_system = "metric";
            time_zone = "America/Sao_Paulo";
          };
          http = {
            use_x_forwarded_for = true;
            trusted_proxies = [ "127.0.0.1" ];
          };
        };
      };

      systemd.tmpfiles.rules = [
        "d /srv/home-assistant 0750 hass hass -"
      ];
    };
}
