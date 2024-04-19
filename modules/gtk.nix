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
      theme = {
        name = "Catppuccin-Mocha-Standard-Blue-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = ["blue"];
          size = "standard";
          tweaks = ["normal"];
          variant = "mocha";
        };
      };
      gtk3 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };
      gtk4 = {
        extraConfig = {
          gtk-application-prefer-dark-theme = true;
        };
      };
    };

    xdg.configFile = {
      "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
      "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
      "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
    };
  };
}
