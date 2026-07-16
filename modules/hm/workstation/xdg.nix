_: {
  modules.homeManager.workstation.xdg =
    { config, ... }:
    {
    xdg = {
      enable = true;
      autostart.enable = true;
      mime.enable = true;
      systemDirs.data = [
        "/var/lib/flatpak/exports/share"
        "${config.home.homeDirectory}/.local/share/flatpak/exports/share"
      ];

      configFile."mimeapps.list".force = true;
      mimeApps = {
        enable = true;
        defaultApplications = {
          "audio/*" = "mpv.desktop";
          "image/*" = "imv.desktop";
          "video/*" = "mpv.desktop";
          "text/*" = "neovide.desktop";
          "x-scheme-handler/terminal" = "kitty.desktop";
          "application/x-terminal-emulator" = "kitty.desktop";
          "application/pdf" = "org.pwmt.zathura.desktop";
          "text/html" = "firefox.desktop";
          "text/xml" = "firefox.desktop";
          "application/xhtml+xml" = "firefox.desktop";
          "x-scheme-handler/http" = "firefox.desktop";
          "x-scheme-handler/https" = "firefox.desktop";
          "x-scheme-handler/about" = "firefox.desktop";
          "x-scheme-handler/unknown" = "firefox.desktop";
        };
      };
    };
  };
}
