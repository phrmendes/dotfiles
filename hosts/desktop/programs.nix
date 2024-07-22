{
  pkgs,
  parameters,
  ...
}: {
  programs = {
    dconf.enable = true;
    fuse.userAllowOther = true;
    seahorse.enable = true;
    virt-manager.enable = true;
    zsh.enable = true;

    nh = {
      enable = true;
      flake = "/home/${parameters.user}/Projects/dotfiles";
      clean = {
        enable = true;
        extraArgs = "--keep-since 3d --keep 3";
      };
    };

    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
      libraries = with pkgs; [
        cairo
        curl
        dbus
        freetype
        fuse3
        glib
        glibc
        icu
        libuuid
        mesa
        openssl
        stdenv.cc.cc
        vulkan-loader
      ];
    };
  };
}
