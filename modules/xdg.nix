{
  xdg = {
    mimeApps.defaultApplications = {
      "application/pdf" = "org.gnome.Evince.desktop";
      "image/*" = "qview.desktop";
      "inode/directory" = "nautilus.desktop";
      "video/*" = "vlc.desktop";
      "audio/*" = "vlc.desktop";
      "text/*" = "nvim.desktop";
    };
    desktopEntries = {
      discord = {
        name = "Discord";
        exec = "env XDG_SESSION_TYPE=x11 discord";
        icon = "discord";
        type = "Application";
      };
    };
  };
}
