{pkgs, ...}: {
  home.packages = with pkgs; [
    ansible
    bat
    bitwarden
    btop
    exa
    fd
    gh
    go
    hugo
    lazydocker
    mlocate
    motrix
    pandoc
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
