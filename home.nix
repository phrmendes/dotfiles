{ config, pkgs, ... }:

let
  user = "phrmendes";
in {
  home-manager.users.${user} = {
    home = {
      username = "${user}";
      homeDirectory = "/home/${user}";
      packages = (with pkgs.unstable; [
        adw-gtk3
        ansible
        bitwarden
        btop
        cargo
        chromium
        cmdstan
        drawing
        droidcam
        exa
        fd
        firefox
        gh
        hugo
        jq
        lazygit
        nixfmt
        nodejs
        obsidian
        pandoc
        pipenv
        podman
        python311
        quarto
        ripgrep
        sd
        shellcheck
        spotify
        sqlite
        stow
        tere
        terraform
        terragrunt
        vscode
        zotero
      ]) ++ (with pkgs; [
        baobab
        fragments
        gnome-photos
        gnome-solanum
        gnome-text-editor
        pcloud
        tectonic
        vlc
      ]) ++ (with pkgs.unstable.gnome; [
        evince
        geary
        gnome-boxes
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
          stow_dotfiles = ''stow --target="$HOME" --dir="$HOME/Projects/bkps/" --stow .dotfiles'';
          nix_update = "sudo nixos-rebuild switch";
          nix_clean = "nix-collect-garbage";
        };
        shellInit = ''
          fish_add_path "$HOME/.npm-global/bin"
      
          dconf load /org/gnome/settings-daemon/plugins/media-keys/ < "$HOME/Projects/bkps/gnome-keybindings/custom-keys.txt"
          dconf load /org/gnome/desktop/wm/keybindings/ < "$HOME/Projects/bkps/gnome-keybindings/wm-keys.txt"
          dconf load /org/gnome/shell/extensions/forge/ < "$HOME/Projects/bkps/gnome-keybindings/forge-keys.txt"
          dconf load /org/gnome/shell/keybindings/ < "$HOME/Projects/bkps/gnome-keybindings/keys.txt"
      
          function tere
              set --local result (command tere $argv)
              [ -n "$result" ] && cd -- "$result"
          end
        '';
      };
      neovim = {
        enable = true;
        package = pkgs.unstable.neovim-unwrapped; 
        plugins = with pkgs.vimPlugins; [
          auto-pairs
          indent-blankline-nvim
          lualine-nvim
          nvim-treesitter.withAllGrammars
          nvim-web-devicons
          plenary-nvim
          vim-commentary
          vim-easymotion
          vim-gitgutter
          vim-nix
        ];
        extraLuaConfig = (builtins.readFile ./.dotfiles/.config/nvim/settings.lua);
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
            decorations = "none";
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
          import = [

          ];
        };
      };
      starship = {
        enable = true;
        enableFishIntegration = true;
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
          favourite-apps = [
            "Alacritty.desktop"
            "code.desktop"
            "firefox.desktop"
          ];
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
        "org/gnome/shell/extensions/pano" = {
          is-in-incognito = false;
          play-audio-on-copy = false;
          send-notification-on-copy = false;
          window-height = 200;
        };
      };
    };
    xdg.enable = true;
    xdg.mime.enable = true;
    targets.genericLinux.enable = true;
  };
}
