{
  dconf = {
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "forge@jmmaranan.com"
          "gsconnect@andyholmes.github.io"
          "user-theme@gnome-shell-extensions.gcampax.github.com"
        ];
        favourite-apps = ["Wezterm.desktop" "firefox.desktop"];
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        tap-to-click = true;
        two-finger-scrolling-enabled = true;
      };
    };
  };
}
