{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    coreutils-full
    curl
    gcc
    helix
    mc
    ncdu
    psmisc
    zellij
  ];
}
