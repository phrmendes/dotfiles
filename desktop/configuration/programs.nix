{
  programs = {
    dconf.enable = true;
    hyprland.enable = true;
    seahorse.enable = true;
    zsh.enable = true;
    virt-manager.enable = true;

    fuse.userAllowOther = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
