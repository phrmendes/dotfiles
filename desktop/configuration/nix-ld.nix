{pkgs, ...}: {
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      curl
      gcc
      icu
      sqlite
      wget
      zlib
      cairo
    ];
  };
}
