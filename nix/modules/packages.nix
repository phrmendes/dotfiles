{pkgs, ...}: {
  home.packages =
    (with pkgs; [
      ansible
      baobab
      boxes
      bat
      bitwarden
      btop
      exa
      fd
      fragments
      gh
      gnome-photos
      hugo
      mlocate
      onlyoffice-bin
      pandoc
      podman
      podman-compose
      quarto
      rename
      ripgrep
      spotify
      sqlite
      tealdeer
      tectonic
      vlc
      xclip
      zathura
      zotero
    ])
    ++ (with pkgs.gnome; [
      gnome-disk-utility
      geary
      gedit
    ]);
}
