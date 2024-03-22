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
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
      }
    ];
    timeouts = [
      {
        command = "${lib.getExe pkgs.swaylock} -f";
        timeout = 60;
      }
      {
        command = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
        resumeCommand = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        timeout = 90;
      }
      {
        command = "${pkgs.systemd}/bin/systemctl suspend";
        timeout = 120;
      }
    ];
  };
}
