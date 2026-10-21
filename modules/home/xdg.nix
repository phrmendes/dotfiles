{
  flake.modules.homeManager.xdg =
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
            "text/html" = "librewolf.desktop";
            "text/xml" = "librewolf.desktop";
            "application/xhtml+xml" = "librewolf.desktop";
            "x-scheme-handler/http" = "librewolf.desktop";
            "x-scheme-handler/https" = "librewolf.desktop";
            "x-scheme-handler/about" = "librewolf.desktop";
            "x-scheme-handler/unknown" = "librewolf.desktop";
          };
        };
      };
    };
}
