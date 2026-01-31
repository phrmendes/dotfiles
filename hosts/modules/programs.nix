{ pkgs, ... }:
{
  programs = {
    fuse.userAllowOther = true;
    command-not-found.enable = false;
    zsh.enable = true;
    nix-index.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        glib
        libGL
        libxxf86vm
      ];
    };

    gnupg.agent = {
      enable = true;
      enableBrowserSocket = true;
      pinentryPackage = pkgs.pinentry-qt;
    };

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
