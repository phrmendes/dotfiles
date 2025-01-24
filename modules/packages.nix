{
  config,
  lib,
  pkgs,
  ...
}: {
  options.packages.enable = lib.mkEnableOption "enable packages";

  config = lib.mkIf config.packages.enable {
    home.packages = with pkgs; [
      bitwarden
      bitwarden-cli
      brightnessctl
      deluge
      docker-credential-helpers
      droidcam
      exiftool
      fd
      ffmpeg
      ffmpegthumbnailer
      file-roller
      firefox
      gdu
      gnome-commander
      gparted
      grim
      hyprland-qtutils
      imagemagick
      inkscape
      kooha
      lazydocker
      libreoffice
      lynx
      neovide
      networkmanagerapplet
      nix-prefetch-github
      nomacs
      pasystray
      pavucontrol
      phockup
      playerctl
      plex
      poppler
      protonvpn-gui
      qalculate-gtk
      satty
      slurp
      sshfs
      sshs
      stremio
      ventoy
      vesktop
      wofi-emoji
      zotero
    ];
  };
}
