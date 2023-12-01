{pkgs, ...}: {
  home.packages =
    (with pkgs; [
      ansible
      bashly
      beekeeper-studio
      bitwarden
      bruno
      celluloid
      chromium
      csvkit
      docker-compose
      droidcam
      eza
      firefox
      fragments
      gh
      git
      go
      gthumb
      hugo
      imagemagick
      insync
      just
      kubectl
      kubernetes-helm
      lazydocker
      minikube
      ncdu
      neovide
      obsidian
      onlyoffice-bin
      parallel
      quarto
      spot
      tealdeer
      tectonic
      terraform
      ueberzugpp
      ventoy
      veracrypt
      wezterm
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
      forge
    ]);
}
