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
      fromGitHub = pname: src:
        pkgs.vimUtils.buildVimPlugin {
          inherit src pname;
          version = src.rev;
        };
      luasnip-latex-snippets = fromGitHub "luasnip-latex-snippets" inputs.luasnip-latex-snippets;
      kulala-nvim = fromGitHub "kulala.nvim" inputs.kulala-nvim;
    in {
      enable = true;
      package = pkgs.neovim-unwrapped;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = false;
      plugins =
        (with pkgs.vimPlugins; [
          SchemaStore-nvim
          ansible-vim
          better-escape-nvim
          cmp-buffer
          cmp-cmdline
          cmp-dap
          cmp-emoji
          cmp-latex-symbols
          cmp-nvim-lsp
          cmp-nvim-lsp-signature-help
          cmp-pandoc-nvim
          cmp-path
          cmp_luasnip
          copilot-cmp
          copilot-lua
          dial-nvim
          dressing-nvim
          efmls-configs-nvim
          executor-nvim
          friendly-snippets
          fzfWrapper
          image-nvim
          lazygit-nvim
          lspkind-nvim
          ltex_extra-nvim
          luasnip
          markdown-nvim
          markdown-preview-nvim
          mini-nvim
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
          nvim-lspconfig
          nvim-metals
          nvim-pqf
          nvim-treesitter-context
          nvim-treesitter-textobjects
          nvim-treesitter.withAllGrammars
          nvim-ts-autotag
          nvim-ts-context-commentstring
          obsidian-nvim
          otter-nvim
          quarto-nvim
          refactoring-nvim
          smart-splits-nvim
          twilight-nvim
          undotree
          vim-abolish
          vim-dadbod
          vim-dadbod-completion
          vim-dadbod-ui
          vim-eunuch
          vim-helm
          vim-jinja
          vim-rsi
          vim-sleuth
          vim-slime
          yanky-nvim
          zen-mode-nvim
        ])
        ++ [
          kulala-nvim
          luasnip-latex-snippets
        ];
      extraLuaPackages = luaPkgs:
        with luaPkgs; [
          jsregexp
          magick
          nui-nvim
          plenary-nvim
          sqlite
        ];
      extraPython3Packages = pythonPkgs:
        with pythonPkgs; [
          debugpy
          pynvim
        ];
      extraPackages =
        (with pkgs; [
          alejandra
          ansible-language-server
          ansible-lint
          autotools-language-server
          basedpyright
          bash-language-server
          dockerfile-language-server-nodejs
          dot-language-server
          efm-langserver
          emmet-language-server
          hadolint
          helm-ls
          imagemagick
          ltex-ls
          lua-language-server
          metals
          neovim-remote
          nixd
          ruff
          scalafix
          scalafmt
          shellcheck
          shellharden
          sqlfluff
          stylua
          taplo
          terraform-ls
          texlab
          tflint
          ueberzugpp
          vscode-langservers-extracted
          yaml-language-server
        ])
        ++ (with pkgs.nodePackages; [
          prettier
          vscode-json-languageserver
        ]);
    };

    home.file = {
      ".config/nvim" = {
        source = ../dotfiles/nvim;
        recursive = true;
      };
      ".config/nvim/lua/base16.lua".text = with config.lib.stylix.colors.withHashtag;
      /*
      lua
      */
        ''
          return {
              palette = {
                  base00 = "${base00}",
                  base01 = "${base01}",
                  base02 = "${base02}",
                  base03 = "${base03}",
                  base04 = "${base04}",
                  base05 = "${base05}",
                  base06 = "${base06}",
                  base07 = "${base07}",
                  base08 = "${base08}",
                  base09 = "${base09}",
                  base0A = "${base0A}",
                  base0B = "${base0B}",
                  base0C = "${base0C}",
                  base0D = "${base0D}",
                  base0E = "${base0E}",
                  base0F = "${base0F}",
              },
          }
        '';
    };
  };
}
