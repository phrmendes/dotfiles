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
        ansible
        ast-grep
        curl
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
        jpegoptim
        just
        kooha
        kubectl
        kubernetes-helm
        libqalculate
        libreoffice
        mcp-k8s-go
        mermaid-cli
        minikube
        muse-sounds-manager
        musescore
        networkmanagerapplet
        nix-prefetch-github
        nodejs
        opencode
        optipng
        parallel
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
        transmission_4
        tridactyl-native
        websocat
        wofi-emoji
        wofi-power-menu
        zotero
      ];
  };
}
