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
      settings = let
        lock = "${pkgs.procps}/bin/pidof swaylock || ${swaylock}";
        screen_off = "hyprctl dispatch dpms off";
        screen_on = "hyprctl dispatch dpms on";
      in {
        general = {
          lock_cmd = lock;
          before_sleep_cmd = screen_off;
          after_resume_cmd = screen_on;
        };

        listener = [
          {
            timeout = 600;
            on-timeout = lock;
          }
          {
            timeout = 660;
            on-timeout = screen_off;
            on-resume = screen_on;
          }
        ];
      };
    };
  };
}
