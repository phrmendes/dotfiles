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
  desktop_packages = with pkgs.vimPlugins; [
    ChatGPT-nvim
    cmp-latex-symbols
    cmp-pandoc-nvim
    cmp-zotcite
    image-nvim
    nabla-nvim
    obsidian-nvim
    otter-nvim
    quarto-nvim
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
        catppuccin-nvim
        cmp-buffer
        cmp-nvim-lsp
        cmp-path
        cmp_luasnip
        conform-nvim
        copilot-vim
        dressing-nvim
        executor-nvim
        flash-nvim
        friendly-snippets
        gitsigns-nvim
        lazygit-nvim
        lsp_signature-nvim
        lspkind-nvim
        ltex_extra-nvim
        luasnip
        mini-nvim
        neodev-nvim
        neogen
        nui-nvim
        nvim-cmp
        nvim-dap
        nvim-dap-go
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
        plenary-nvim
        popup-nvim
        telescope-nvim
        telescope-ui-select-nvim
        telescope-zoxide
        todo-comments-nvim
        trouble-nvim
        undotree
        vim-helm
        vim-jinja
        vim-markdown-composer
        vim-nix
        vim-sleuth
        vim-slime
        vim-tmux-navigator
        vim-visual-multi
        which-key-nvim
        zen-mode-nvim
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
        delve
        docker-compose-language-service
        gofumpt
        goimports-reviser
        golangci-lint
        golines
        gopls
        helm-ls
        ltex-ls
        lua-language-server
        neovim-remote
        nil
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
      ++ (with pkgs.perl538Packages; [
        LatexIndent
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
