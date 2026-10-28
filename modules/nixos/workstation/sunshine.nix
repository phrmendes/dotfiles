{ config, ... }:
let
  inherit (config) settings;
  port = 47990;
in
{
  flake.modules.nixos.sunshine = {
    services.sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
      openFirewall = true;
    };
  };

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
