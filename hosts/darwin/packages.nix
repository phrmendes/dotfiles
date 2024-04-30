{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    coreutils-full
    curl
    gnumake
    gnupg
    gnused
    gzip
    iconv
    libuv
    libxml2
    sqlite
    unzip
    wget
    zip
  ];
}
