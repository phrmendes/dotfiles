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
        python = python3.withPackages (
          p: with p; [
            pip
            virtualenv
          ]
        );
      in
      [
        bitwarden-cli
        bitwarden-desktop
        brightnessctl
        curl
        deluge
        dig
        discord
        docker-compose
        docker-credential-helpers
        droidcam
        elixir
        exiftool
        fd
        ffmpeg
        ffmpegthumbnailer
        file-roller
        firefox
        gcloud
        gdu
        ghostscript
        gnome-commander
        go
        gotools
        hyprland-qtutils
        imagemagick
        imv
        jdk
        jellyfin
        jq
        just
        kooha
        kubectl
        kubernetes-helm
        lazydocker
        libqalculate
        libreoffice
        mermaid-cli
        minikube
        mongodb-compass
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
        python
        quarto
        sqlite
        sshfs
        tectonic
        terraform
        uv
        ventoy
        wofi-emoji
        wofi-power-menu
        zotero
      ];
  };
}
