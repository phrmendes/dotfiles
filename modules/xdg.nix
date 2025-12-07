{
  xdg = {
    enable = true;
    mime.enable = true;
    portal.config = {
      common."org.freedesktop.impl.portal.Secret" = [ "keepassxc" ];
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "audio/*" = "mpv.desktop";
        "image/*" = "imv.desktop";
        "video/*" = "mpv.desktop";
        "text/*" = "nvim-qt.desktop";
        "text/plain" = "nvim-qt.desktop";
        "x-scheme-handler/terminal" = "com.mitchellh.ghostty.desktop";
        "application/x-terminal-emulator" = "com.mitchellh.ghostty.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
    };
  };
}
