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
        "text/*" = "neovim.desktop";
        "application/pdf" = "org.pwmt.zathura.desktop";
      };
    };
  };
}
