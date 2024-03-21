{
  inputs,
  pkgs,
  ...
}: let
  appendPackages = {
    toDarwin ? [],
    toNix ? [],
  }:
    if pkgs.stdenv.isDarwin
    then toDarwin
    else toNix;
  getNeovimPluginFromGitHub = pkgName: src:
    pkgs.vimUtils.buildVimPlugin {
      inherit src;
      pname = pkgName;
      version = src.rev;
    };
  gh = builtins.mapAttrs (name: input: getNeovimPluginFromGitHub name input) {
    inherit (inputs) cmp-pandoc-references telescope-zotero img-clip-nvim kitty-scrollback jupytext-nvim;
  };
  nix = {
    extensions = with pkgs.vimPlugins; [
      gh.telescope-zotero
      gh.cmp-pandoc-references
      ChatGPT-nvim
      cmp-latex-symbols
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
        auto-session
        better-escape-nvim
        catppuccin-nvim
        cmp-buffer
        cmp-cmdline
        cmp-nvim-lsp
        cmp-path
        cmp_luasnip
        conform-nvim
        copilot-vim
        diffview-nvim
        dressing-nvim
        friendly-snippets
        gh.img-clip-nvim
        gh.jupytext-nvim
        gh.kitty-scrollback
        gitsigns-nvim
        image-nvim
        indent-blankline-nvim
        lsp_signature-nvim
        lspkind-nvim
        ltex_extra-nvim
        luasnip
        markdown-preview-nvim
        mini-nvim
        neodev-nvim
        neogen
        neogit
        nvim-cmp
        nvim-colorizer-lua
        nvim-dap
        nvim-dap-python
        nvim-dap-ui
        nvim-dap-virtual-text
        nvim-lint
        nvim-lspconfig
        nvim-spectre
        nvim-treesitter-context
        nvim-treesitter-textobjects
        nvim-treesitter.withAllGrammars
        nvim-ts-autotag
        nvim-ts-context-commentstring
        nvim-web-devicons
        otter-nvim
        plenary-nvim
        quarto-nvim
        smart-splits-nvim
        smartyank-nvim
        sqlite-lua
        telescope-fzf-native-nvim
        telescope-nvim
        telescope-zoxide
        todo-comments-nvim
        toggleterm-nvim
        trouble-nvim
        undotree
        vim-abolish
        vim-eunuch
        vim-helm
        vim-jinja
        vim-just
        vim-nix
        vim-sleuth
        vim-visual-multi
        which-key-nvim
        zen-mode-nvim
      ])
      ++ appendPackages {
        toNix = nix.extensions;
      };
    extraPython3Packages = pyPkgs:
      with pyPkgs; [
        pynvim
        jupytext
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
        dot-language-server
        helm-ls
        imagemagick
        ltex-ls
        lua-language-server
        marksman
        md-tangle
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
      ]);
  };
}
