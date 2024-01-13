{pkgs, ...}: {
  home.packages =
    (with pkgs; [
      ansible
      backblaze-b2
      bashly
      beekeeper-studio
      bitwarden
      bitwarden-cli
      bruno
      chromium
      coursier
      deluge
      docker-compose
      droidcam
      firefox
      gcolor3
      gh
      git
      gnome-extensions-cli
      go
      hugo
      just
      kind
      kubectl
      kubernetes-helm
      lazydocker
      libreoffice
      logseq
      mc
      ncdu
      parallel
      peek
      phockup
      pop-launcher
      quarto
      qview
      spotify
      syncthingtray
      tectonic
      terraform
      ventoy
      vlc
      zotero
    ])
    ++ (with pkgs.gnome; [
      file-roller
      gnome-calculator
      gnome-disk-utility
      gnome-tweaks
      nautilus
    ])
    ++ (with pkgs.gnomeExtensions; [
      appindicator
      espresso
      pop-shell
    ]);
}
