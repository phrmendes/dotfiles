{
  config,
  pkgs,
  lib,
  ...
}: let
  fromGitHub = ref: repo:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        inherit ref;
        url = "https://github.com/${repo}.git";
      };
    };
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    package = pkgs.neovim-unwrapped;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      (fromGitHub "HEAD" "Vigemus/iron.nvim") # REPLs
      (fromGitHub "HEAD" "cljoly/telescope-repo.nvim") # git repos
      (fromGitHub "HEAD" "nvim-telescope/telescope-bibtex.nvim") # bibtex
      alpha-nvim # dashboard
      bufdelete-nvim # better buffer deletion
      cmp-nvim-lsp # lsp completion
      cmp-path # path completion
      cmp_luasnip # snippets completion
      comment-nvim # better comments
      copilot-vim # github copilot
      friendly-snippets # snippets
      gitsigns-nvim # git indicators
      goto-preview # preview definition
      gruvbox-material # colorscheme
      indent-blankline-nvim # indent lines
      lazygit-nvim # lazygit integration
      lspkind-nvim # vscode-like pictograms
      lualine-nvim # statusline
      luasnip # snippets
      markdown-preview-nvim # markdown preview
      mini-nvim # set of small plugins
      neodev-nvim # neovim development utils
      null-ls-nvim # lsp actions
      nvim-cmp # completion
      nvim-dap # debug adapter protocol
      nvim-dap-python # python dap support
      nvim-dap-ui # ui for dap
      nvim-dap-virtual-text # virtual text for dap
      nvim-lspconfig # lsp
      nvim-spectre # search and replace
      nvim-tree-lua # file explorer
      nvim-treesitter.withAllGrammars # treesitter
      nvim-web-devicons # icons
      oil-nvim # file management
      plenary-nvim # lua utils
      project-nvim # project management
      symbols-outline-nvim # symbols outline
      telescope-fzf-native-nvim # telescope fzf integration
      telescope-nvim # fuzzy finder
      telescope-ui-select-nvim # telescope ui
      todo-comments-nvim # todo comments
      todo-txt-vim # tasks
      trouble-nvim # lsp diagnostics
      undotree # undo history
      vim-nix # nix stuff
      vim-tmux-navigator # tmux keybindings
      vim-visual-multi # multiple cursors
      vimwiki # notes
      which-key-nvim # keybindings
    ];
    extraPackages =
      (with pkgs; [
        alejandra
        ansible-language-server
        glow
        ltex-ls
        lua-language-server
        luajitPackages.luacheck
        rnix-lsp
        ruff
        shellcheck
        shfmt
        statix
        stylua
        terraform-ls
        yamllint
      ])
      ++ (with pkgs.nodePackages; [
        bash-language-server
        dockerfile-language-server-nodejs
        fixjson
        jsonlint
        prettier
        pyright
      ]);
  };
}
