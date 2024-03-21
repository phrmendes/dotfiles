{
  pkgs,
  inputs,
  ...
}: let
  wallpaper = ../../dotfiles/wallpaper.png;
in {
  environment.systemPackages = with pkgs; [
    appimage-run
    binutils
    cmake
    coreutils-full
    curl
    fd
    gcc
    gnumake
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
    ripgrep
    sqlite
    unrar
    unzip
    wget
    wl-clipboard
    zip
    zlib
    (elegant-sddm.override {
      themeConfig.General = {
        background = "${wallpaper}";
      };
    })
  ];
}
