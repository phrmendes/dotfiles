{
  inputs,
  pkgs,
  ...
}: let
  appendPackages = {
    to_nix ? [],
    to_darwin ? [],
  }:
    if ! pkgs.stdenv.isDarwin
    then to_nix
    else to_darwin;
  getNeovimPluginFromGitHub = pkgName: src:
    pkgs.vimUtils.buildVimPlugin {
      inherit src;
      pname = pkgName;
      version = src.rev;
    };
  gh = builtins.mapAttrs (name: input: getNeovimPluginFromGitHub name input) {
    autolist-nvim = inputs.autolist-nvim;
    cmp-zotcite = inputs.cmp-zotcite;
    img-clip-nvim = inputs.img-clip-nvim;
    zotcite = inputs.zotcite;
    mdeval-nvim = inputs.mdeval-nvim;
  };
  nix = {
    packages = with pkgs; [
      htmx-lsp
      tailwindcss-language-server
    ];
    extensions = with pkgs.vimPlugins; [
      ChatGPT-nvim
      gh.cmp-zotcite
      gh.zotcite
      obsidian-nvim
    ];
  };
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
        SchemaStore-nvim
        actions-preview-nvim
        ansible-vim
        better-escape-nvim
        catppuccin-nvim
        cmp-buffer
        cmp-cmdline
        cmp-emoji
        cmp-latex-symbols
        cmp-nvim-lsp
        cmp-pandoc-nvim
        cmp-path
        cmp_luasnip
        conform-nvim
        copilot-vim
        debugprint-nvim
        dressing-nvim
        friendly-snippets
        gh.autolist-nvim
        gh.img-clip-nvim
        gh.mdeval-nvim
        gitsigns-nvim
        image-nvim
        lazygit-nvim
        lsp_signature-nvim
        lspkind-nvim
        ltex_extra-nvim
        lualine-nvim
        luasnip
        markdown-preview-nvim
        mini-nvim
        nabla-nvim
        neo-tree-nvim
        neodev-nvim
        neogen
        nvim-cmp
        nvim-colorizer-lua
        nvim-dap
        nvim-dap-go
        nvim-dap-python
        nvim-dap-ui
        nvim-dap-virtual-text
        nvim-lint
        nvim-lspconfig
        nvim-metals
        nvim-spectre
        nvim-treesitter-context
        nvim-treesitter-textobjects
        nvim-treesitter.withAllGrammars
        nvim-ts-autotag
        nvim-ts-context-commentstring
        nvim-web-devicons
        octo-nvim
        otter-nvim
        plenary-nvim
        quarto-nvim
        smartyank-nvim
        telescope-fzf-native-nvim
        telescope-nvim
        telescope-zoxide
        todo-comments-nvim
        trouble-nvim
        undotree
        vim-abolish
        vim-eunuch
        vim-helm
        vim-jinja
        vim-just
        vim-kitty-navigator
        vim-nix
        vim-sleuth
        vim-slime
        vim-visual-multi
        which-key-nvim
        zen-mode-nvim
      ])
      ++ appendPackages {
        to_nix = nix.extensions;
      };
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
        djlint
        docker-compose-language-service
        gofumpt
        goimports-reviser
        golines
        gopls
        helm-ls
        imagemagick
        ltex-ls
        lua-language-server
        md-tangle
        neovim-remote
        nixd
        prettierd
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
        tflint
      ])
      ++ (with pkgs.perl538Packages; [
        LatexIndent
      ])
      ++ (with pkgs.nodePackages; [
        bash-language-server
        dockerfile-language-server-nodejs
        pyright
        vscode-json-languageserver
        vscode-langservers-extracted
        yaml-language-server
      ])
      ++ appendPackages {
        to_nix = nix.packages;
      };
  };
}
