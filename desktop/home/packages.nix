{pkgs, ...}: {
  home.packages =
    (with pkgs; [
      ansible
      backblaze-b2
      bashly
      bitwarden
      bitwarden-cli
      bruno
      chromium
      curtail
      dbeaver
      deluge
      droidcam
      evince
      firefox
      gcolor3
      gh
      git
      helix
      httpie
      hugo
      jq
      just
      kind
      kubectl
      kubernetes-helm
      libreoffice
      libusb1
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
      qalculate-gtk
      quarto
      qview
      syncthingtray
      tectonic
      terraform
      vagrant
      ventoy
      vlc
      zellij
      zotero
    ])
    ++ (with pkgs.gnome; [
      file-roller
      gnome-disk-utility
      gnome-tweaks
      nautilus
    ])
    ++ (with pkgs.gnomeExtensions; [
      appindicator
      espresso
      pop-shell
      user-themes
    ]);
}
