{
  config,
  lib,
  parameters,
  pkgs,
  ...
}: {
  options.hypridle.enable = lib.mkEnableOption "enable hypridle";
  config = lib.mkIf config.hypridle.enable {
    services.hypridle = let
      swaylock = "${lib.getExe pkgs.swaylock}";
      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      systemctl = "${pkgs.systemd}/bin/systemctl";
      lock_cmd = "pidof ${swaylock} || ${swaylock} -fF";
      brightnessctl = lib.getExe pkgs.brightnessctl;
    in {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "${hyprctl} dispatch dpms on";
          ignore_dbus_inhibit = false;
          inherit lock_cmd;
        };

        listener = [
          (lib.mkIf parameters.laptop {
            timeout = 600;
            on-timeout = "${brightnessctl} set 10%";
            on-resume = "${brightnessctl} --restore ";
          })
          {
            timeout = 900;
            on-timeout = lock_cmd;
          }
          {
            timeout = 1200;
            on-timeout = "${hyprctl} dispatch dpms off";
            on-resume = "${hyprctl} dispatch dpms on";
          }
          {
            timeout = 1500;
            on-timeout = "${systemctl} suspend";
          }
        ];
      };
    };
  };
}
