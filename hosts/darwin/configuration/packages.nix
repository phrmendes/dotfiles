{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    cmake
    coreutils-full
    curl
    gcc
    gnumake
    gnupg
    gnused
    gzip
    iconv
    icu
    jdk21
    libuv
    libxml2
    nodejs_21
    playerctl
    python312
    rar
    sqlite
    unrar
    unzip
    wget
    zip
    zlib
  ];
}
