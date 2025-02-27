{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cachix
    coreutils-full
    file
    findutils
    gcc
    gnused
    gzip
    mlocate
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
