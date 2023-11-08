{ pkgs
, lib
, ...
}:
let
  concat = lib.lists.concatLists;
  packages = with pkgs; [
    ansible-lint
    bashly
    caffeine-ng
    droidcam
    eza
    fd
    flutter
    gh
    gnome-extensions-cli
    hugo
    joshuto
    kubectl
    kubernetes-helm
    micromamba
    minikube
    ncdu
    pandoc
    parallel
    qview
    ripgrep
    tealdeer
    tectonic
    terraform
  ];
  language-servers = with pkgs; [
    ansible-language-server
    lua-language-server
    marksman
    nil
    taplo
    terraform-ls
    texlab
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.pyright
    nodePackages.vscode-json-languageserver
    nodePackages.yaml-language-server
  ];
  formatters = with pkgs; [
    nixpkgs-fmt
    shellharden
    nodePackages.prettier
  ];
in
{
  home.packages = concat [
    formatters
    language-servers
    packages
  ];
}
