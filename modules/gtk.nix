{
  config,
  lib,
  pkgs,
  ...
}: {
  options.gtk-settings.enable = lib.mkEnableOption "enable gtk themes";

  config = lib.mkIf config.gtk-settings.enable {
    gtk = {
      enable = true;
      cursorTheme = {
        name = "Pop";
        package = pkgs.pop-icon-theme;
      };
      iconTheme = {
        name = "Pop";
        package = pkgs.pop-icon-theme;
      };
      font = {
        name = "Fira Sans";
        package = pkgs.fira;
        size = 11;
      };
      gtk3 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };
    };
  };
}
