{pkgs, ...}: {
  home.packages = with pkgs; [
    ansible
    baobab
    bat
    bitwarden
    exa
    fd
    fragments
    gh
    gnome.geary
    hugo
    mlocate
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