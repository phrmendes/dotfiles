{
  lib,
  pkgs,
  ...
}: {
  services.swayidle = {
    enable = true;
    systemdTarget = "hyprland-session.target";
    events = [
      {
        event = "before-sleep";
        command = "${lib.getExe pkgs.swaylock} -f";
      }
      {
        event = "lock";
        command = "${lib.getExe pkgs.swaylock} -f";
      }
      {
        event = "after-resume";
        command = "hyprctl dispatch dpms on";
      }
    ];
    timeouts = [
      {
        command = "${lib.getExe pkgs.swaylock} -f";
        timeout = 60;
      }
      {
        command = "hyprctl dispatch dpms off";
        resumeCommand = "hyprctl dispatch dpms on";
        timeout = 90;
      }
      {
        command = "systemctl suspend";
        timeout = 120;
      }
    ];
  };
}
