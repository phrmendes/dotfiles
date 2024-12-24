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
      vimPlugin = pname: src:
        pkgs.vimUtils.buildVimPlugin {
          inherit src pname;
          version = src.rev;
        };
      kitty-scrollback-nvim = vimPlugin "kitty-scrollback.nvim" inputs.kitty-scrollback-nvim;
      ltex-extra-nvim = vimPlugin "ltex_extra.nvim" inputs.ltex_extra-nvim;
      notes-nvim = vimPlugin "notes.nvim" inputs.notes-nvim;
    in {
      enable = true;
      package = pkgs.neovim-unwrapped;
      vimAlias = true;
      vimdiffAlias = true;
      withNodeJs = true;
      withPython3 = true;
      withRuby = false;
      plugins = with pkgs.vimPlugins; [
        CopilotChat-nvim
        SchemaStore-nvim
        ansible-vim
        blink-cmp
        blink-compat
        cmp-pandoc-nvim
        copilot-vim
        efmls-configs-nvim
        friendly-snippets
        fzfWrapper
        image-nvim
        img-clip-nvim
        kitty-scrollback-nvim
        lazydev-nvim
        ltex-extra-nvim
        markdown-nvim
        markdown-preview-nvim
        mini-nvim
        nabla-nvim
        notes-nvim
        nvim-bqf
        nvim-dap
        nvim-dap-go
        nvim-dap-python
        nvim-dap-ui
        nvim-dap-virtual-text
        nvim-lspconfig
        nvim-treesitter-context
        nvim-treesitter-textobjects
        nvim-treesitter.withAllGrammars
        nvim-ts-context-commentstring
        one-small-step-for-vimkind
        refactoring-nvim
        rest-nvim
        smart-splits-nvim
        snacks-nvim
        undotree
        vim-abolish
        vim-dadbod
        vim-dadbod-completion
        vim-dadbod-ui
        vim-eunuch
        vim-helm
        vim-sleuth
        vim-slime
      ];
      extraLuaPackages = luaPkgs:
        with luaPkgs; [
          magick
          mimetypes
          nui-nvim
          nvim-nio
          plenary-nvim
          tiktoken_core
        ];
      extraPython3Packages = pythonPkgs:
        with pythonPkgs; [debugpy];
      extraPackages = with pkgs;
        [
          alejandra
          ansible-language-server
          ansible-lint
          basedpyright
          bash-language-server
          delve
          djlint
          dockerfile-language-server-nodejs
          dot-language-server
          efm-langserver
          elixir-ls
          emmet-language-server
          gofumpt
          golangci-lint
          golines
          gopls
          hadolint
          helm-ls
          ltex-ls
          lua-language-server
          marksman
          neovim-remote
          nil
          ruff
          shellcheck
          shellharden
          stylua
          taplo
          terraform-ls
          texlab
          vscode-langservers-extracted
          yaml-language-server
        ]
        ++ (with nodePackages_latest; [
          prettier
          sql-formatter
          vscode-json-languageserver
        ]);
    };

    xdg.configFile = {
      "nvim" = {
        source = ../dotfiles/nvim;
        recursive = true;
      };
      "nvim/lua/paths/luvit-meta.lua".text = ''
        return "${pkgs.vimPlugins.luvit-meta}/library"
      '';
      "nvim/lua/base16.lua".text = with config.lib.stylix.colors.withHashtag; ''
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
