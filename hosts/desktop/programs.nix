{
  pkgs,
  parameters,
  ...
}: {
  programs = {
    dconf.enable = true;
    fuse.userAllowOther = true;
    kdeconnect.enable = true;
    seahorse.enable = true;
    virt-manager.enable = true;
    zsh.enable = true;

    hyprland = {
      enable = true;
      package = pkgs.hyprland;
    };

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
    };

    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
      libraries = with pkgs; [
        curl
        libxml2
        openssl
        readline
        stdenv.cc.cc
        tk
        xz
        zlib
      ];
    };
  };
}
