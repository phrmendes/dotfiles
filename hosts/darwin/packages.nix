{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    binutils
    coreutils-full
    findutils
    gnupg
    gnused
    gzip
    iconv
    libuv
    libxml2
  ];
}
