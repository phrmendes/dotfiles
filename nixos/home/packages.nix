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
      droidcam
      firefox
      gcolor3
      gh
      git
      go
      hugo
      jq
      just
      kind
      kubectl
      kubernetes-helm
      lazydocker
      libreoffice
      mc
      ncdu
      neovide
      obsidian
      opentofu
      pandoc
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
      zellij
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
