{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.hypridle.enable = lib.mkEnableOption "enable hypridle";
  config = lib.mkIf config.hypridle.enable {
    services.hypridle =
      let
        hyprlock = lib.getExe pkgs.hyprlock;
        hyprctl = "${pkgs.hyprland}/bin/hyprctl";
        lock_cmd = "pidof ${hyprlock} || ${hyprlock}";
      in
      {
        enable = true;
        settings = {
          general = {
            before_sleep_cmd = lock_cmd;
            after_sleep_cmd = "${hyprctl} dispatch dpms on";
            ignore_dbus_inhibit = false;
            inherit lock_cmd;
          };

          listener = [
            {
              timeout = 300;
              on-timeout = "${lock_cmd}";
            }
            {
              timeout = 330;
              on-timeout = "${hyprctl} dispatch dpms off";
              on-resume = "${hyprctl} dispatch dpms on";
            }
          ];
        };
      };
  };
}
