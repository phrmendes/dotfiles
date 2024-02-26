{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    appimage-run
    binutils
    cmake
    coreutils-full
    fd
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
    xclip
    zip
  ];
}
