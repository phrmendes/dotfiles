{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isDarwin isLinux;
in {
  options.symlinks.enable = lib.mkEnableOption "enable symlinks";

  config = lib.mkIf config.symlinks.enable {
    home.file = let
      swaylock = lib.getExe pkgs.swaylock;
      systemctl = "${pkgs.systemd}/bin/systemctl";
      common = {
        ".config/yazi/theme.toml".source = ../dotfiles/yazi/theme.toml;
        ".config/nvim" = {
          source = ../dotfiles/nvim;
          recursive = true;
        };
      };
      darwin = {
        ".amethyst.yml".source = ../dotfiles/amethyst.yml;
      };
      desktop = {
        ".face".source = ../dotfiles/avatar.png;
        ".wallpaper".source = ../dotfiles/wallpaper.png;
        ".config/nwg-panel/style.css".source = ../dotfiles/nwg-panel/style.css;
        ".config/nwg-bar/style.css".source = ../dotfiles/nwg-bar/style.css;
        ".config/nwg-panel/config".source = ../dotfiles/nwg-panel/config.json;
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
    in
      if isDarwin
      then common // darwin
      else common // desktop;
  };
}
