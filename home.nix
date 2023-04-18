{ config, pkgs, lib, ... }:

let
  user = "phrmendes";
  fromGitHub = ref: repo:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
      };
    };
in {
  home-manager.users.${user} = {
    home = {
      username = "${user}";
      homeDirectory = "/home/${user}";
      packages = (with pkgs.unstable; [
        adw-gtk3
        bitwarden
        btop
        vscode
        drawing
        droidcam
        exa
        firefox
        gh
        hugo
        lazygit
        obsidian
        pandoc
        quarto
        ripgrep
        spotify
        sqlite
        stow
        vscode
        zotero
      ]) ++ (with pkgs; [
        baobab
        fragments
        gnome-photos
        gnome-text-editor
        gnome.evince
        gnome.geary
        pcloud
        tectonic
        vlc
      ]) ++ (with pkgs.unstable.gnomeExtensions; [
        appindicator
        clipboard-history
        espresso
        forge
        lightdark-theme-switcher
        space-bar
        unite
      ]);
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
          mkdir = "mkdir -p";
          cat = "${pkgs.bat}/bin/bat";
          lg = "${pkgs.lazygit}/bin/lazygit";
          ld = "${pkgs.lazydocker}/bin/lazydocker";
          ls = "${pkgs.exa}/bin/exa --icons";
          ll = "${pkgs.exa}/bin/exa --icons -l";
          la = "${pkgs.exa}/bin/exa --icons -a";
          lt = "${pkgs.exa}/bin/exa --icons --tree";
          lla = "${pkgs.exa}/bin/exa --icons -la";
          stow_dotfiles = ''
            stow --target="$HOME" --dir="$HOME/Projects/bkps/" --stow .dotfiles'';
          nix_update = "sudo nixos-rebuild switch";
          nix_clean = "nix-collect-garbage";
        };
        initExtra = builtins.readFile ./config.zsh;
      };
      neovim = {
        enable = true;
        withPython3 = true;
        package = pkgs.unstable.neovim-unwrapped;
        plugins = with pkgs.unstable.vimPlugins; [
          (fromGitHub "HEAD" "PieterjanMontens/vim-pipenv")
          (fromGitHub "HEAD" "Vigemus/iron.nvim")
          (fromGitHub "HEAD" "cljoly/telescope-repo.nvim")
          (fromGitHub "HEAD" "epwalsh/obsidian.nvim")
          (fromGitHub "HEAD" "jbyuki/nabla.nvim")
          (fromGitHub "HEAD" "jmbuhr/otter.nvim")
          (fromGitHub "HEAD" "jmcantrell/vim-virtualenv")
          (fromGitHub "HEAD" "nvim-telescope/telescope-bibtex.nvim")
          (fromGitHub "HEAD" "quarto-dev/quarto-nvim")
          (fromGitHub "HEAD" "szw/vim-maximizer")
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
          bufferline-nvim
          cmp-buffer
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
          undotree
          vim-commentary
          vim-gitgutter
          vim-illuminate
          vim-nix
          vim-tmux-navigator
          vim-visual-multi
          which-key-nvim
        ];
        extraPackages = (with pkgs.unstable; [
          jq
          ltex-ls
          lua-language-server
          luajitPackages.luacheck
          nixfmt
          rnix-lsp
          shellcheck
          shfmt
          stylua
          terraform-ls
          texlab
          universal-ctags
        ]) ++ (with pkgs.unstable.nodePackages; [
          bash-language-server
          dockerfile-language-server-nodejs
          prettier
          pyright
        ]) ++ (with pkgs.unstable.python311Packages; [
          autoflake
          black
          ipython
          isort
          notedown
          pylint
          pynvim
        ]);
        extraConfig = ":luafile $HOME/.config/nvim/init.lua";
        vimAlias = true;
        vimdiffAlias = true;
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
          (builtins.readFile ./.dotfiles/.config/starship/config.toml));
      };
    };
    gtk = {
      enable = true;
      iconTheme = {
        name = "Pop";
        package = pkgs.pop-icon-theme;
      };
      cursorTheme = {
        name = "Quintom_Ink";
        package = pkgs.quintom-cursor-theme;
      };
    };
    dconf = {
      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
            "clipboard-history@alexsaveau.dev"
            "espresso@coadmunkee.github.com"
            "forge@jmmaranan.com"
            "gsconnect@andyholmes.github.io"
            "space-bar@luchrioh"
            "theme-switcher@fthx"
            "unite@hardpixel.eu"
          ];
          favourite-apps = [ "Alacritty.desktop" "firefox.desktop" ];
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          enable-hot-corners = false;
          font-antialiasing = "grayscale";
          font-hinting = "slight";
          toolkit-accessibility = false;
          font-name = "Cantarell 9";
        };
        "org/gnome/desktop/peripherals/touchpad" = {
          tap-to-click = true;
          two-finger-scrolling-enabled = true;
        };
        "org/gnome/shell/extensions/espresso" = {
          has-battery = true;
          show-notifications = false;
          user-enabled = true;
        };
        "org/gnome/shell/extensions/unite" = {
          app-menu-ellipsize-mode = "middle";
          app-menu-max-width = 1;
          autofocus-windows = true;
          desktop-name-text = "";
          enable-titlebar-actions = false;
          extend-left-box = false;
          greyscale-tray-icons = false;
          hide-activities-button = "always";
          hide-app-menu-icon = true;
          hide-dropdown-arrows = false;
          hide-window-titlebars = "always";
          notifications-position = "center";
          reduce-panel-spacing = true;
          restrict-to-primary-screen = false;
          show-desktop-name = false;
          show-legacy-tray = true;
          show-window-buttons = "never";
          show-window-title = "never";
          window-buttons-placement = "last";
          window-buttons-theme = "auto";
        };
        "org/gnome/shell/extensions/space-bar/behavior" = {
          scroll-wheel = "workspaces-bar";
          show-empty-workspaces = false;
          smart-workspace-names = true;
        };
        "org/gnome/shell/extensions/space-bar/shortcuts" = {
          enable-activate-workspace-shortcuts = false;
          enable-move-to-workspace-shortcuts = false;
        };
      };
    };
    xdg = {
      enable = true;
      mime.enable = true;
      configFile.nvim = {
        source = ./.dotfiles/.config/nvim;
        recursive = true;
      };
    };
    targets.genericLinux.enable = true;
  };
}
