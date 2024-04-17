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
    gparted
    gzip
    iconv
    icu
    jdk21
    libuv
    libxml2
    nodejs_21
    psmisc
    python312
    rar
    readline
    sqlite
    unrar
    unzip
    wget
    wl-clipboard
    xdg-utils
    zip
    zlib
  ];
}
