{
  lib,
  config,
  pkgs,
  ...
}: {
  options.swayidle.enable = lib.mkEnableOption "enable swayidle";

  config = lib.mkIf config.swayidle.enable {
    services.swayidle = let
      swaylock = "${lib.getExe pkgs.swaylock}";
      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
    in {
      enable = true;
      events = [
        {
          event = "after-resume";
          command = "${hyprctl} dispatch dpms on";
        }
      ];
      timeouts = [
        {
          timeout = 300;
          command = "${hyprctl} dispatch dpms off";
          resumeCommand = "${hyprctl} dispatch dpms on";
        }
        {
          timeout = 360;
          command = "${swaylock}";
        }
      ];
    };
  };
}
