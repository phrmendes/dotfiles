{ pkgs, lib, ... }:

let
  fromGitHub = ref: repo:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        inherit ref;
        url = "https://github.com/${repo}.git";
      };
    };
in
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      (fromGitHub "HEAD" "jbyuki/nabla.nvim") # math rendering
      (fromGitHub "HEAD" "nvim-telescope/telescope-bibtex.nvim") # bibtex
      catppuccin-nvim # colorscheme
      cmp_luasnip # snippets completion
      cmp-nvim-lsp # lsp completion
      cmp-path # path completion
      copilot-vim # github copilot
      friendly-snippets # snippets
      gitsigns-nvim # git indicators
      iron-nvim # REPLs
      lazygit-nvim # lazygit integration
      lspkind-nvim # vscode-like pictograms
      luasnip # snippets
      markdown-preview-nvim # markdown preview
      mini-nvim # set of small plugins
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
      project-nvim # project management
      telescope-fzy-native-nvim # telescope fzy integration
      telescope-nvim # fuzzy finder
      telescope-ui-select-nvim # telescope ui
      todo-comments-nvim # todo comments
      todo-txt-vim # tasks
      twilight-nvim # dim inactive code
      undotree # undo history
      vim-fugitive # git integration
      vim-nix # nix stuff
      vim-tmux-navigator # tmux keybindings
      vim-visual-multi # multiple cursors
      which-key-nvim # keybindings
      zen-mode-nvim # zen mode
    ];
  };
}
