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
          with google-cloud-sdk.components;
          [
            gke-gcloud-auth-plugin
          ]
        );
      in
      [
        bitwarden
        brightnessctl
        deluge
        docker-compose
        droidcam
        exiftool
        fd
        ffmpeg
        ffmpegthumbnailer
        file-roller
        gcloud
        gdu
        gnome-commander
        gparted
        grim
        hyprland-qtutils
        imagemagick
        inkscape
        kind
        kooha
        kubectl
        kubernetes-helm
        libreoffice
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
        satty
        slurp
        sshfs
        sshs
        stremio
        terraform
        ventoy
        vivaldi
        wofi-emoji
        zotero
      ]
      ++ (with beam27Packages; [
        elixir
      ]);
  };
}
