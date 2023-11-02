{ pkgs
, lib
, ...
}:
let
  concat = lib.lists.concatLists;
  cli = with pkgs; [
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
    poetry
    ripgrep
    tealdeer
    tectonic
    terraform
    ansible-lint
    nil
    nixpkgs-fmt
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
    thunderbird
    vlc
    vscode
    zotero
  ];
  language-servers = (with pkgs; [
    ansible-language-server
    ltex-ls
    marksman
    nil
    taplo
    texlab
  ]) ++ (with pkgs.nodePackages; [
    bash-language-server
    dockerfile-language-server-nodejs
    vscode-json-languageserver
    yaml-language-server
  ]);
  dependencies = with pkgs; [
    jre_minimal
    xclip
    hunspell
    hunspellDicts.en-us
    hunspellDicts.pt-br
  ];
in
{
  home.packages = concat [
    gui
    cli
    dependencies
    language-servers
  ];
}
