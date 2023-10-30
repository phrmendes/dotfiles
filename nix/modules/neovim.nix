{
  pkgs,
  lib,
  ...
}: let
  concat = lib.lists.concatLists;
  fromGitHub = rev: ref: repo:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        inherit ref rev;
        url = "https://github.com/${repo}.git";
      };
    };
  gh = {
    cmp-zotcite = fromGitHub "431c720a73fb84c8b1a51b4f123e2a7cc8a58bfd" "HEAD" "jalvesaq/cmp-zotcite";
    telescope-bibtex = fromGitHub "e4dcf64d351db23b14be3563190cf68d5cd49e90" "HEAD" "nvim-telescope/telescope-bibtex.nvim";
    zotcite = fromGitHub "442519a20a80b9ccc8a2baa0607080a21c4ecee0" "HEAD" "jalvesaq/zotcite";
    obsidian-nvim = fromGitHub "630c92045f0595123031b598c624dbad3b5f6dbc" "HEAD" "epwalsh/obsidian.nvim";
  };
  completion = with pkgs.vimPlugins; [
    cmp-nvim-lsp
    cmp-pandoc-nvim
    cmp-path
    cmp_luasnip
    nvim-cmp
    gh.cmp-zotcite
  ];
  lsp = with pkgs.vimPlugins; [
    conform-nvim # formatting
    lsp_signature-nvim # lsp signature hint as you type
    lspkind-nvim # vscode-like pictograms
    ltex_extra-nvim # ltex-ls aditional options
    nvim-lint # linting
    nvim-lspconfig
  ];
  telescope = with pkgs.vimPlugins; [
    telescope-dap-nvim
    telescope-fzy-native-nvim
    telescope-nvim
    telescope-symbols-nvim
    telescope-ui-select-nvim
    telescope-zoxide
    gh.telescope-bibtex
  ];
  treesitter = with pkgs.vimPlugins; [
    nvim-treesitter-context
    nvim-treesitter-textobjects
    nvim-treesitter.withAllGrammars
  ];
  dap = with pkgs.vimPlugins; [
    nvim-dap
    nvim-dap-ui
    nvim-dap-virtual-text
    nvim-dap-python
  ];
  git = with pkgs.vimPlugins; [
    lazygit-nvim
    gitsigns-nvim
    vim-fugitive
  ];
  writing = with pkgs.vimPlugins; [
    quarto-nvim
    markdown-preview-nvim
    nabla-nvim # math symbols
    gh.zotcite
    gh.obsidian-nvim
  ];
  ia = with pkgs.vimPlugins; [
    copilot-vim
    ChatGPT-nvim
  ];
  style = with pkgs.vimPlugins; [
    catppuccin-nvim
    nvim-web-devicons
    which-key-nvim
  ];
  snippets = with pkgs.vimPlugins; [
    friendly-snippets
    luasnip
    neogen # auto-generate docs
  ];
  languages-support = with pkgs.vimPlugins; [
    vim-jinja
    vim-nix
    vim-helm
  ];
  text = with pkgs.vimPlugins; [
    comment-nvim
    dial-nvim # increment/decrement text objects
    todo-comments-nvim # highlight todo comments
    vim-illuminate # highlight word under cursor
  ];
  utils = with pkgs.vimPlugins; [
    executor-nvim # run async jobs
    iron-nvim # REPLs
    mini-nvim # set of small plugins
    nvim-bqf # better quickfix
    nvim-tree-lua # file explorer
    undotree # undo tree
    vim-tmux-navigator # tmux keybindings
    vim-visual-multi # multiple cursors
    zen-mode-nvim # zen mode
  ];
  dependencies = with pkgs.vimPlugins; [
    nui-nvim # ui component lib
    otter-nvim # code completion for code embedded in documents
    plenary-nvim # lua utils
    popup-nvim
  ];
  language-servers = with pkgs; [
    ansible-language-server
    docker-compose-language-service
    ltex-ls
    lua-language-server
    nil
    ruff-lsp
    taplo
    terraform-ls
    texlab
    nodePackages.bash-language-server
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.pyright
    nodePackages.vscode-json-languageserver
    nodePackages.yaml-language-server
  ];
  linters = with pkgs; [
    ansible-lint
    shellcheck
    statix
  ];
  formatters = with pkgs; [
    alejandra
    ruff
    shellharden
    stylua
    nodePackages.prettier
    perl538Packages.LatexIndent
  ];
in {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    plugins = concat [
      completion
      dap
      dependencies
      git
      ia
      languages-support
      lsp
      snippets
      style
      telescope
      text
      treesitter
      utils
      writing
    ];
    extraPython3Packages = pyPkgs:
      with pyPkgs; [
        poppler-qt5
        pynvim
        pyqt5
        pyyaml
      ];
    extraPackages = concat [
      language-servers
      linters
      formatters
    ];
  };
}
