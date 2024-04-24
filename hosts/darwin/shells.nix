{pkgs, ...}: {
  environment.shells = with pkgs; [
    bashInteractive
    zsh
  ];
}
