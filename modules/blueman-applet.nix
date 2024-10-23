{
  lib,
  config,
  pkgs,
  ...
}: {
  options.blueman-applet.enable = lib.mkEnableOption "enable blueman-applet";
  config = lib.mkIf config.blueman-applet.enable {
    systemd.user.services.blueman-applet = {
      Unit = {
        Description = "Blueman applet";
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.blueman}/bin/blueman-applet";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = ["hyprland-session.target"];
      };
    };
  };
}
