{
  config,
  lib,
  pkgs,
  ...
}: {
  options.hypridle.enable = lib.mkEnableOption "enable hypridle";

  config = lib.mkIf config.hypridle.enable {
    services.hypridle = {
      enable = true;
      settings = let
        lock = "${pkgs.procps}/bin/pidof swaylock || ${lib.getExe pkgs.swaylock}";
        screen_off = "hyprctl dispatch dpms off";
        screen_on = "hyprctl dispatch dpms on";
      in {
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
