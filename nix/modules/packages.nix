{pkgs, ...}: {
  home.packages = with pkgs; [
    ansible
    bat
    bitwarden
    btop
    exa
    fd
    gh
    hugo
    mlocate
    motrix
    onlyoffice-bin
    pandoc
    podman
    podman-compose
    quarto
    rename
    ripgrep
    spotify
    sqlite
    tealdeer
    tectonic
    vlc
    xclip
    zathura
    zotero
  ];
}
