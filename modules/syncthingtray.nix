{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.syncthingtray.enable = lib.mkEnableOption "enable syncthingtray";

  config = lib.mkIf config.syncthingtray.enable {
    home.packages = with pkgs; [ syncthingtray ];

    systemd.user.services.syncthingtray = {
      Unit = {
        Description = "Tray application and Dolphin/Plasma integration for Syncthing";
        PartOf = [ "hyprland-session.target" ];
        Wants = [ "waybar.service" ];
        After = [
          "hyprland-session.target"
          "waybar.service"
        ];
      };
      Service = {
        ExecStart = "${pkgs.syncthingtray}/bin/syncthingtray --wait";
        Restart = "always";
      };
      Install.WantedBy = [
        "hyprland-session.target"
        "waybar.service"
      ];
    };
  };
}
