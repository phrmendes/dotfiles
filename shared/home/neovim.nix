{
  inputs,
  pkgs,
  ...
}: let
  appendPackages = {
    to_darwin ? [],
    to_nix ? [],
  }:
    if pkgs.stdenv.isDarwin
    then to_darwin
    else to_nix;
  getNeovimPluginFromGitHub = pkgName: src:
    pkgs.vimUtils.buildVimPlugin {
      inherit src;
      pname = pkgName;
      version = src.rev;
    };
  gh = builtins.mapAttrs (name: input: getNeovimPluginFromGitHub name input) {
    inherit (inputs) cmp-zotcite zotcite mdeval-nvim obsidian-nvim;
  };
  nix = {
    extensions = with pkgs.vimPlugins; [
      gh.cmp-zotcite
      gh.zotcite
      gh.obsidian-nvim
      ChatGPT-nvim
    ];
  };
in {
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;
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
        cmp-latex-symbols
        cmp-nvim-lsp
        cmp-pandoc-nvim
        cmp-path
        cmp_luasnip
        conform-nvim
        copilot-vim
        dressing-nvim
        friendly-snippets
        gh.mdeval-nvim
        gitsigns-nvim
        image-nvim
        indent-blankline-nvim
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
        octo-nvim
        otter-nvim
        plenary-nvim
        quarto-nvim
        smartyank-nvim
        tabular
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
        vim-markdown
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
        helm-ls
        imagemagick
        ltex-ls
        lua-language-server
        marksman
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
      ]);
  };
}
