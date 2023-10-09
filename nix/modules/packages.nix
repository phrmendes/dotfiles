{pkgs, ...}: {
  home.packages =
    (with pkgs; [
      # CLI
      asdf-vm
      bitwarden-cli
      docker-slim
      duckdb
      eza
      fd
      gh
      gnome-extensions-cli
      hugo
      hunspell
      lazydocker
      micromamba
      ncdu
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
      bruno
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
