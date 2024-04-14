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
      rg = getExe pkgs.ripgrep;
      hyprctl = "${pkgs.hyprland}/bin/hyprctl";
      systemctl = "${pkgs.systemd}/bin/systemctl";
      pw-cli = "${pkgs.pipewire}/bin/pw-cli";
      suspendScript = pkgs.writeShellScript "suspend" ''
        # only suspend if audio isn't running
        ${pw-cli} i all | ${rg} running

        if [ $? == 1 ]; then
          ${systemctl} suspend
        fi
      '';
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
          timeout = 300;
        }
        {
          command = "${hyprctl} dispatch dpms off";
          resumeCommand = "${hyprctl} dispatch dpms on";
          timeout = 330;
        }
        {
          command = "${suspendScript}/bin/suspend";
          timeout = 400;
        }
      ];
    };
  };
}
