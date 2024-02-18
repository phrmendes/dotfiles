{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    coreutils-full
    curl
    gcc
    git
    helix
    mc
    psmisc
    zellij
  ];
}
