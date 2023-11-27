{
  pkgs,
  pkgs-stable,
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
  obsidian-nvim = fromGitHub "5d022cc1d53a40f09902f2e34df3d604d2f2707b" "HEAD" "epwalsh/obsidian.nvim";
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
      ansible-vim
      catppuccin-nvim
      cmp-buffer
      cmp-latex-symbols
      cmp-nvim-lsp
      cmp-pandoc-nvim
      cmp-path
      cmp-zotcite
      cmp_luasnip
      conform-nvim
      copilot-cmp
      copilot-lua
      dressing-nvim
      executor-nvim
      friendly-snippets
      gitsigns-nvim
      image-nvim
      lazygit-nvim
      lsp_signature-nvim
      lspkind-nvim
      ltex_extra-nvim
      luasnip
      markdown-preview-nvim
      mini-nvim
      nabla-nvim
      neodev-nvim
      neogen
      neotest
      neotest-python
      neotest-scala
      nui-nvim
      nvim-cmp
      nvim-dap
      nvim-dap-python
      nvim-dap-ui
      nvim-dap-virtual-text
      nvim-lightbulb
      nvim-lint
      nvim-lspconfig
      nvim-luadev
      nvim-metals
      nvim-spectre
      nvim-treesitter-context
      nvim-treesitter-textobjects
      nvim-treesitter.withAllGrammars
      nvim-ts-context-commentstring
      nvim-web-devicons
      obsidian-nvim
      otter-nvim
      plenary-nvim
      popup-nvim
      quarto-nvim
      telescope-nvim
      telescope-ui-select-nvim
      telescope-zoxide
      trouble-nvim
      undotree
      vim-helm
      vim-jinja
      vim-nix
      vim-sleuth
      vim-slime
      vim-tmux-navigator
      vim-visual-multi
      which-key-nvim
      zen-mode-nvim
      zotcite
    ];
    extraPython3Packages = pyPkgs:
      with pyPkgs; [
        poppler-qt5
        pynvim
        pyqt5
        pyyaml
      ];
    extraLuaPackages = luaPkgs:
      with luaPkgs; [
        magick
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
        metals
        nil
        perl538Packages.LatexIndent
        ruff
        ruff-lsp
        scalafmt
        shellcheck
        shellharden
        statix
        stylua
        taplo
        terraform-ls
        texlab
      ])
      ++ (with pkgs-stable.nodePackages; [
        bash-language-server
        dockerfile-language-server-nodejs
        prettier
        pyright
        vscode-json-languageserver
        yaml-language-server
      ]);
  };
}
