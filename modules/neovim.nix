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
      inherit (pkgs.stdenv) isDarwin;
      getNeovimPluginFromGitHub = pname: src:
        pkgs.vimUtils.buildVimPlugin {
          inherit src pname;
          version = src.rev;
        };
      gh = builtins.mapAttrs (pname: src: getNeovimPluginFromGitHub pname src) {
        inherit (inputs) copilot-chat-nvim img-clip-nvim latex-snippets-nvim telescope-zotero cmp-zotcite zotcite;
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
          gh.img-clip-nvim
          gh.latex-snippets-nvim
          gh.telescope-zotero
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
          mkdnflow-nvim
          nabla-nvim
          neodev-nvim
          neogen
          nvim-bqf
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
          orgmode
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
          vim-nix
          vim-sleuth
          vim-slime
          vim-visual-multi
          which-key-nvim
          zen-mode-nvim
        ])
        ++ (
          if isDarwin
          then []
          else
            with pkgs.vimPlugins; [
              gh.cmp-zotcite
              gh.zotcite
            ]
        );
      extraLuaPackages = luaPkgs:
        with luaPkgs; [
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
          djlint
          docker-compose-language-service
          dot-language-server
          helm-ls
          imagemagick
          ltex-ls
          lua-language-server
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
  };
}
