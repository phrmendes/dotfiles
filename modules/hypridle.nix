{
  config,
  lib,
  pkgs,
  ...
}: {
  options.hypridle.enable = lib.mkEnableOption "enable hypridle";

  config = lib.mkIf config.hypridle.enable {
    services.hypridle = let
      swaylock = "${lib.getExe pkgs.swaylock}";
    in {
      enable = true;

      settings = {
        general = {
          lock_cmd = "${pkgs.procps}/bin/pidof swaylock || ${swaylock}";
          before_sleep_cmd = "loginctl lock-session";
          after_resume_cmd = "hyperctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 600;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 660;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
