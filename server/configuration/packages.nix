{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    coreutils-full
    curl
    gcc
    git
    helix
    htop
    mc
    psmisc
    zellij
  ];
}
