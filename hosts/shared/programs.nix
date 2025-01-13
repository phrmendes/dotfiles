{
  pkgs,
  parameters,
  ...
}: {
  programs = {
    dconf.enable = true;
    fuse.userAllowOther = true;
    hyprland.enable = true;
    kdeconnect.enable = true;
    nix-ld.enable = true;
    zsh.enable = true;

    ssh.askPassword = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gnome3;
      settings = {
        default-cache-ttl = 2592000;
        max-cache-ttl = 2592000;
      };
    };

    nh = {
      enable = true;
      flake = "/home/${parameters.user}/Projects/dotfiles";
      clean = {
        enable = true;
        extraArgs = "--keep-since 3d --keep 5";
      };
    };
  };
}
