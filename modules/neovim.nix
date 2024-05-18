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
        inherit (inputs) cmp-zotcite gopher-nvim latex-snippets-nvim telescope-zotero zotcite neotest-golang;
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
          diffview-nvim
          dressing-nvim
          executor-nvim
          friendly-snippets
          gh.gopher-nvim
          gh.latex-snippets-nvim
          gh.neotest-golang
          gh.telescope-zotero
          image-nvim
          jupytext-nvim
          lsp_signature-nvim
          lspkind-nvim
          ltex_extra-nvim
          luasnip
          markdown-preview-nvim
          mini-nvim
          nabla-nvim
          neodev-nvim
          neogen
          neogit
          neotest
          neotest-python
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
          nvim-treesitter-context
          nvim-treesitter-textobjects
          nvim-treesitter.withAllGrammars
          nvim-ts-autotag
          nvim-ts-context-commentstring
          nvim-web-devicons
          otter-nvim
          plenary-nvim
          quarto-nvim
          rest-nvim
          smart-splits-nvim
          smartyank-nvim
          sqlite-lua
          telescope-dap-nvim
          telescope-fzf-native-nvim
          telescope-nvim
          telescope-zoxide
          todo-comments-nvim
          undotree
          vim-abolish
          vim-dadbod
          vim-dadbod-completion
          vim-dadbod-ui
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
          lua-curl
          magick
          mimetypes
          nvim-nio
          rest-nvim
          xml2lua
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
          golines
          gomodifytags
          gopls
          gotests
          helm-ls
          iferr
          imagemagick
          impl
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
        ++ (with pkgs.python312Packages; [
          jupytext
        ])
        ++ (with pkgs.nodePackages; [
          bash-language-server
          vscode-json-languageserver
        ]);
    };
  };
}
