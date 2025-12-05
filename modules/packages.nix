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
      let
        gcloud = google-cloud-sdk.withExtraComponents (
          with google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]
        );
      in
      [
        curl
        deluge-gtk
        discord
        drawing
        elixir
        exiftool
        ffmpeg
        ffmpegthumbnailer
        file-roller
        filezilla
        firefox
        gcloud
        gcolor3
        gdu
        ghostscript
        gimp3-with-plugins
        gnome-screenshot
        gnome-tweaks
        go
        hydralauncher
        imagemagick
        inkscape
        javaPackages.openjfx25
        jdk
        jqp
        jstest-gtk
        just
        kind
        krew
        kubectl
        kubernetes-helm
        libqalculate
        lutris
        mangohud
        nautilus
        neovide
        networkmanagerapplet
        nix-prefetch-github
        nodejs_latest
        onlyoffice-desktopeditors
        opencode
        parallel
        pass
        pavucontrol
        phockup
        playerctl
        poppler
        prismlauncher
        protonup-qt
        python314
        quarto
        sqlite
        tectonic
        ungoogled-chromium
        wofi-emoji
        wofi-power-menu
        yq-go
        zotero
      ]
      ++ (with gnomeExtensions; [
        alphabetical-app-grid
        appindicator
        caffeine
        clipboard-indicator
        mosaic
        user-themes
        vitals
      ]);
  };
}
