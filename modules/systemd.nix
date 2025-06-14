{ pkgs, ... }:
{
  systemd.user.services = {
    keepassxc = {
      Unit = {
        Description = "Offline password manager with many features";
        Documentation = "https://keepassxc.org/docs/";
        PartOf = [ "hyprland-session.target" ];
        Requires = [ "tray.target" ];
        After = [
          "hyprland-session.target"
          "tray.target"
        ];
      };
      Service = {
        ExecStart = "${pkgs.keepassxc}/bin/keepassxc --minimized";
        Restart = "on-failure";
      };
      Install.WantedBy = [
        "hyprland-session.target"
        "tray.target"
      ];
    };
    syncthingtray = {
      Unit = {
        Description = "Tray application and Dolphin/Plasma integration for Syncthing";
        Documentation = "https://martchus.github.io/syncthingtray/#doc-section";
        PartOf = [ "hyprland-session.target" ];
        Requires = [ "tray.target" ];
        After = [
          "hyprland-session.target"
          "tray.target"
        ];
      };
      Service = {
        ExecStart = "${pkgs.syncthingtray}/bin/syncthingtray --wait";
        Restart = "on-failure";
      };
      Install.WantedBy = [
        "hyprland-session.target"
        "tray.target"
      ];
    };
  };
}
