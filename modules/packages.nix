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
    in
      [
        age
        android-tools
        ansible
        bitwarden
        cachix
        chromium
        coreutils-full
        deluge
        discord
        drawing
        droidcam
        elixir
        evince
        exiftool
        fd
        ffmpegthumbnailer
        file
        file-roller
        filezilla
        findutils
        firefox
        gcc
        gcloud
        gcolor3
        gdal
        gdu
        gnome-tweaks
        gnumake
        gnused
        go
        gparted
        graphviz
        gzip
        hugo
        imagemagick
        infisical
        inkscape
        jdk
        jq
        kubectl
        kubernetes-helm
        libreoffice
        livebook
        minikube
        mongosh
        nautilus
        ngrok
        obsidian
        parallel
        phockup
        plex
        podman-tui
        pop-launcher
        poppler
        portal
        postgresql
        protonvpn-gui
        python312
        qalculate-gtk
        quarto
        rar
        scrcpy
        sqlite
        sshs
        syncthingtray
        tectonic
        terraform
        unar
        usbimager
        uv
        vagrant
        ventoy
        vlc
        wget
        zip
        zotero
      ]
      ++ (with nodePackages_latest; [
        nodejs
      ])
      ++ (with gnomeExtensions; [
        alphabetical-app-grid
        appindicator
        espresso
        pop-shell
        sound-output-device-chooser
        tailscale-qs
        user-themes
      ]);
  };
}
