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
      deluge
      docker-compose
      droidcam
      firefox
      gcolor3
      gh
      git
      gnome-extensions-cli
      hugo
      just
      kubectl
      kubernetes-helm
      lazydocker
      libreoffice
      mc
      minikube
      ncdu
      neovide
      obsidian
      parallel
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
      vscode
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
