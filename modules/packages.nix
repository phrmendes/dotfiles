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
        aider-chat-full
        bitwarden-cli
        bitwarden-desktop
        brave
        brightnessctl
        curl
        deluge
        dig
        discord
        docker-compose
        docker-credential-helpers
        droidcam
        elixir
        evince
        exiftool
        fd
        ffmpeg
        ffmpegthumbnailer
        file-roller
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
        neovide
        networkmanagerapplet
        nix-prefetch-github
        nodejs
        pasystray
        pavucontrol
        phockup
        playerctl
        plex
        poppler
        protonvpn-gui
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
