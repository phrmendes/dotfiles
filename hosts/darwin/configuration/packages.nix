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
    python312
    sqlite
    unzip
    wget
    zip
    zlib
  ];
}
