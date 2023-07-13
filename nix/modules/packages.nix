{ pkgs, ... }: {
  home.packages = with pkgs; [
    # CLI 
    ansible
    asdf-vm
    coursier
    exa
    fd
    gh
    gnome-extensions-cli
    helix
    hugo
    jdk19
    lazydocker
    mlocate
    ncdu
    pandoc
    pipr
    quarto
    rename
    ripgrep
    sqlite
    tealdeer
    tectonic
    xclip
    zellij
    # GUI
    bitwarden
    copyq
    caffeine-ng
    deluge
    obsidian
    onlyoffice-bin
    thunderbird
    vlc
    vscode
    zotero
    # language servers
    marksman
    nil
    taplo
    terraform-ls
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.pyright
    nodePackages.yaml-language-server
    # linters/formatters
    nixpkgs-fmt
    ruff
    shfmt
    tflint
  ];
}
