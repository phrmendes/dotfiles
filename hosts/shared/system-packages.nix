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
    libsecret
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
