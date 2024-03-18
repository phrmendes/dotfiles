{
  programs = {
    dconf.enable = true;
    fuse.userAllowOther = true;
    hyprland.enable = true;
    seahorse.enable = true;
    zsh.enable = true;
    virt-manager.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
