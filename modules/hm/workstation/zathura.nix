_: {
  modules.homeManager.workstation.zathura = {
    programs.zathura.enable = true;

    xdg.mimeApps.defaultApplications = {
      "application/x-cbr" = "org.pwmt.zathura.desktop";
      "application/x-cbz" = "org.pwmt.zathura.desktop";
    };
  };
}
