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
        elixir
        exiftool
        ffmpeg
        ffmpegthumbnailer
        file-roller
        filezilla
        firefox
        gcloud
        gdu
        ghostscript
        gimp3-with-plugins
        go
        hydralauncher
        hyprland-qtutils
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
        libreoffice
        lutris
        mangohud
        neovide
        networkmanagerapplet
        nix-prefetch-github
        nodejs_latest
        opencode
        parallel
        pass
        pasystray
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
      ];
  };
}
