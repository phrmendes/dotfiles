{ config, ... }:
let
  settings = config.const;
in
{
  flake.modules.nixos.moonlight = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.moonlight-qt ];
  };

  flake.modules.nixos.gaming = {
    imports = [ config.flake.modules.nixos.moonlight ];

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
