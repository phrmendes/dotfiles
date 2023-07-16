{pkgs, ...}: {
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
    terraform
    xclip
    zk
    # GUI
    bitwarden
    copyq
    caffeine-ng
    deluge
    onlyoffice-bin
    thunderbird
    vlc
    zotero
    # language-servers
    ansible-language-server
    efm-langserver # generic
    ltex-ls # language tool
    lua-language-server
    metals # scala
    nil # nix
    ruff-lsp # python
    taplo # toml
    terraform-ls
    texlab # latex
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.pyright
    nodePackages.vscode-json-languageserver
    nodePackages.yaml-language-server
    # linters
    shellcheck
    statix # nix
    yamllint
    nodePackages.jsonlint
    # formatters
    alejandra # nix
    ruff # python
    scalafmt
    shfmt
    luaformatter
    nodePackages.prettier # yaml, json, markdown
  ];
}
