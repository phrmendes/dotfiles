{
  pkgs,
  parameters,
  ...
}: {
  programs = {
    dconf.enable = true;
    firefox.enable = true;
    fuse.userAllowOther = true;
    kdeconnect.enable = true;
    seahorse.enable = true;
    virt-manager.enable = true;
    zsh.enable = true;

    hyprland = {
      enable = true;
      package = pkgs.hyprland;
    };

    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
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
        cairo
        curl
        dbus
        freetype
        fuse3
        glib
        glibc
        icu
        libnotify
        libpulseaudio
        libusb1
        libuuid
        libuv
        libxml2
        mesa
        openssl
        pipewire
        stdenv.cc.cc
        systemd
        vulkan-loader
      ];
    };
  };
}
