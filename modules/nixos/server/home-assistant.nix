{
  flake.modules.nixos.homeAssistant =
    { config, ... }:
    let
      port = 8123;
    in
    {
      homepage.services.home-assistant = {
        homepage = {
          name = "Home Assistant";
          description = "Home automation";
          category = "Services";
        };
      };

      services = {
        restic.backups."home-assistant" = config.restic.mkBackup "home-assistant" {
          paths = [ "/var/lib/home-assistant" ];
          sqlite."/var/lib/home-assistant/home-assistant_v2.db" = "home-assistant.db";
        };
        caddy.virtualHosts = config.caddy.mkVhost {
          name = "home-assistant";
          inherit port;
        };
        home-assistant = {
          enable = true;
          configDir = "/var/lib/home-assistant";
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
        "d /var/lib/home-assistant 0750 hass hass -"
      ];
    };
}
