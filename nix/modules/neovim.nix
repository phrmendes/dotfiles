{
  pkgs,
  lib,
  ...
}: let
  fromGitHub = rev: ref: repo:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        inherit ref rev;
        url = "https://github.com/${repo}.git";
      };
    };
  cmp-zotcite = fromGitHub "fd83f05495c14ed7d3d1ae898400622137b01fa2" "HEAD" "jalvesaq/cmp-zotcite";
  obsidian-nvim = fromGitHub "16d780e23eccfe73395b5ae94293d28ad8c53a32" "HEAD" "epwalsh/obsidian.nvim";
  vim-ansible = fromGitHub "afc739e505053a6143a1fc6cedac6fb4d7a1d4db" "HEAD" "pearofducks/ansible-vim";
  zotcite = fromGitHub "c93519e681a08ff29fdc8910b96aee9a99100f07" "HEAD" "jalvesaq/zotcite";
in {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    plugins = with pkgs.vimPlugins; [
      ChatGPT-nvim
      catppuccin-nvim
      cmp-buffer
      cmp-latex-symbols
      cmp-nvim-lsp
      cmp-pandoc-nvim
      cmp-path
      cmp-zotcite
      cmp_luasnip
      conform-nvim # formatting
      copilot-vim
      dressing-nvim
      executor-nvim # run async jobs
      friendly-snippets
      gitsigns-nvim
      lazygit-nvim
      lsp_signature-nvim # lsp signature hint as you type
      lspkind-nvim # vscode-like pictograms
      ltex_extra-nvim # ltex-ls aditional options
      luasnip
      markdown-preview-nvim
      mini-nvim
      nabla-nvim # equation preview
      neodev-nvim # lua lsp dev tools
      neogen # auto-generate docs
      neotest
      neotest-python
      neotest-scala
      nui-nvim # ui component lib
      nvim-cmp
      nvim-dap
      nvim-dap-python
      nvim-dap-ui
      nvim-dap-virtual-text
      nvim-lightbulb # show code actions
      nvim-lint
      nvim-lspconfig
      nvim-metals
      nvim-spectre # search and replace
      nvim-treesitter-context
      nvim-treesitter-textobjects
      nvim-treesitter.withAllGrammars
      nvim-ts-context-commentstring
      nvim-web-devicons
      obsidian-nvim
      otter-nvim # code completion for code embedded in documents
      plenary-nvim # lua utils
      popup-nvim
      quarto-nvim
      telescope-nvim
      telescope-ui-select-nvim
      telescope-zoxide
      trouble-nvim # lsp diagnostics
      undotree
      vim-ansible
      vim-helm
      vim-jinja
      vim-nix
      vim-sleuth # auto detect indentation
      vim-slime # REPLs
      vim-tmux-navigator # tmux keybindings
      vim-visual-multi # multiple cursors
      which-key-nvim
      zen-mode-nvim # zen mode
      zotcite
    ];
    extraPython3Packages = pyPkgs:
      with pyPkgs; [
        poppler-qt5
        pynvim
        pyqt5
        pyyaml
      ];
    extraPackages =
      (with pkgs; [
        alejandra
        ansible-language-server
        ansible-lint
        docker-compose-language-service
        helm-ls
        ltex-ls
        lua-language-server
        nil
        perl538Packages.LatexIndent
        ruff
        ruff-lsp
        shellcheck
        shellharden
        statix
        stylua
        taplo
        terraform-ls
        texlab
      ])
      ++ (with pkgs.nodePackages; [
        bash-language-server
        dockerfile-language-server-nodejs
        pyright
        vscode-json-languageserver
        yaml-language-server
        prettier
      ]);
  };
}
