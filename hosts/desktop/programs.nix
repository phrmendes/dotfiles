{
  pkgs,
  parameters,
  ...
}: {
  programs = {
    dconf.enable = true;
    virt-manager.enable = true;
    zsh.enable = true;
    kdeconnect.enable = true;
    fuse.userAllowOther = true;

    nh = {
      enable = true;
      flake = "/home/${parameters.user}/Projects/dotfiles";
      clean = {
        enable = true;
        extraArgs = "--keep-since 3d --keep 3";
      };
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
  };
}
