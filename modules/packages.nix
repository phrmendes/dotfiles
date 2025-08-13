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
        curl
        dig
        discord
        docker-credential-helpers
        elixir
        exiftool
        ffmpeg
        ffmpegthumbnailer
        firefox
        gcloud
        gdu
        go
        goose-cli
        gotools
        grpcurl
        hyprland-qtutils
        imagemagick
        jdk
        jpegoptim
        just
        jwt-cli
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
        stremio
        tectonic
        termscp
        terraform
        transmission_4
        tridactyl-native
        websocat
        wofi-emoji
        wofi-power-menu
        yq-go
        zotero
      ];
  };
}
