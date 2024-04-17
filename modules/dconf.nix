{
  lib,
  config,
  ...
}: {
  options.dconf-settings.enable = lib.mkEnableOption "enable dconf settings";

  config = lib.mkIf config.dconf-settings.enable {
    dconf = let
      colors = import ./catppuccin.nix;
    in {
      settings = with colors.catppuccin.hex; {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
            "espresso@coadmunkee.github.com"
            "gsconnect@andyholmes.github.io"
            "pop-shell@system76.com"
          ];
          favorite-apps = [
            "org.gnome.Nautilus.desktop"
            "firefox.desktop"
            "kitty.desktop"
            "bitwarden.desktop"
            "obsidian.desktop"
          ];
        };
        "org/gnome/shell/extensions/pop-shell" = {
          active-hint = true;
          active-hint-border-radius = 10;
          gap-inner = 2;
          gap-outer = 2;
          hint-color-rgba = blue;
          show-skip-taskbar = true;
          smart-gaps = false;
          snap-to-grid = true;
          tile-by-default = true;
          toggle-stacking-global = [];
        };
      };
    };
  };
}
