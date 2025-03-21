{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cachix
    coreutils-full
    file
    findutils
    gcc
    gnumake
    gnused
    gzip
    mlocate
    openssl
    p7zip
    protonup
    psmisc
    rar
    unar
    unzip
    wget
    wl-clipboard
    xdg-utils
    zip
  ];
}
