{pkgs, ...}: {
  home.packages = with pkgs; [
    # CLI
    atool
    coursier
    duckdb
    exa
    exiftool
    fd
    gh
    gnome-extensions-cli
    hugo
    jdk20
    joshuto
    lazydocker
    micromamba
    ncdu
    pandoc
    parallel
    poppler_utils
    rename
    ripgrep
    scala_3
    slides
    sqlite
    tealdeer
    terraform
    weylus
    xclip
    xlsx2csv
    # GUI
    bitwarden
    caffeine-ng
    chromium
    deluge
    droidcam
    onlyoffice-bin
    thunderbird
    vlc
    xournalpp
    zotero
  ];
}
