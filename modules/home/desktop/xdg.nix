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

        configFile."gtk-3.0/bookmarks".text = ''
          file://${config.home.homeDirectory}/Documents Documents
          file://${config.home.homeDirectory}/Downloads Downloads
          file://${config.home.homeDirectory}/Pictures Pictures
          file://${config.home.homeDirectory}/Videos Videos
          sftp://server SFTP
        '';

        userDirs = {
          enable = true;
          desktop = null;
          music = null;
          publicShare = null;
          templates = null;
        };
        mimeApps = {
          enable = true;
          defaultApplications = {
            "audio/*" = "mpv.desktop";
            "image/*" = "org.gnome.Loupe.desktop";
            "video/*" = "mpv.desktop";
            "text/*" = "org.daa.NeovimGtk.desktop";
            "x-scheme-handler/terminal" = "kitty.desktop";
            "application/x-terminal-emulator" = "kitty.desktop";
            "application/pdf" = "org.pwmt.zathura.desktop";
            "application/epub+zip" = "org.pwmt.zathura.desktop";
            "application/zip" = "org.gnome.FileRoller.desktop";
            "application/x-tar" = "org.gnome.FileRoller.desktop";
            "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
            "application/x-bittorrent" = "de.haeckerfelix.Fragments.desktop";
            "x-scheme-handler/magnet" = "de.haeckerfelix.Fragments.desktop";
            "inode/directory" = "org.gnome.Nautilus.desktop";
            "application/json" = "org.daa.NeovimGtk.desktop";
            "application/toml" = "org.daa.NeovimGtk.desktop";
            "application/x-yaml" = "org.daa.NeovimGtk.desktop";
            "application/x-shellscript" = "org.daa.NeovimGtk.desktop";
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
