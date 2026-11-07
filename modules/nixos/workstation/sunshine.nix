{ config, ... }:
let
  settings = config.const;
in
{
  flake.modules.nixos.sunshine = {
    services.sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
      openFirewall = true;
      settings.port = settings.sunshinePort;
    };
  };
}
