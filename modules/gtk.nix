{
  config,
  lib,
  pkgs,
  ...
}: {
  options.gtk-manager.enable = lib.mkEnableOption "enable gtk manager";

  config = lib.mkIf config.gtk-manager.enable {
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
      theme = {
        name = "Catppuccin-Mocha-Standard-Blue-Dark";
        package = pkgs.catppuccin-gtk.override {
          accents = ["blue"];
          size = "standard";
          tweaks = ["rimless"];
          variant = "mocha";
        };
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
