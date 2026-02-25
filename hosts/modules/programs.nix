{ pkgs, ... }:
{
  programs = {
    nano.enable = false;
    fuse.userAllowOther = true;
    command-not-found.enable = false;
    zsh.enable = true;

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
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    ssh = {
      startAgent = true;
      askPassword = "${pkgs.openssh-askpass}/libexec/gtk-ssh-askpass";
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
