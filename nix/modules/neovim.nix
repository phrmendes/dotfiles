{
  pkgs,
  lib,
  ...
}: let
  fromGitHub = rev: ref: repo:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        inherit ref rev;
        url = "https://github.com/${repo}.git";
      };
    };
    org-bullets = fromGitHub "6e0d60e901bb939eb526139cb1f8d59065132fd9" "HEAD" "akinsho/org-bullets.nvim";
    telescope-bibtex = fromGitHub "e4dcf64d351db23b14be3563190cf68d5cd49e90" "HEAD" "nvim-telescope/telescope-bibtex.nvim";
    headlines-nvim = fromGitHub "74a083a3c32a08be24f7dfcc6f448ecf47857f46" "HEAD" "lukas-reineke/headlines.nvim";
in {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      catppuccin-nvim # colorscheme
      cmp-nvim-lsp # lsp completion
      cmp-path # path completion
      cmp_luasnip # snippets completion
      comment-nvim # comments
      conflict-marker-vim # conflict markers
      copilot-vim # github copilot
      friendly-snippets # snippets
      gitsigns-nvim # git indicators
      headlines-nvim # headlines for md and org files
      iron-nvim # REPLs
      lsp_signature-nvim # lsp signature
      lspkind-nvim # vscode-like pictograms
      ltex_extra-nvim # ltex
      luasnip # snippets
      markdown-preview-nvim # markdown preview
      mini-nvim # set of small plugins
      nvim-bqf # quickfix
      nvim-cmp # completion
      nvim-dap # debug adapter protocol
      nvim-dap-python # python dap support
      nvim-dap-ui # ui for dap
      nvim-dap-virtual-text # virtual text for dap
      nvim-lspconfig # lsp
      nvim-spectre # search and replace
      nvim-tree-lua # file explorer
      nvim-treesitter-context # treesitter context
      nvim-treesitter-textobjects # treesitter textobjects
      nvim-treesitter.withAllGrammars # treesitter
      nvim-web-devicons # icons
      oil-nvim # file management
      org-bullets # orgmode bullets
      orgmode # orgmode support
      plenary-nvim # lua utils
      popup-nvim # zoxide dependency
      sniprun # neovim code runner
      telescope-bibtex # bibtex integration
      telescope-fzy-native-nvim # telescope fzy integration
      telescope-nvim # fuzzy finder
      telescope-ui-select-nvim # telescope ui
      telescope-zoxide # zoxide integration
      todo-comments-nvim # todo comments
      twilight-nvim # zen-mode dependency
      undotree # undo history
      vim-fugitive # git integration
      vim-helm # helm syntax
      vim-jinja # jinja syntax
      vim-nix # nix syntax
      vim-table-mode # on the fly table support
      vim-tmux-navigator # tmux keybindings
      vim-visual-multi # multiple cursors
      which-key-nvim # keybindings
      zen-mode-nvim # zen mode
    ];
    extraPackages =
      (with pkgs; [
        alejandra
        ansible-language-server
        ansible-lint
        efm-langserver
        ltex-ls
        lua-language-server
        metals
        nil
        ruff
        ruff-lsp
        scalafmt
        shellcheck
        shfmt
        statix
        stylua
        taplo
        terraform-ls
        texlab
      ])
      ++ (with pkgs.nodePackages; [
        bash-language-server
        dockerfile-language-server-nodejs
        prettier
        pyright
        vscode-json-languageserver
        yaml-language-server
      ]);
  };
}
