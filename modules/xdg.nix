{
  xdg = {
    enable = true;
    mime.enable = true;
    portal.config = {
      common."org.freedesktop.impl.portal.Secret" = [ "keepassxc" ];
      hyprland."org.freedesktop.impl.portal.Secret" = [ "keepassxc" ];
    };
    mimeApps = {
      enable = true;
      defaultApplications = {
        "audio/*" = "mpv.desktop";
        "image/*" = "imv.desktop";
        "video/*" = "mpv.desktop";
        "text/*" = "neovide.desktop";
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
