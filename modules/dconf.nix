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
        "org/gnome/shell/keybindings" = {
          toggle-message-tray = ["<Super>n"];
        };
        "org/gnome/desktop/wm/keybindings" = {
          close = ["<Super>q"];
          toggle-maximized = ["<Super>z"];
          toggle-fullscreen = ["<Super>g"];
          switch-input-source = ["<Alt>space"];
          switch-input-source-backward = ["<Shift><Alt>space"];
          move-to-workspace-1 = ["<Shift><Super>1"];
          move-to-workspace-2 = ["<Shift><Super>2"];
          move-to-workspace-3 = ["<Shift><Super>3"];
          move-to-workspace-4 = ["<Shift><Super>4"];
          move-to-workspace-5 = ["<Shift><Super>5"];
          move-to-workspace-6 = ["<Shift><Super>6"];
          move-to-workspace-left = ["<Shift><Control><Super>h"];
          move-to-workspace-right = ["<Shift><Control><Super>l"];
          switch-to-workspace-1 = ["<Super>1"];
          switch-to-workspace-2 = ["<Super>2"];
          switch-to-workspace-3 = ["<Super>3"];
          switch-to-workspace-4 = ["<Super>4"];
          switch-to-workspace-5 = ["<Super>5"];
          switch-to-workspace-6 = ["<Super>6"];
          switch-to-workspace-left = ["<Control><Super>h"];
          switch-to-workspace-right = ["<Control><Super>l"];
        };
      };
    };
  };
}
