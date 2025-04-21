{
  xdg = {
    enable = true;
    mime.enable = true;
    desktopEntries = {
      neovim = {
        name = "Neovim";
        genericName = "Text editor";
        comment = "Edit text files";
        icon = "nvim";
        exec = "nvim %F";
        terminal = true;
        categories = [ "TextEditor" ];
      };
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
