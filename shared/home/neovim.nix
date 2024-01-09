{
  inputs,
  pkgs,
  ...
}: let
  appendPackages = {
    to_nix,
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
    cmp-zotcite = inputs.cmp-zotcite;
    zotcite = inputs.zotcite;
    img-clip-nvim = inputs.img-clip-nvim;
    autolist-nvim = inputs.autolist-nvim;
    yaml-companion-nvim = inputs.yaml-companion-nvim;
  };
  darwin = {
    packages = with pkgs; [
      marksman
    ];
  };
  nix = {
    packages = with pkgs; [
      htmx-lsp
      tailwindcss-language-server
    ];
    extensions = with pkgs.vimPlugins; [
      gh.cmp-zotcite
      gh.zotcite
      nvim-metals
      ChatGPT-nvim
      cmp-latex-symbols
      cmp-pandoc-nvim
      nabla-nvim
      nvim-colorizer-lua
      obsidian-nvim
      otter-nvim
      quarto-nvim
      nvim-ts-autotag
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
        gh.autolist-nvim
        gh.img-clip-nvim
        gh.yaml-companion-nvim
        SchemaStore-nvim
        actions-preview-nvim
        ansible-vim
        catppuccin-nvim
        cmp-buffer
        cmp-cmdline
        cmp-emoji
        cmp-nvim-lsp
        cmp-path
        cmp_luasnip
        conform-nvim
        copilot-vim
        dressing-nvim
        executor-nvim
        friendly-snippets
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
        neo-tree-nvim
        neodev-nvim
        neogen
        nvim-cmp
        nvim-dap
        nvim-dap-go
        nvim-dap-python
        nvim-dap-ui
        nvim-dap-virtual-text
        nvim-lint
        nvim-lspconfig
        nvim-spectre
        nvim-treesitter-context
        nvim-treesitter-textobjects
        nvim-treesitter.withAllGrammars
        nvim-ts-context-commentstring
        nvim-web-devicons
        octo-nvim
        plenary-nvim
        smartyank-nvim
        telescope-frecency-nvim
        telescope-fzf-native-nvim
        telescope-nvim
        telescope-zoxide
        todo-comments-nvim
        trouble-nvim
        undotree
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
        djlint
        gofumpt
        goimports-reviser
        golines
        gopls
        helm-ls
        imagemagick
        ltex-ls
        lua-language-server
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
      ++ (with pkgs.nodePackages; [
        bash-language-server
        dockerfile-language-server-nodejs
        prettier
        pyright
        vscode-json-languageserver
        vscode-langservers-extracted
        yaml-language-server
      ])
      ++ appendPackages {
        to_nix = nix.packages;
        to_darwin = darwin.packages;
      };
  };
}
