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
        ExecStart = "${pkgs.keepassxc}/bin/keepassxc --minimized";
        Restart = "always";
      };
      Install.WantedBy = [ "hyprland-session.target" ];
    };
  };
}
