{
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
    package = pkgs.neovim-unwrapped;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      (fromGitHub "HEAD" "nvim-telescope/telescope-bibtex.nvim") # bibtex
      (fromGitHub "HEAD" "opdavies/toggle-checkbox.nvim") # toggle checkboxes
      catppuccin-nvim # colorscheme
      cmp-nvim-lsp # lsp completion
      cmp-path # path completion
      cmp_luasnip # snippets completion
      copilot-vim # github copilot
      friendly-snippets # snippets
      gitsigns-nvim # git indicators
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
      nvim-treesitter.withAllGrammars # treesitter
      nvim-web-devicons # icons
      oil-nvim # file management
      plenary-nvim # lua utils
      telescope-fzy-native-nvim # telescope fzy integration
      telescope-nvim # fuzzy finder
      telescope-ui-select-nvim # telescope ui
      todo-comments-nvim # todo comments
      todo-txt-vim # tasks
      undotree # undo history
      vim-fugitive # git integration
      vim-nix # nix syntax
      vim-tmux-navigator # tmux keybindings
      vim-visual-multi # multiple cursors
      which-key-nvim # keybindings
      zen-mode-nvim # zen mode
    ];
  };
}
