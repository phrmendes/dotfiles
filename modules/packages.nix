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
        bitwarden-cli
        bitwarden-desktop
        curl
        deluge
        dig
        discord
        docker-compose
        docker-credential-helpers
        elixir
        exiftool
        ffmpeg
        ffmpegthumbnailer
        firefox
        gcloud
        gdu
        ghostscript
        go
        gotools
        hyprland-qtutils
        imagemagick
        jdk
        jq
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
        sesh
        sqlite
        sshfs
        stremio
        tectonic
        terraform
        ventoy
        wofi-emoji
        wofi-power-menu
        zotero
      ];
  };
}
