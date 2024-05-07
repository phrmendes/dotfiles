{
  lib,
  config,
  pkgs,
  ...
}: {
  options.nwg.enable = lib.mkEnableOption "enable nwg";

  config = lib.mkIf config.nwg.enable {
    home.file = let
      swaylock = lib.getExe pkgs.swaylock;
      systemctl = "${pkgs.systemd}/bin/systemctl";
    in {
      ".config/nwg-bar/style.css".source = ../dotfiles/nwg-bar/style.css;
      ".config/nwg-bar/bar.json".text = builtins.toJSON [
        {
          "label" = "Lock";
          "exec" = "${swaylock}";
          "icon" = "${pkgs.nwg-bar}/share/nwg-bar/images/system-lock-screen.svg";
        }
        {
          "label" = "Suspend";
          "exec" = "${systemctl} -i suspend";
          "icon" = "${pkgs.nwg-bar}/share/nwg-bar/images/system-suspend.svg";
        }
        {
          "label" = "Reboot";
          "exec" = "${systemctl} -i reboot";
          "icon" = "${pkgs.nwg-bar}/share/nwg-bar/images/system-reboot.svg";
        }
        {
          "label" = "Shutdown";
          "exec" = "${systemctl} -i poweroff";
          "icon" = "${pkgs.nwg-bar}/share/nwg-bar/images/system-shutdown.svg";
        }
      ];
    };
  };
}
