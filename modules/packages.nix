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
        thunar = (
          xfce.thunar.override {
            thunarPlugins = with xfce; [
              thunar-archive-plugin
              thunar-volman
            ];
          }
        );
      in
      [
        bitwarden
        brave
        brightnessctl
        curl
        deluge
        discord-canary
        docker-compose
        droidcam
        elixir
        exiftool
        fd
        ffmpeg
        ffmpegthumbnailer
        gcloud
        gdu
        ghostscript
        grim
        hyprland-qtutils
        imagemagick
        imv
        jq
        kind
        kooha
        kubectl
        kubernetes-helm
        libqalculate
        libreoffice
        mermaid-cli
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
        python3
        quarto
        satty
        sesh
        slurp
        sqlite
        sshfs
        tectonic
        terraform
        thunar
        ventoy
        wofi-emoji
        xarchiver
        zotero
      ];
  };
}
