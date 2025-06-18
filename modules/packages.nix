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
        ast-grep
        curl
        deluge
        dig
        discord
        docker-credential-helpers
        exiftool
        ffmpeg
        ffmpegthumbnailer
        filezilla
        firefox
        gcloud
        gdu
        ghostscript
        go
        gotools
        grpcurl
        hyprland-qtutils
        imagemagick
        jdk
        just
        kooha
        kubectl
        kubernetes-helm
        libqalculate
        libreoffice
        mermaid-cli
        minikube
        muse-sounds-manager
        musescore
        networkmanagerapplet
        nix-prefetch-github
        nodejs
        pasystray
        pavucontrol
        phockup
        playerctl
        poppler
        python313
        quarto
        sqlite
        sshfs
        stremio
        tectonic
        terraform
        websocat
        wofi-emoji
        wofi-power-menu
        zotero
      ];
  };
}
