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
      go
      hugo
      hunspell
      lazydocker
      micromamba
      ncdu
      openjdk
      pandoc
      parallel
      quarto
      ripgrep
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
      vlc
      zotero
    ])
    ++ (with pkgs.hunspellDicts; [
      en-us
      pt-br
    ]);
}
