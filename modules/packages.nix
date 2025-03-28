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
        brave
        brightnessctl
        curl
        deluge
        discord-canary
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
        grim
        hyprland-qtutils
        imagemagick
        imv
        jdk
        jq
        kooha
        kubectl
        kubernetes-helm
        lazydocker
        libqalculate
        libreoffice
        mermaid-cli
        minikube
        nautilus
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
        satty
        sesh
        slurp
        sqlite
        sshfs
        tectonic
        terraform
        uv
        ventoy
        wofi-emoji
        zotero
      ];
  };
}
