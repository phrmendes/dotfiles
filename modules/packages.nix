{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.packages.enable = lib.mkEnableOption "enable packages";

  config = lib.mkIf config.packages.enable {
    home.packages =
      with pkgs;
      [
        curl
        deluge-gtk
        drawing
        elixir
        exiftool
        ffmpeg
        ffmpegthumbnailer
        file-roller
        filezilla
        firefox
        gcolor3
        gdu
        gnome-screenshot
        gnome-tweaks
        go
        imagemagick
        jdk
        jqp
        just
        kubectl
        kubernetes-helm
        libqalculate
        nautilus
        nix-prefetch-github
        nodejs_latest
        onlyoffice-desktopeditors
        pass
        phockup
        poppler
        python314
        quarto
        tectonic
        tpm2-tools
        ungoogled-chromium
        vesktop
        zotero
      ]
      ++ (with gnomeExtensions; [
        alphabetical-app-grid
        appindicator
        caffeine
        clipboard-indicator
        mosaic
        user-themes
      ]);
  };
}
