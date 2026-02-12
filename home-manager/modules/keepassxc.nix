{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.keepassxc.enable = lib.mkEnableOption "enable keepassxc";

  config = lib.mkIf config.keepassxc.enable {
    home.packages = with pkgs; [ keepassxc ];

    systemd.user.services.keepassxc = {
      Unit = {
        Description = "Offline password manager with many features";
        PartOf = [ "hyprland-session.target" ];
        Wants = [
          "waybar.service"
          "ssh-agent.service"
        ];
        After = [
          "hyprland-session.target"
          "waybar.service"
        ];
      };
      Service = {
        Type = "simple";
        ExecStartPre = "${pkgs.systemd}/bin/busctl --user --watch-bind=true status org.kde.StatusNotifierWatcher";
        ExecStart = "${pkgs.keepassxc}/bin/keepassxc --minimized";
        Restart = "on-failure";
        RestartSec = "5s";
        Environment = [
          "QT_QPA_PLATFORM=wayland"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION=1"
          "XDG_CURRENT_DESKTOP=Hyprland"
          "SSH_AUTH_SOCK=%t/ssh-agent"
        ];
      };
      Install.WantedBy = [ "hyprland-session.target" ];
    };
  };
}
