{
  inputs,
  pkgs,
  pkgs-stable,
  ...
}: let
  pluginFromGitHub = pname: src:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.rev;
    };
  cmp-zotcite = pluginFromGitHub "cmp-zotcite" inputs.cmp-zotcite;
  obsidian-nvim = pluginFromGitHub "obsidian.nvim" inputs.obsidian-nvim;
  zotcite = pluginFromGitHub "zotcite" inputs.zotcite;
  jupytext-vim = pluginFromGitHub "jupytext-vim" inputs.jupytext-vim;
  lsp-progress-nvim = pluginFromGitHub "lsp-progress.nvim" inputs.lsp-progress-nvim;
  desktop_packages = with pkgs.vimPlugins; [
    ChatGPT-nvim
    cmp-zotcite
    obsidian-nvim
    zotcite
  ];
in {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
    withPython3 = true;
    plugins =
      (with pkgs.vimPlugins; [
        ansible-vim
        barbecue-nvim
        bullets-vim
        catppuccin-nvim
        cmp-buffer
        cmp-cmdline
        cmp-latex-symbols
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help
        cmp-pandoc-nvim
        cmp-path
        cmp_luasnip
        conform-nvim
        copilot-vim
        dressing-nvim
        executor-nvim
        friendly-snippets
        gitsigns-nvim
        image-nvim
        jupytext-vim
        lazygit-nvim
        lsp-progress-nvim
        lsp_signature-nvim
        lspkind-nvim
        ltex_extra-nvim
        lualine-nvim
        luasnip
        mini-nvim
        nabla-nvim
        neo-tree-nvim
        neodev-nvim
        neogen
        nvim-cmp
        nvim-dap
        nvim-dap-python
        nvim-dap-ui
        nvim-dap-virtual-text
        nvim-lightbulb
        nvim-lint
        nvim-lspconfig
        nvim-luadev
        nvim-spectre
        nvim-treesitter-context
        nvim-treesitter-textobjects
        nvim-treesitter.withAllGrammars
        nvim-ts-context-commentstring
        nvim-web-devicons
        otter-nvim
        plenary-nvim
        quarto-nvim
        smartyank-nvim
        telescope-nvim
        telescope-zoxide
        todo-comments-nvim
        trouble-nvim
        undotree
        vim-helm
        vim-jinja
        vim-just
        vim-nix
        vim-sleuth
        vim-slime
        vim-table-mode
        vim-tmux-navigator
        vim-visual-multi
        which-key-nvim
        zen-mode-nvim
      ])
      ++ (with pkgs-stable.vimPlugins; [
        markdown-preview-nvim
      ])
      ++ (
        if pkgs.stdenv.isDarwin
        then []
        else desktop_packages
      );
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
        marksman
        neovim-remote
        nil
        ruff
        ruff-lsp
        shellcheck
        shellharden
        sqlfluff
        statix
        stylua
        taplo
        terraform-ls
        texlab
      ])
      ++ (with pkgs.perl538Packages; [
        LatexIndent
      ])
      ++ (with pkgs-stable.nodePackages; [
        bash-language-server
        dockerfile-language-server-nodejs
        pyright
        sql-formatter
        vscode-json-languageserver
        yaml-language-server
        prettier
      ]);
  };
}
