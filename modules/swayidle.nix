{
  config,
  lib,
  pkgs,
  ...
}: {
  options.swayidle.enable = lib.mkEnableOption "enable swayidle";

  config = lib.mkIf config.swayidle.enable {
    services.swayidle = let
      inherit (lib) getExe;
      swaylock = getExe pkgs.swaylock;
      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      systemctl = "${pkgs.systemd}/bin/systemctl";
    in {
      enable = true;
      systemdTarget = "hyprland-session.target";
      events = [
        {
          event = "before-sleep";
          command = "${swaylock}";
        }
        {
          event = "lock";
          command = "${swaylock}";
        }
      ];
      timeouts = [
        {
          command = "${swaylock}";
          timeout = 90;
        }
        {
          command = "${hyprctl} dispatch dpms off";
          resumeCommand = "${hyprctl} dispatch dpms on";
          timeout = 120;
        }
        {
          command = "${systemctl} suspend";
          timeout = 180;
        }
      ];
    };
  };
}
