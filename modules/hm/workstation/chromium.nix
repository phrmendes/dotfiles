_: {
  modules.homeManager.workstation.chromium =
    {
      pkgs,
      osConfig,
      lib,
      ...
    }:
    let
      isDesktop = !osConfig.machine.isLaptop;
      mesaEnv = "__GLX_VENDOR_LIBRARY_NAME=mesa __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";
    in
    {
      home.packages = [ pkgs.ungoogled-chromium ];

      xdg.desktopEntries.chromium-browser = lib.mkIf isDesktop {
        name = "Chromium";
        genericName = "Web Browser";
        exec = "env ${mesaEnv} chromium %U";
        icon = "chromium";
        terminal = false;
        categories = [
          "Network"
          "WebBrowser"
        ];
      };
    };
}
