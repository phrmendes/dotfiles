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
      hyprlock = lib.getExe pkgs.hyprlock;
      brightnessctl = lib.getExe pkgs.brightnessctl;
      loginctl = "${pkgs.systemd}/bin/loginctl";
      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      systemctl = "${pkgs.systemd}/bin/systemctl";
      lock_cmd = "pidof ${hyprlock} || ${hyprlock} -fF";
    in {
      enable = true;
      settings = {
        general = {
          before_sleep_cmd = "${loginctl} lock-session";
          after_sleep_cmd = "${hyprctl} dispatch dpms on";
          ignore_dbus_inhibit = false;
          inherit lock_cmd;
        };

        listener = [
          (lib.mkIf parameters.laptop {
            timeout = 150;
            on-timeout = "${brightnessctl} set 10%";
            on-resume = "${brightnessctl} --restore ";
          })
          {
            timeout = 300;
            on-timeout = "${loginctl} lock-session";
          }
          {
            timeout = 330;
            on-timeout = "${hyprctl} dispatch dpms off";
            on-resume = "${hyprctl} dispatch dpms on";
          }
          {
            timeout = 600;
            on-timeout = "${systemctl} suspend";
          }
        ];
      };
    };
  };
}
