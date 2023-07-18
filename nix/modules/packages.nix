{pkgs, ...}: {
  home.packages = with pkgs; [
    # CLI
    ansible
    coursier
    exa
    fd
    feh
    gh
    gnome-extensions-cli
    helix
    hugo
    jdk
    joshuto
    ncdu
    pandoc
    pipr
    podman
    podman-compose
    quarto
    rename
    ripgrep
    slides
    sqlite
    tealdeer
    tectonic
    terraform
    # GUI
    bitwarden
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
    marksman # markdown
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
