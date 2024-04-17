{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options.neovim.enable = lib.mkEnableOption "enable neovim";

  config = lib.mkIf config.neovim.enable {
    programs.neovim = let
      getNeovimPluginFromGitHub = pname: src:
        pkgs.vimUtils.buildVimPlugin {
          inherit src pname;
          version = src.rev;
        };
      gh = builtins.mapAttrs (pname: src: getNeovimPluginFromGitHub pname src) {
        inherit (inputs) telescope-zotero copilot-chat-nvim latex-snippets-nvim;
      };
    in {
      enable = true;
      package = pkgs.neovim-unwrapped;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      plugins = with pkgs.vimPlugins; [
        SchemaStore-nvim
        actions-preview-nvim
        ansible-vim
        better-escape-nvim
        catppuccin-nvim
        cmp-buffer
        cmp-cmdline
        cmp-nvim-lsp
        cmp-pandoc-nvim
        cmp-path
        cmp_luasnip
        conform-nvim
        copilot-vim
        dressing-nvim
        friendly-snippets
        cmp-latex-symbols
        gh.copilot-chat-nvim
        gh.latex-snippets-nvim
        gh.telescope-zotero
        gitsigns-nvim
        image-nvim
        indent-blankline-nvim
        jupytext-nvim
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
        nvim-tree-lua
        nvim-treesitter-context
        nvim-treesitter-textobjects
        nvim-treesitter.withAllGrammars
        nvim-ts-autotag
        nvim-ts-context-commentstring
        nvim-web-devicons
        obsidian-nvim
        otter-nvim
        plenary-nvim
        quarto-nvim
        smart-splits-nvim
        smartyank-nvim
        sqlite-lua
        telescope-fzf-native-nvim
        telescope-nvim
        todo-comments-nvim
        trouble-nvim
        undotree
        vim-abolish
        vim-eunuch
        vim-helm
        vim-jinja
        vim-just
        vim-nix
        vim-sleuth
        vim-slime
        vim-visual-multi
        which-key-nvim
        zen-mode-nvim
      ];
      extraLuaPackages = luaPkgs:
        with luaPkgs; [
          magick
          tiktoken_core
        ];
      extraPackages =
        (with pkgs; [
          alejandra
          ansible-language-server
          ansible-lint
          djlint
          docker-compose-language-service
          dot-language-server
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
        ])
        ++ (with pkgs.python312Packages; [
          debugpy
          jupytext
          pynvim
        ]);
    };
  };
}
