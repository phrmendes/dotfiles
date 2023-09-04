{pkgs, ...}: {
  home.packages = with pkgs; [
    # CLI
    atool
    coursier
    exa
    exiftool
    fd
    gh
    gnome-extensions-cli
    hugo
    jdk20
    joshuto
    lazydocker
    ncdu
    pandoc
    parallel
    poppler_utils
    rename
    ripgrep
    slides
    sqlite
    tealdeer
    terraform
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
    zotero
  ];
}
