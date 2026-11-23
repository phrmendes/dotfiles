{ config, ... }:
let
  settings = config.const;
in
{
  flake.modules.nixos.gaming = {
    environment.persistence."/persist".users.${settings.user}.directories = [
      ".local/share/Steam"
      ".steam"
    ];

    hardware.xpadneo.enable = true;

    programs = {
      steam.enable = true;

      gamemode = {
        enable = true;
        settings = {
          general = {
            renice = 10;
            ioprio = 0;
          };
        };
      };
    };
  };
}
