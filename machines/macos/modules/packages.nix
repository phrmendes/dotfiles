{pkgs, ...}: {
  home.packages = with pkgs; [
    coursier
    eza
    fd
    gcc
    gh
    gnumake
    gnupg
    jdk21
    kubectl
    kubernetes-helm
    maven
    micromamba
    minikube
    ncdu
    nodejs_21
    parallel
    podman
    podman-compose
    qemu
    quarto
    ripgrep
    tealdeer
    terraform
    terragrunt
  ];
}
