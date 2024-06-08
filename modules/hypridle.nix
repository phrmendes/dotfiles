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
        lockCmd = "${pkgs.procps}/bin/pidof swaylock || ${swaylock}";

        listener = [
          {
            timeout = 300;
            onTimeout = "loginctl lock-session";
          }
          {
            timeout = 330;
            onTimeout = "hyprctl dispatch dpms off";
            onResume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
