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
      vimv-rs
      xclip
      # GUI
      bitwarden
      caffeine-ng
      dbeaver
      droidcam
      fragments
      joplin
      joplin-desktop
      libreoffice
      neovim-qt
      peek
      vlc
      zotero
    ])
    ++ (with pkgs.hunspellDicts; [
      en-us
      pt-br
    ]);
}
