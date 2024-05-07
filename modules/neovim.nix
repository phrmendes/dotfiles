{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  options.neovim.enable = lib.mkEnableOption "enable neovim";

  config = lib.mkIf config.neovim.enable {
    home.file = {
      ".config/nvim" = {
        source = ../dotfiles/nvim;
        recursive = true;
      };
    };

    programs.neovim = let
      inherit (pkgs.stdenv) isLinux;
      fromGitHub = pname: src:
        pkgs.vimUtils.buildVimPlugin {
          inherit src pname;
          version = src.rev;
        };
      gh = builtins.mapAttrs (pname: src: fromGitHub pname src) {
        inherit (inputs) copilot-chat-nvim latex-snippets-nvim telescope-zotero cmp-zotcite zotcite;
      };
    in {
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
          dressing-nvim
          friendly-snippets
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
          nvim-bqf
          nvim-cmp
          nvim-colorizer-lua
          nvim-dap
          nvim-dap-go
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
          trouble-nvim
          undotree
          vim-abolish
          vim-eunuch
          vim-helm
          vim-jinja
          vim-just
          vim-sleuth
          vim-slime
          vim-visual-multi
          which-key-nvim
          zen-mode-nvim
        ])
        ++ lib.optionals isLinux (
          with pkgs.vimPlugins; [
            obsidian-nvim
            gh.cmp-zotcite
            gh.zotcite
          ]
        );
      extraLuaPackages = luaPkgs:
        with luaPkgs; [
          jsregexp
          magick
          tiktoken_core
        ];
      extraPython3Packages = pythonPkgs:
        with pythonPkgs; [
          debugpy
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
          delve
          djlint
          docker-compose-language-service
          dockerfile-language-server-nodejs
          dot-language-server
          gofumpt
          goimports-reviser
          golangci-lint
          gopls
          helm-ls
          imagemagick
          ltex-ls
          lua-language-server
          marksman
          neovim-remote
          nil
          prettierd
          pyright
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
          vscode-langservers-extracted
          yaml-language-server
        ])
        ++ (with pkgs.perl538Packages; [
          LatexIndent
        ])
        ++ (with pkgs.nodePackages; [
          bash-language-server
          vscode-json-languageserver
        ])
        ++ (with pkgs.python312Packages; [
          jupytext
        ]);
    };
  };
}
