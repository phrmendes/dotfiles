_: {
  modules.homeManager.workstation.firefox =
    {
      osConfig,
      lib,
      ...
    }:
    let
      isDesktop = !osConfig.machine.isLaptop;
      mesaEnv = "__GLX_VENDOR_LIBRARY_NAME=mesa __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";
    in
    {
      programs.firefox = {
        enable = true;
        profiles.default = {
          isDefault = true;
        };
      };

      xdg.desktopEntries.firefox = lib.mkIf isDesktop {
        name = "Firefox";
        genericName = "Web Browser";
        exec = "env ${mesaEnv} firefox %u";
        icon = "firefox";
        terminal = false;
        categories = [
          "Network"
          "WebBrowser"
        ];
        mimeType = [
          "text/html"
          "text/xml"
          "application/xhtml+xml"
          "application/vnd.mozilla.xul+xml"
          "x-scheme-handler/http"
          "x-scheme-handler/https"
        ];
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
