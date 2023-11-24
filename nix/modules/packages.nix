{pkgs, ...}: {
  home.packages =
    (with pkgs; [
      ansible
      bashly
      beekeeper-studio
      bitwarden
      bruno
      caffeine-ng
      chromium
      coursier
      droidcam
      evince
      eza
      fd
      fragments
      gh
      gnome-extensions-cli
      hugo
      hunspell
      jdk21
      kubectl
      kubernetes-helm
      libreoffice
      micromamba
      minikube
      ncdu
      nodejs_21
      obsidian
      parallel
      peek
      podman-compose
      quarto
      ripgrep
      tealdeer
      terraform
      vlc
      xclip
      zotero
    ])
    ++ (with pkgs.hunspellDicts; [
      en-us
      pt-br
    ]);
}
