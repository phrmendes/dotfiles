{
  config,
  lib,
  pkgs,
  ...
}: {
  options.packages.enable = lib.mkEnableOption "enable packages";

  config = lib.mkIf config.packages.enable {
    home.packages = with pkgs; let
      gcloud = google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [
        gke-gcloud-auth-plugin
      ]);
    in [
      age
      android-tools
      ansible
      bitwarden
      bitwarden-cli
      brave
      brightnessctl
      bws
      deluge
      docker-credential-helpers
      droidcam
      elixir
      evince
      exiftool
      fd
      ffmpeg
      ffmpegthumbnailer
      file-roller
      foliate
      gcloud
      gdu
      gnumake
      gnused
      gparted
      graphviz
      grim
      gthumb
      hugo
      hyprland-qtutils
      imagemagick
      infisical
      inkscape
      jdk
      jq
      just
      kooha
      kubectl
      kubernetes-helm
      lazydocker
      libreoffice
      livebook
      lynx
      minikube
      mongosh
      nautilus
      networkmanagerapplet
      ngrok
      nix-prefetch-github
      ouch
      parallel
      pasystray
      pavucontrol
      phockup
      playerctl
      plex
      poppler
      postgresql
      protonvpn-gui
      python313
      qalculate-gtk
      quarto
      satty
      scrcpy
      slurp
      sshfs
      sshs
      stremio
      tectonic
      terraform
      uv
      ventoy
      vesktop
      vlc
      wofi-emoji
      zotero
    ];
  };
}
