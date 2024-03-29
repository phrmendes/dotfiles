{pkgs, ...}: {
  home.packages = with pkgs; [
    coreutils
    fd
    gcc
    gh
    gnumake
    gnupg
    graphviz
    grex
    httpie
    jdk21
    just
    kind
    kubectl
    kubernetes-helm
    maven
    mc
    ncdu
    nodejs_21
    opentofu
    parallel
    pngpaste
    quarto
    ripgrep
    tealdeer
    terraform
    terragrunt
    tokei
  ];
}
