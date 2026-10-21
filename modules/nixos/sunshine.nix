{ config, ... }:
let
  inherit (config) settings;
  port = 47990;
in
{
  flake.modules.nixos.sunshine =
    { lib, ... }:
    {
      services.sunshine = {
        enable = true;
        capSysAdmin = true;
        openFirewall = true;
      };

      systemd.user.services.sunshine.serviceConfig = {
        Restart = lib.mkForce "always";
        RestartSec = "5s";
      };
    };

  flake.modules.nixos.sunshineProxy =
    { config, ... }:
    {
      homepage.services.sunshine = {
        url = "sunshine.${config.caddy.domain}";
        homepage = {
          name = "Sunshine";
          description = "Game stream host";
          icon = "sh-sunshine";
          category = "Services";
        };
      };

      services.caddy.virtualHosts = config.caddy.mkVhost {
        name = "sunshine";
        inherit port;
        auth = true;
        upstream = "https://${settings.lan.desktopAddress}:${toString port}";
        insecure = true;
      };
    };
}
