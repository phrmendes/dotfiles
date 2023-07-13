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
    jdk20
    lazydocker
    lf
    mlocate
    ncdu
    pandoc
    pipr
    quarto
    rename
    ripgrep
    slides
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
    ltex-ls
    marksman
    nil
    ruff-lsp
    taplo
    terraform-ls
    nodePackages.pyright
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.vscode-json-languageserver
    nodePackages.yaml-language-server
    # formatters
    ruff
    jsonfmt
    nixpkgs-fmt
    shfmt
    yamlfmt
    nodePackages.prettier
  ];
}
