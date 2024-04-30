{
  pkgs,
  parameters,
  ...
}: {
  programs = {
    dconf.enable = true;
    virt-manager.enable = true;
    zsh.enable = true;
    kdeconnect.enable = true;
    fuse.userAllowOther = true;

    nh = {
      enable = true;
      flake = "/home/${parameters.user}/Projects/dotfiles";
      clean = {
        enable = true;
        extraArgs = "--keep-since 3d --keep 3";
      };
    };

    nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
      libraries = with pkgs; [
        bzip2
        cairo
        coreutils-full
        findutils
        gcc
        gdbm
        glib
        gnumake
        gnupatch
        iconv
        icu
        libcxx
        libffi
        libuv
        libxml2
        openssl
        readline
        sqlite
        stdenv.cc.cc
        tk
        xz
        zlib
      ];
    };

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
    };
  };
}
