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
    gnome-extensions-cli
    gnome.geary
    hugo
    mlocate
    onlyoffice-bin
    pandoc
    pipr
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
