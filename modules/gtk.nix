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
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.gnome.adwaita-icon-theme;
      };
      font = {
        name = "Cantarell Regular";
        package = pkgs.cantarell-fonts;
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
