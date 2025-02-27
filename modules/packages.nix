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
        bitwarden
        brightnessctl
        curl
        deluge
        discord-canary
        docker-compose
        droidcam
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
        gparted
        grim
        hyprland-qtutils
        imagemagick
        inkscape
        jq
        kind
        kooha
        kubectl
        kubernetes-helm
        libreoffice
        mermaid-cli
        neovide
        networkmanagerapplet
        nix-prefetch-github
        nodejs_23
        nomacs
        pasystray
        pavucontrol
        phockup
        playerctl
        plex
        podman-desktop
        poppler
        protonvpn-gui
        python313
        qalculate-gtk
        quarto
        satty
        slurp
        sqlite
        sshfs
        sshs
        stremio
        tectonic
        terraform
        ungoogled-chromium
        ventoy
        wofi-emoji
        zotero
      ]
      ++ (with beam27Packages; [
        elixir
      ]);
  };
}
