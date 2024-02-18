{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    coreutils-full
    curl
    gcc
    git
    mc
    vim
  ];
}
