{ pkgs, ... }:
{
  programs = {
    fuse.userAllowOther = true;
    nix-ld.enable = true;
    zsh.enable = true;

    ssh = {
      startAgent = true;
      askPassword = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
    };

    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 3d --keep 5";
      };
    };
  };
}
