{
  programs = {
    dconf.enable = true;
    fuse.userAllowOther = true;
    hyprland.enable = true;
    kdeconnect.enable = true;
    seahorse.enable = true;
    zsh.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
