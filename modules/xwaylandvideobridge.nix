{
  lib,
  config,
  pkgs,
  ...
}: {
  options.xwaylandvideobridge.enable = lib.mkEnableOption "enable xwaylandvideobridge";

  config = lib.mkIf config.xwaylandvideobridge.enable {
    systemd.user.services = {
      xwaylandvideobridge = {
        Unit = {
          Description = "Tool to make it easy to stream wayland windows and screens to existing applications running under Xwayland";
        };

        Service = {
          Type = "simple";
          ExecStart = "${pkgs.kdePackages.xwaylandvideobridge}/bin/xwaylandvideobridge";
          Restart = "on-failure";
        };

        Install = {
          WantedBy = ["hyprland-session.target"];
        };
      };
    };
  };
}
