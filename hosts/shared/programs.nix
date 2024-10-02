{
  pkgs,
  parameters,
  ...
}: {
  programs = {
    dconf.enable = true;
    fuse.userAllowOther = true;
    zsh.enable = true;
    kdeconnect.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      settings = {
        default-cache-ttl = 2592000;
        max-cache-ttl = 2592000;
      };
    };

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
        acl
        attr
        bzip2
        libsodium
        libssh
        libxml2
        openssl
        readline
        stdenv.cc.cc
        systemd
        tk
        util-linux
        xz
        zlib
        zstd
      ];
    };
  };
}
