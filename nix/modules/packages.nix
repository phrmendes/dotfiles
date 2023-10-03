{pkgs, ...}: {
  home.packages =
    (with pkgs; [
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
      languagetool
      libreoffice
      mathpix-snipping-tool
      postman
      vlc
      zotero
    ])
    ++ (with pkgs.hunspellDicts; [
      en-us
      pt-br
    ]);
}
