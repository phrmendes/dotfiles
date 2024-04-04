{
  pkgs,
  inputs,
  ...
}: let
  wallpaper = ../../../dotfiles/wallpaper.png;
in {
  environment.systemPackages = with pkgs; [
    appimage-run
    binutils
    cmake
    coreutils-full
    curl
    gcc
    gcr
    gnumake
    gnupg
    gnused
    gzip
    iconv
    icu
    jdk21
    libnotify
    libuv
    libxml2
    nodejs_21
    playerctl
    psmisc
    python312
    rar
    readline
    sqlite
    unrar
    unzip
    wget
    wl-clipboard
    wlr-randr
    xdg-utils
    zip
    zlib
    gnome.gnome-disk-utility
    kdePackages.polkit-kde-agent-1
    (elegant-sddm.override {
      themeConfig.General = {
        background = "${wallpaper}";
      };
    })
  ];
}
