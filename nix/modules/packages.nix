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
      jre_minimal
      micromamba
      ncdu
      pandoc
      parallel
      podman
      podman-compose
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
      joplin
      joplin-desktop
      libreoffice
      peek
      vlc
      zotero
    ])
    ++ (with pkgs.hunspellDicts; [
      en-us
      pt-br
    ]);
}
