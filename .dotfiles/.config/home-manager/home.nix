{ config, pkgs, lib, ... }:

let
  user = "phrmendes";
in {
  home = {
    username = "${user}";
    homeDirectory = "/home/${user}";
    packages = with pkgs; [
      asdf-vm
      bitwarden
      btop
      exa
      fragments
      gh
      hugo
      lazygit
      obsidian
      pandoc
      pcloud
      podman
      quarto
      ripgrep
      spotify
      tectonic
      vlc
      vscode
      zotero
    ];
    stateVersion = "22.11";
    sessionVariables = {
      VISUAL = "nvim";
      TERMINAL = "alacritty";
      SUDO_EDITOR = "nvim";
    };
  };
  programs = {
    home-manager.enable = true;
    bat.enable = true;
    fzf = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      shellAliases = {
        cat = "${pkgs.bat}/bin/bat";
        la = "${pkgs.exa}/bin/exa --icons -a";
        lg = "${pkgs.lazygit}/bin/lazygit";
        ll = "${pkgs.exa}/bin/exa --icons -l";
        lla = "${pkgs.exa}/bin/exa --icons -la";
        ls = "${pkgs.exa}/bin/exa --icons";
        lt = "${pkgs.exa}/bin/exa --icons --tree";
        mkdir = "mkdir -p";
        rcat = "cat";
        stow_dotfiles = ''
          stow --target="/home/${user}" --dir="/home/${user}/Projects/bkps/" --stow .dotfiles'';
        nix_update = "home-manager switch";
        nix_clean = "nix-collect-garbage";
      };
    };
    neovim = {
      enable = true;
      withPython3 = true;
      package = pkgs.neovim-unwrapped;
      extraLuaConfig = builtins.readFile /home/${user}/.config/nvim/settings.lua;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [
        (nvim-treesitter.withPlugins (p: [
          p.bash
          p.dockerfile
          p.gitignore
          p.json
          p.latex
          p.lua
          p.markdown
          p.markdown-inline
          p.nix
          p.python
          p.hcl
          p.vim
          p.yaml
        ]))
        ReplaceWithRegister
        alpha-nvim
        auto-pairs
        cmp-nvim-lsp
        cmp-path
        cmp_luasnip
        copilot-vim
        friendly-snippets
        gitsigns-nvim
        indent-blankline-nvim
        lazygit-nvim
        lspkind-nvim
        lualine-nvim
        luasnip
        markdown-preview-nvim
        mini-nvim
        neoterm
        null-ls-nvim
        nvim-cmp
        nvim-dap
        nvim-lspconfig
        nvim-spectre
        nvim-tree-lua
        nvim-web-devicons
        plenary-nvim
        tagbar
        telescope-dap-nvim
        telescope-fzf-native-nvim
        telescope-nvim
        telescope-ui-select-nvim
        tokyonight-nvim
        trouble-nvim
        undotree
        vim-commentary
        vim-gitgutter
        vim-illuminate
        vim-nix
        vim-tmux-navigator
        vim-visual-multi
        which-key-nvim
      ];
      extraPackages = (with pkgs; [
        jq
        lua-language-server
        luajitPackages.luacheck
        nixfmt
        rnix-lsp
        shellcheck
        shfmt
        stylua
        terraform-ls
        universal-ctags
      ]) ++ (with pkgs.nodePackages; [
        bash-language-server
        dockerfile-language-server-nodejs
        prettier
      ]);
    };
    alacritty = {
      enable = true;
      settings = {
        window = {
          padding = {
            x = 10;
            y = 10;
          };
          class = {
            instance = "Alacritty";
            general = "Alacritty";
          };
          opacity = 1;
          decorations = "none";
        };
        scrolling = {
          history = 10000;
          multiplier = 3;
        };
        colors = {
          primary = {
            background = "0x1a1b26";
            foreground = "0xc0caf5";
          };
          normal = {
            black = "0x15161e";
            red = "0xf7768e";
            green = "0x9ece6a";
            yellow = "0xe0af68";
            blue = "0x7aa2f7";
            magenta = "0xbb9af7";
            cyan = "0x7dcfff";
            white = "0xa9b1d6";
          };
          bright = {
            black = "0x414868";
            red = "0xf7768e";
            green = "0x9ece6a";
            yellow = "0xe0af68";
            blue = "0x7aa2f7";
            magenta = "0xbb9af7";
            cyan = "0x7dcfff";
            white = "0xc0caf5";
          };
        };
        font = {
          normal = {
            family = "SauceCodePro Nerd Font";
            style = "Medium";
          };
          bold = {
            family = "SauceCodePro Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "SauceCodePro Nerd Font";
            style = "MediumItalic";
          };
          bold_italic = {
            family = "SauceCodePro Nerd Font";
            style = "BoldItalic";
          };
          size = 11;
        };
        draw_bold_text_with_bright_colors = true;
        selection.save_to_clipboard = true;
        shell.program = "${pkgs.zsh}/bin/zsh";
      };
    };
    starship = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      settings = (builtins.fromTOML
        (builtins.readFile /home/${user}/.config/starship/config.toml));
    };
  };
  xdg = {
    enable = true;
    mime.enable = true;
  };
  targets.genericLinux.enable = true;
}