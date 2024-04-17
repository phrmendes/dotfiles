{pkgs, ...}: {
  programs = {
    dconf.enable = true;
    seahorse.enable = true;
    virt-manager.enable = true;
    zsh.enable = true;

    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };

    fuse.userAllowOther = true;
  };
}
