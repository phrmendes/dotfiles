{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    binutils
    coreutils-full
    findutils
    gcc
    gnupg
    gnused
    gzip
    iconv
    libuv
    libxml2
  ];
}
