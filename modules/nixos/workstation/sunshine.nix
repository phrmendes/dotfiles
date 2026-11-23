{ config, ... }:
let
  settings = config.const;
in
{
  flake.modules.nixos.sunshine = {
    services.sunshine = {
      enable = true;
      openFirewall = true;
      settings.port = settings.sunshinePort;
    };

    systemd.user.services.sunshine.environment.LD_LIBRARY_PATH = "/run/opengl-driver/lib";
  };
}
