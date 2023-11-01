{
  pkgs,
  lib,
  ...
}: let
  concat = lib.lists.concatLists;
  cli = with pkgs; [
    ansible
    asdf-vm
    bashly
    bitwarden-cli
    eza
    fd
    gh
    gnome-extensions-cli
    hugo
    micromamba
    ncdu
    pandoc
    parallel
    podman
    podman-compose
    poetry
    quarto
    ripgrep
    tealdeer
    tectonic
    terraform
    vimv-rs
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
