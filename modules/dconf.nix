{
  config,
  lib,
  ...
}:
{
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
          ];
          enabled-extensions = [
            "AlphabeticalAppGrid@stuarthayhurst"
            "Vitals@CoreCoding.com"
            "appindicatorsupport@rgcjonas.gmail.com"
            "caffeine@patapon.info"
            "clipboard-indicator@tudmotu.com"
            "gnome-mosaic@jardon.github.com"
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
          switch-to-application-1 = [ ];
          switch-to-application-2 = [ ];
          switch-to-application-3 = [ ];
          switch-to-application-4 = [ ];
          switch-to-application-5 = [ ];
          switch-to-application-6 = [ ];
          switch-to-application-7 = [ ];
          toggle-message-tray = [ "<Super>n" ];
        };
        "org/gnome/desktop/wm/keybindings" = {
          activate-window-menu = [ ];
          begin-move = [ ];
          begin-resize = [ ];
          close = [ "<Super>q" ];
          cycle-group = [ ];
          cycle-group-backward = [ ];
          cycle-panels = [ ];
          cycle-panels-backward = [ ];
          cycle-windows = [ ];
          cycle-windows-backward = [ ];
          minimize = [ ];
          move-to-monitor-down = [ ];
          move-to-monitor-left = [ ];
          move-to-monitor-right = [ ];
          move-to-monitor-up = [ ];
          move-to-workspace-1 = [ "<Shift><Super>1" ];
          move-to-workspace-2 = [ "<Shift><Super>2" ];
          move-to-workspace-3 = [ "<Shift><Super>3" ];
          move-to-workspace-4 = [ "<Shift><Super>4" ];
          move-to-workspace-5 = [ "<Shift><Super>5" ];
          move-to-workspace-6 = [ "<Shift><Super>6" ];
          move-to-workspace-7 = [ "<Shift><Super>7" ];
          move-to-workspace-left = [ "<Shift><Control><Super>h" ];
          move-to-workspace-right = [ "<Shift><Control><Super>l" ];
          switch-group = [ ];
          switch-group-backward = [ ];
          switch-input-source = [ "<Super>i" ];
          switch-input-source-backward = [ "<Shift><Super>i" ];
          switch-panels = [ ];
          switch-panels-backward = [ ];
          switch-to-workspace-1 = [ "<Super>1" ];
          switch-to-workspace-2 = [ "<Super>2" ];
          switch-to-workspace-3 = [ "<Super>3" ];
          switch-to-workspace-4 = [ "<Super>4" ];
          switch-to-workspace-5 = [ "<Super>5" ];
          switch-to-workspace-6 = [ "<Super>6" ];
          switch-to-workspace-7 = [ "<Super>7" ];
          switch-to-workspace-left = [ "<Control><Super>h" ];
          switch-to-workspace-right = [ "<Control><Super>l" ];
          toggle-maximized = [ "<Super>z" ];
        };
        "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
          binding = "<Super>t";
          command = "kitty";
          name = "Terminal";
        };
        "org/gnome/shell/extensions/vitals" = {
          icon-style = 1;
          show-gpu = true;
          show-network = true;
          show-storage = true;
          show-voltage = false;
          use-higher-precision = true;
          hot-sensors = [
            "_processor_usage_"
            "_memory_usage_"
          ];
        };
        "org/gnome/shell/extensions/caffeine" = {
          enable-mpris = true;
          restore-state = true;
          show-indicator = "always";
          toggle-shortcut = [ "<Super>c" ];
          user-enabled = false;
        };
        "org/gnome/shell/extensions/clipboard-indicator" = {
          toggle-menu = [ "<Super>v" ];
          clear-history = [ ];
          next-entry = [ ];
          prev-entry = [ ];
          private-mode-binding = [ ];
        };
        "org/gnome/shell/extensions/gnome-mosaic" = {
          active-hint = true;
          active-hint-border-width = lib.hm.gvariant.mkUint32 2;
          gap-inner = lib.hm.gvariant.mkUint32 2;
          gap-outer = lib.hm.gvariant.mkUint32 2;
          mouse-cursor-follows-active-window = false;
          smart-gaps = false;
          snap-to-grid = false;
          tile-by-default = true;
        };
      };
    };
  };
}
