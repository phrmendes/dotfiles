{
  config,
  lib,
  ...
}: {
  options.dconf-settings.enable = lib.mkEnableOption "enable dconf settings";

  config = lib.mkIf config.dconf-settings.enable {
    dconf = {
      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          favorite-apps = [
            "org.gnome.Nautilus.desktop"
            "firefox.desktop"
            "kitty.desktop"
            "bitwarden.desktop"
            "obsidian.desktop"
          ];
          enabled-extensions = [
            "AlphabeticalAppGrid@stuarthayhurst"
            "appindicatorsupport@rgcjonas.gmail.com"
            "espresso@coadmunkee.github.com"
            "gsconnect@andyholmes.github.io"
            "just-perfection-desktop@just-perfection"
            "pop-shell@system76.com"
            "user-theme@gnome-shell-extensions.gcampax.github.com"
          ];
        };
        "org/gnome/mutter" = {
          dynamic-workspaces = false;
          edge-tiling = true;
          num-workspaces = 7;
          workspaces-only-on-primary = true;
        };
        "org/gnome/shell/keybindings" = {
          switch-to-application-1 = [];
          switch-to-application-2 = [];
          switch-to-application-3 = [];
          switch-to-application-4 = [];
          switch-to-application-5 = [];
          switch-to-application-6 = [];
          switch-to-application-7 = [];
          toggle-message-tray = ["<Super>n"];
        };
        "org/gnome/desktop/wm/keybindings" = {
          activate-window-menu = [];
          begin-move = [];
          begin-resize = [];
          close = ["<Super>q"];
          cycle-group = [];
          cycle-group-backward = [];
          cycle-panels = [];
          cycle-panels-backward = [];
          cycle-windows = [];
          cycle-windows-backward = [];
          minimize = [];
          move-to-monitor-down = [];
          move-to-monitor-left = [];
          move-to-monitor-right = [];
          move-to-monitor-up = [];
          move-to-workspace-1 = ["<Shift><Super>1"];
          move-to-workspace-2 = ["<Shift><Super>2"];
          move-to-workspace-3 = ["<Shift><Super>3"];
          move-to-workspace-4 = ["<Shift><Super>4"];
          move-to-workspace-5 = ["<Shift><Super>5"];
          move-to-workspace-6 = ["<Shift><Super>6"];
          move-to-workspace-7 = ["<Shift><Super>7"];
          move-to-workspace-left = ["<Shift><Control><Super>h"];
          move-to-workspace-right = ["<Shift><Control><Super>l"];
          switch-group = [];
          switch-group-backward = [];
          switch-input-source = ["<Alt>space"];
          switch-input-source-backward = ["<Shift><Alt>space"];
          switch-panels = [];
          switch-panels-backward = [];
          switch-to-workspace-1 = ["<Super>1"];
          switch-to-workspace-2 = ["<Super>2"];
          switch-to-workspace-3 = ["<Super>3"];
          switch-to-workspace-4 = ["<Super>4"];
          switch-to-workspace-5 = ["<Super>5"];
          switch-to-workspace-6 = ["<Super>6"];
          switch-to-workspace-7 = ["<Super>7"];
          switch-to-workspace-left = ["<Control><Super>h"];
          switch-to-workspace-right = ["<Control><Super>l"];
          toggle-maximized = ["<Super>z"];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Super>t";
          command = "kitty";
          name = "Terminal";
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
          binding = "Print";
          command = "flameshot gui";
          name = "Flameshot";
        };
        "org/gnome/shell/extensions/espresso" = {
          has-battery = false;
          show-notifications = false;
          user-enabled = true;
        };
        "org/gnome/shell/extensions/just-perfection" = {
          accessibility-menu = false;
          activities-button = true;
          background-menu = true;
          calendar = true;
          clock-menu = true;
          controls-manager-spacing-size = 0;
          dash = true;
          dash-icon-size = 0;
          double-super-to-appgrid = true;
          osd = true;
          panel = true;
          panel-button-padding-size = 6;
          panel-in-overview = true;
          panel-size = 30;
          power-icon = true;
          quick-settings = true;
          ripple-box = true;
          search = true;
          show-apps-button = true;
          startup-status = 1;
          theme = false;
          top-panel-position = 0;
          window-demands-attention-focus = false;
          window-menu-take-screenshot-button = false;
          window-picker-icon = true;
          window-preview-caption = true;
          window-preview-close-button = true;
          workspace = true;
          workspace-background-corner-size = 0;
          workspace-popup = false;
          workspace-switcher-size = 0;
          workspaces-in-app-grid = true;
          world-clock = true;
        };
      };
    };
  };
}
