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
        configDir = "/srv/home-assistant";
        extraComponents = [
          "default_config"
          "met"
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
          http = { };
        };
      };

      systemd.tmpfiles.rules = [
        "d /srv/home-assistant 0750 hass hass -"
      ];
    };
}
