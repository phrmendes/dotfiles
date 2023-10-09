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
      caffeine-ng
      droidcam
      bitwarden
      peek
      fragments
      komikku
      celluloid
      obsidian
      libreoffice
      zotero
    ])
    ++ (with pkgs.hunspellDicts; [
      en-us
      pt-br
    ]);
}
