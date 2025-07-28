{ pkgs, ... }:
{
  programs = {
    fuse.userAllowOther = true;
    command-not-found.enable = false;
    fish.enable = true;
    nix-ld.enable = true;

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
