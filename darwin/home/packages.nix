{pkgs, ...}: {
  home.packages = with pkgs; [
    coreutils
    eza
    fd
    gcc
    gh
    gnumake
    gnupg
    go
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
    podman
    podman-compose
    qemu
    quarto
    ripgrep
    tealdeer
    terraform
    terragrunt
    zellij
  ];
}
