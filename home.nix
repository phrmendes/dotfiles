{ config, pkgs, ... }:

let
  user = "phrmendes";
in {
  home-manager.users.${user} = {
    home = {
      username = "${user}";
      homeDirectory = "/home/${user}";
      packages = (with pkgs.unstable; [
        # GUI apps
        pcloud
        zotero
        firefox
        chromium
        protonvpn-gui
        bitwarden
        spotify
        droidcam
        pop-launcher
        # CLI apps
        podman
        graphviz
        btop
        pandoc
        lazygit
        ripgrep
        fd
        sd
        gnupg
        stow
        exa
        sqlite
        jq
        hugo
        biber
        tere
        cmdstan
        gh
        quarto
        wmctrl
        # dictionaries
        ispell
        aspell
        aspellDicts.pt_BR
        aspellDicts.en
        # ansible
        ansible-lint
        ansible
        # terraform
        terraform
        tflint
        terragrunt
        # python
        python311
        python311Packages.ipython
        python311Packages.jupyter
        python311Packages.pytest
        ruff
        pipenv
        # go
        go
        gopls
        gotests
        gore
        gotools
        gomodifytags
        delve
        # nix
        rnix-lsp
        nixfmt
        # shell script
        shfmt
        shellcheck
        # latex
        texlab
        # others
        cargo
        nodejs
      ]) ++ (with pkgs; [
        tectonic
        baobab
        fragments
        celluloid
        gnome-text-editor
        gnome-photos
        gnome-solanum
      ]) ++ (with pkgs.gnome; [
        geary
        evince
        gnome-screenshot
        gnome-boxes
        gnome-disk-utility
        gnome-calculator
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
        enableFishIntegration = true;
      };
      direnv = {
        enable = true;
        enableBashIntegration = true;
      };
      fish = {
        enable = true;
        shellAliases = {
          mkdir = "mkdir -p";
          cat = "${pkgs.bat}/bin/bat";
          lg = "${pkgs.lazygit}/bin/lazygit";
          ls = "${pkgs.exa}/bin/exa --icons";
          ll = "${pkgs.exa}/bin/exa --icons -l";
          la = "${pkgs.exa}/bin/exa --icons -a";
          lt = "${pkgs.exa}/bin/exa --icons --tree";
          lla = "${pkgs.exa}/bin/exa --icons -la";
        };
        shellAbbrs = {
          stow_dotfiles = "stow --target=$HOME --dir=$HOME/Projects/bkps/ --stow .dotfiles";
          nix_update = "sudo nixos-rebuild switch";
          nix_clean = "nix-collect-garbage";
        };
        shellInit = ''
          fish_add_path "$HOME/.config/emacs/bin"
          fish_add_path "$HOME/.npm-global/bin"
      
          function tere
              set --local result (command tere $argv)
              [ -n "$result" ] && cd -- "$result"
          end
        '';
      };
      emacs = {
        enable = true;
        extraPackages = (epkgs: [ epkgs.vterm ] );
      };
      neovim = {
        enable = true;
        defaultEditor = true;
        plugins = with pkgs.vimPlugins; [
          nvim-web-devicons
          nvim-tree-lua
          plenary-nvim
          vim-nix
          vim-easymotion
          vim-commentary
          vim-gitgutter
          auto-pairs
          {
            plugin = indent-blankline-nvim;
            config = "lua require('indent_blankline').setup()";
          }
          {
            plugin = nvim-treesitter;
            config = ''
              lua << EOF
              require('nvim-treesitter.configs').setup {
                  highlight = {
                      enable = true,
                      additional_vim_regex_highlighting = false
                  }
              }
              EOF
            '';
          }
          {
            plugin = lualine-nvim;
            config = ''
              lua << EOF
              require('lualine').setup {
                  options = {
                      icons_enabled = true,
                  }
              }
              EOF
            '';
          }
        ];
        extraLuaConfig = ''
          vim.o.background = 'dark'
          vim.o.clipboard = 'unnamedplus'
          vim.o.completeopt = 'noinsert,menuone,noselect'
          vim.o.cursorline = true
          vim.o.hidden = true
          vim.o.inccommand = 'split'
          vim.o.number = true
          vim.o.relativenumber = true
          vim.o.splitbelow = true
          vim.o.splitright = true
          vim.o.title = true
          vim.o.wildmenu = true
          vim.o.expandtab = true
          vim.o.ttimeoutlen = 0
          vim.o.shiftwidth = 2
          vim.o.tabstop = 2
          vim.o.undofile = true
          vim.o.smartindent = true
          vim.o.tabstop = 4
          vim.o.shiftwidth = 4
          vim.o.shiftround = true
          vim.o.expandtab = true
          vim.o.scrolloff = 3
        '';
        vimAlias = true;
        vimdiffAlias = true;
      };
      alacritty = {
        enable = true;
        settings = {
          window = {
            padding = {
              x = 15;
              y = 15;
            };
            class = {
              instance = "Alacritty";
              general = "Alacritty";
            };
            opacity = 1;
          };
          scrolling = {
            history = 10000;
            multiplier = 3;
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
          shell.program = "${pkgs.fish}/bin/fish";
        };
      };
      starship = {
        enable = true;
        enableBashIntegration = true;
        enableFishIntegration = true;
      };
    };
    services = {
      
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
      gtk3.extraConfig = {
        Settings = "gtk-application-prefer-dark-theme=1";
      };
      gtk4.extraConfig = {
        Settings = "gtk-application-prefer-dark-theme=1";
      };
    };
    dconf = {
      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
            "clipman@popov895.ukr.net"
            "gsconnect@andyholmes.github.io"
            "pop-shell@system76.com"
            "pop-launcher-super-key@ManeLippert"
            "espresso@coadmunkee.github.com"
          ];
          favourite-apps = [
            "firefox.desktop"
            "Alacritty.desktop"
            "emacs.desktop"
            "org.gnome.Geary.desktop"
          ];
        };
        "org/gnome/shell/extensions/hidetopbar" = {
          enable-intellihide = true;
        };
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          enable-hot-corners = false;
          font-antialiasing = "grayscale";
          font-hinting = "slight";
          toolkit-accessibility = false;
        };
        "org/gnome/desktop/wm/keybindings" = {
          activate-window-menu = "@as []";
          begin-move = "@as []";
          begin-resize = "@as []";
          close = "['<Super>q']";
          cycle-group = "@as []";
          cycle-group-backward = "@as []";
          cycle-panels = "@as []";
          cycle-panels-backward = "@as []";
          cycle-windows = "@as []";
          cycle-windows-backward = "@as []";
          maximize = "@as []";
          move-to-monitor-down = "['<Shift><Control><Super>Down']";
          move-to-monitor-left = "['<Shift><Control><Super>Left']";
          move-to-monitor-right = "['<Shift><Control><Super>Right']";
          move-to-monitor-up = "['<Shift><Control><Super>Up']";
          move-to-workspace-1 = "['<Shift><Super>1']";
          move-to-workspace-2 = "['<Shift><Super>2']";
          move-to-workspace-3 = "['<Shift><Super>3']";
          move-to-workspace-4 = "['<Shift><Super>4']";
          move-to-workspace-5 = "['<Super><Shift>5']";
          move-to-workspace-6 = "['<Super><Shift>6']";
          move-to-workspace-last = "['<Shift><Super>End']";
          move-to-workspace-left = "['<Shift><Super>Left']";
          move-to-workspace-right = "['<Shift><Super>Right']";
          show-desktop = "['<Control><Super>h']";
          switch-group = "@as []";
          switch-group-backward = "@as []";
          switch-input-source = "['<Shift><Control><Super>space']";
          switch-input-source-backward = "['<Control><Super>space']";
          switch-panels = "@as []";
          switch-panels-backward = "@as []";
          switch-to-workspace-1 = "['<Super>1']";
          switch-to-workspace-2 = "['<Super>2']";
          switch-to-workspace-3 = "['<Super>3']";
          switch-to-workspace-4 = "['<Super>4']";
          switch-to-workspace-5 = "['<Super>5']";
          switch-to-workspace-6 = "['<Super>6']";
          switch-to-workspace-left = "['<Control><Super>Left']";
          switch-to-workspace-right = "['<Control><Super>Right']";
          toggle-maximized = "['<Super>m']";
          unmaximize = "@as []";
        };
        "org/gnome/shell/extensions/pop-shell" = {
          mouse-cursor-focus-location = "uint32 4";
          show-title = false;
          snap-to-grid = false;
          tile-by-default = true;
        };
        "org/gnome/desktop/peripherals/touchpad" = {
          tap-to-click = true;
          two-finger-scrolling-enabled = true;
        };
      };
    };
    xdg.enable = true;
    xdg.mime.enable = true;
    targets.genericLinux.enable = true;
  };
}
