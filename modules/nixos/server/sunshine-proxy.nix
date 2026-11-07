{ config, ... }:
let
  settings = config.const;
  port = settings.sunshinePort;
in
{
  flake.modules.nixos.sunshineProxy =
    { config, ... }:
    {
      homepage.services.sunshine = {
        homepage = {
          name = "Sunshine";
          description = "Game stream host";
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
