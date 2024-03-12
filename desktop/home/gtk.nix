{pkgs, ...}: {
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
  };
}
