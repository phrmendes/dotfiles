{
  lib,
  config,
  ...
}: {
  options.dconf-settings.enable = lib.mkEnableOption "enable dconf settings";

  config = lib.mkIf config.dconf-settings.enable {
    dconf = {
      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
            "espresso@coadmunkee.github.com"
            "forge@jmmaranan.com"
            "gsconnect@andyholmes.github.io"
            "pano@elhan.io"
            "pomodoro@arun.codito.in"
          ];
          favorite-apps = [
            "org.gnome.Nautilus.desktop"
            "firefox.desktop"
            "kitty.desktop"
            "bitwarden.desktop"
            "obsidian.desktop"
          ];
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
          move-to-workspace-7 = ["<Shift><Super>7"];
          move-to-workspace-left = ["<Shift><Control><Super>h"];
          move-to-workspace-right = ["<Shift><Control><Super>l"];
          switch-to-workspace-1 = ["<Super>1"];
          switch-to-workspace-2 = ["<Super>2"];
          switch-to-workspace-3 = ["<Super>3"];
          switch-to-workspace-4 = ["<Super>4"];
          switch-to-workspace-5 = ["<Super>5"];
          switch-to-workspace-6 = ["<Super>6"];
          switch-to-workspace-7 = ["<Super>7"];
          switch-to-workspace-left = ["<Control><Super>h"];
          switch-to-workspace-right = ["<Control><Super>l"];
        };
        "org/gnome/shell/extensions/forge" = {
          move-pointer-focus-enabled = false;
          tiling-mode-enabled = true;
        };
        "org/gnome/shell/extensions/forge/keybindings" = {
          con-split-horizontal = ["<Super>minus"];
          con-split-vertical = ["<Super>\\"];
          con-split-layout-toggle = ["<Super>r"];
          con-stacked-layout-toggle = ["<Shift><Super>s"];
          con-tabbed-layout-toggle = ["<Shift><Super>t"];
          con-tabbed-showtab-decoration-toggle = ["<Control><Alt>y"];
          focus-border-toggle = ["<Super>x"];
          mod-mask-mouse-tile = "Super";
          prefs-tiling-toggle = ["<Super>w"];
          window-focus-down = ["<Super>j"];
          window-focus-left = ["<Super>h"];
          window-focus-right = ["<Super>l"];
          window-focus-up = ["<Super>k"];
          window-gap-size-decrease = ["<Control><Super>minus"];
          window-gap-size-increase = ["<Control><Super>plus"];
          window-move-down = ["<Shift><Super>j"];
          window-move-left = ["<Shift><Super>h"];
          window-move-right = ["<Shift><Super>l"];
          window-move-up = ["<Shift><Super>k"];
          window-resize-top-decrease = ["<Shift><Super>down"];
          window-resize-top-increase = ["<Shift><Super>up"];
          window-resize-bottom-decrease = ["<Control><Super>down"];
          window-resize-bottom-increase = ["<Control><Super>up"];
          window-resize-left-increase = ["<Control><Super>left"];
          window-resize-left-decrease = ["<Control><Super>right"];
          window-resize-right-increase = ["<Shift><Super>right"];
          window-resize-right-decrease = ["<Shift><Super>right"];
          window-swap-last-active = ["<Super>s"];
          window-toggle-always-float = ["<Shift><Super>f"];
          window-toggle-float = ["<Super>f"];
          workspace-active-tile-toggle = ["<Shift><Super>w"];
        };
      };
    };
  };
}
