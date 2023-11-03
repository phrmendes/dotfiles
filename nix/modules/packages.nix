{ pkgs
, lib
, ...
}:
let
  concat = lib.lists.concatLists;
  cli = with pkgs; [
    ansible-lint
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
    qview
    thunderbird
    vlc
    vscode
    zotero
  ];
  language-servers = with pkgs; [
    ansible-language-server
    ltex-ls
    marksman
    nil
    taplo
    terraform-ls
    texlab
    ruff-lsp
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.pyright
    nodePackages.vscode-json-languageserver
    nodePackages.yaml-language-server
  ];
  formatters = with pkgs; [
    nixpkgs-fmt
    ruff
    shellharden
    nodePackages.prettier
  ];
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
    formatters
  ];
}
