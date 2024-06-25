{
  pkgs,
  parameters,
  ...
}: {
  programs = {
    dconf.enable = true;
    firefox.enable = true;
    fuse.userAllowOther = true;
    seahorse.enable = true;
    virt-manager.enable = true;
    zsh.enable = true;

    kdeconnect = {
      enable = true;
      package = pkgs.gnomeExtensions.gsconnect;
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
      pinentryPackage = pkgs.pinentry-gnome3;
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
