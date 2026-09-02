{
  nixosModules.homeAssistant =
    { config, ... }:
    let
      port = 8123;
    in
    {
      homepage.services.home-assistant = {
        url = "home-assistant.${config.caddy.domain}";
        homepage = {
          name = "Home Assistant";
          description = "Home automation";
          icon = "sh-home-assistant";
          category = "Services";
        };
      };

      services = {
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "home-assistant";
          inherit port;
        };
        home-assistant = {
          enable = true;
          configDir = "/srv/home-assistant";
          extraComponents = [
            "mobile_app"
            "sun"
            "tuya"
            "zeroconf"
          ];
          config = {
            mobile_app = { };
            homeassistant = {
              name = "Home";
              latitude = -23.5505;
              longitude = -46.6333;
              unit_system = "metric";
              time_zone = "America/Sao_Paulo";
            };
            http = {
              server_port = port;
              use_x_forwarded_for = true;
              trusted_proxies = [ "127.0.0.1" ];
            };
          };
        };
      };

      systemd.tmpfiles.rules = [
        "d /srv/home-assistant 0750 hass hass -"
      ];
    };
}
