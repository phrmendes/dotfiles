{pkgs, ...}: {
  home.packages = with pkgs; [
    bashly
    eza
    fd
    gh
    gnome-extensions-cli
    hugo
    kubectl
    kubernetes-helm
    micromamba
    minikube
    ncdu
    parallel
    ripgrep
    tealdeer
    terraform
    xclip
    bruno
  ];
}
