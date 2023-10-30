{pkgs, ...}: {
  home.packages =
    (with pkgs; [
      # CLI
      ansible
      asdf-vm
      bitwarden-cli
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
      poetry
      quarto
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
      evince
      libreoffice
      neovim-qt
      obsidian
      peek
      podman-desktop
      qbittorrent
      thunderbird
      vlc
      zotero
    ])
    ++ (with pkgs.hunspellDicts; [
      en-us
      pt-br
    ]);
}
