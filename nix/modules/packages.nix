{pkgs, ...}: {
  home.packages =
    (with pkgs; [
      # CLI
      asdf-vm
      bitwarden-cli
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
      podman
      podman-compose
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
      droidcam
      fragments
      komikku
      libreoffice
      peek
      zotero
    ])
    ++ (with pkgs.hunspellDicts; [
      en-us
      pt-br
    ]);
}
