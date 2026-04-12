_: {
  modules.homeManager.workstation.firefox = {
    programs.firefox = {
      enable = true;
      profiles.default = {
        isDefault = true;
      };
    };

    stylix.targets.firefox.profileNames = [ "default" ];

    xdg.mimeApps.defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
}
