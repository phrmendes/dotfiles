{
  config,
  lib,
  pkgs,
  ...
}: {
  options.packages.enable = lib.mkEnableOption "enable packages";

  config = lib.mkIf config.packages.enable {
    home.packages = with pkgs;
      [
        bitwarden
        bitwarden-cli
        brightnessctl
        deluge
        docker-compose
        droidcam
        exiftool
        fd
        ffmpeg
        ffmpegthumbnailer
        file-roller
        firefox
        gdu
        gnome-commander
        go
        gotools
        gparted
        grim
        hyprland-qtutils
        imagemagick
        inkscape
        kind
        kooha
        kubectl
        libreoffice
        lynx
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
        vesktop
        wofi-emoji
        zotero
      ]
      ++ (with beam27Packages; [
        elixir
      ]);
  };
}
