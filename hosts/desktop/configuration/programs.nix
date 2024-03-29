{pkgs, ...}: {
  programs = {
    dconf.enable = true;
    hyprland.enable = true;
    kdeconnect.enable = true;
    seahorse.enable = true;
    virt-manager.enable = true;
    zsh.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    fuse.userAllowOther = true;
  };
}
