{
  dconf = {
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "espresso@coadmunkee.github.com"
          "gsconnect@andyholmes.github.io"
          "pop-shell@system76.com"
        ];
        favorite-apps = [
          "bitwarden.desktop"
          "firefox.desktop"
          "kitty.desktop"
          "org.gnome.Nautilus.desktop"
        ];
      };
      "org/gnome/shell/extensions/pop-shell" = {
        active-hint = true;
        active-hint-border-radius = 10;
        gap-inner = 2;
        gap-outer = 2;
        hint-color-rgba = "rgb(137, 180, 250)";
        show-skip-taskbar = true;
        smart-gaps = false;
        snap-to-grid = true;
        tile-by-default = true;
        toggle-stacking-global = [];
      };
    };
  };
}
