{pkgs, ...}: {
  home.packages =
    (with pkgs; [
      # CLI
      ansible-lint
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
      joplin
      micromamba
      ncdu
      pandoc
      parallel
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
      joplin-desktop
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
