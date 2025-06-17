{ pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    inputs.agenix.packages.${pkgs.system}.default
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
