{
  pkgs,
  parameters,
  ...
}:
{
  programs = {
    dconf.enable = true;
    droidcam.enable = true;
    file-roller.enable = true;
    fuse.userAllowOther = true;
    hyprland.enable = true;
    kdeconnect.enable = true;
    nix-ld.enable = true;
    zsh.enable = true;

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    ssh = {
      startAgent = true;
      askPassword = "${pkgs.lxqt.lxqt-openssh-askpass}/bin/lxqt-openssh-askpass";
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
