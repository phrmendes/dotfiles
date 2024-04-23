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
      inherit (pkgs.stdenv) isDarwin;
      getNeovimPluginFromGitHub = pname: src:
        pkgs.vimUtils.buildVimPlugin {
          inherit src pname;
          version = src.rev;
        };
      gh = builtins.mapAttrs (pname: src: getNeovimPluginFromGitHub pname src) {
        inherit (inputs) telescope-zotero copilot-chat-nvim latex-snippets-nvim zotcite cmp-zotcite;
      };
      plugins =
        if ! isDarwin
        then
          with pkgs.vimPlugins; [
            cmp-latex-symbols
            cmp-pandoc-nvim
            nabla-nvim
            obsidian-nvim
            gh.cmp-zotcite
            gh.latex-snippets-nvim
            gh.telescope-zotero
            gh.zotcite
          ]
        else [];
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
          cmp-nvim-lsp
          cmp-path
          cmp_luasnip
          conform-nvim
          copilot-vim
          dressing-nvim
          friendly-snippets
          gh.copilot-chat-nvim
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
        ++ plugins;
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
          marksman
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
