{pkgs, ...}: {
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
    jdk21
    libuv
    nodejs_21
    psmisc
    python312
    rar
    ripgrep
    unrar
    unzip
    wget
    xclip
    zip
    zlib
  ];
}
