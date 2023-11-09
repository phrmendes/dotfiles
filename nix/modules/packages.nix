{
  pkgs,
  lib,
  ...
}: let
  concat = lib.lists.concatLists;
  cli = with pkgs; [
    bashly
    bitwarden-cli
    eza
    fd
    flutter
    gh
    gnome-extensions-cli
    hugo
    joshuto
    micromamba
    ncdu
    pandoc
    parallel
    podman
    podman-compose
    poetry
    ripgrep
    tealdeer
    tectonic
    terraform
  ];
  gui = with pkgs; [
    bitwarden
    bruno
    caffeine-ng
    dbeaver
    deluge
    droidcam
    evince
    libreoffice
    obsidian
    peek
    podman-desktop
    qview
    thunderbird
    vlc
    zotero
  ];
  dependencies = with pkgs; [
    jre_minimal
    xclip
    hunspell
    hunspellDicts.en-us
    hunspellDicts.pt-br
  ];
in {
  home.packages = concat [
    gui
    cli
    dependencies
  ];
}
