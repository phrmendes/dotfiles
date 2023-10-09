{pkgs, ...}: {
  home.packages = with pkgs; [
    # CLI
    asdf-vm
    bitwarden-cli
    docker-slim
    duckdb
    eza
    fd
    gh
    gnome-extensions-cli
    hugo
    micromamba
    ncdu
    pandoc
    parallel
    quarto
    ripgrep
    sqlite
    tealdeer
    tectonic
    terraform
    xclip
    # GUI
    caffeine-ng
    droidcam
  ];
}
