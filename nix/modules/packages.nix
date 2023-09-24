{pkgs, ...}: {
  home.packages = with pkgs; [
    # CLI
    bitwarden-cli
    coursier
    duckdb
    eza
    fd
    gh
    gnome-extensions-cli
    hugo
    hunspell
    hunspellDicts.en_US
    hunspellDicts.pt_BR
    jdk20
    lazydocker
    micromamba
    ncdu
    pandoc
    parallel
    quarto
    ripgrep
    scala_3
    sqlite
    tealdeer
    tectonic
    terraform
    xclip
    # GUI
    bitwarden
    caffeine-ng
    chromium
    deluge
    droidcam
    libreoffice
    logseq
    syncthing
    syncthingtray
    vlc
    zotero
  ];
}
