{ config, ... }:
{
  modules.homeManager.dev = {
    zsh =
      { pkgs, lib, ... }:
      {
        programs.zsh = {
          enable = true;
          enableCompletion = true;
          enableVteIntegration = true;
          autosuggestion.enable = true;
          history.path = "${config.settings.home}/.local/share/zsh/history";
          syntaxHighlighting.enable = true;
          plugins = [
            {
              name = "zsh-fzf-tab";
              file = "share/fzf-tab/fzf-tab.plugin.zsh";
              src = pkgs.zsh-fzf-tab;
            }
            {
              name = "zsh-nix-shell";
              file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
              src = pkgs.zsh-nix-shell;
            }
          ];
          shellAliases = {
            asr = "${lib.getExe pkgs.atuin} scripts run";
            cat = lib.getExe pkgs.bat;
            fs = lib.getExe pkgs.fselect;
            g = lib.getExe pkgs.git;
            k = "${pkgs.kubectl}/bin/kubectl";
            ld = lib.getExe pkgs.lazydocker;
            lg = lib.getExe pkgs.lazygit;
            v = "nvim";
          };
          initContent = ''
            export PATH="$HOME/.local/bin:$PATH"

            set -o vi

            source <(${pkgs.just}/bin/just --completions zsh)
          '';
        };
      };
    bat =
      { pkgs, ... }:
      {
        programs.bat = {
          enable = true;
          config.pager = "less -FR";
          extraPackages = with pkgs.bat-extras; [ core ];
        };
      };

    btop = {
      programs.btop = {
        enable = true;
        settings.theme_background = false;
      };
    };

    eza = {
      programs.eza = {
        enable = true;
        git = true;
        icons = "auto";
        extraOptions = [
          "--group-directories-first"
          "--header"
        ];
      };
    };

    fd = {
      programs.fd = {
        enable = true;
        hidden = true;
        ignores = [ ".git/" ];
      };
    };

    fzf =
      { pkgs, lib, ... }:
      {
        programs.fzf =
          let
            bat = lib.getExe pkgs.bat;
            fd = lib.getExe pkgs.fd;
          in
          {
            enable = true;
            enableZshIntegration = true;
            defaultCommand = "${fd} --type f";
            changeDirWidgetCommand = "${fd} --type d";
            fileWidgetOptions = [ "--preview '${bat} --color=always {}'" ];
          };
      };

    jq = {
      programs.jq.enable = true;
    };

    ripgrep = {
      programs.ripgrep = {
        enable = true;
        arguments = [
          "--smart-case"
          "--hidden"
          "--glob"
          "!.git"
          "--glob"
          "!.venv"
          "--glob"
          "!.github"
          "--glob"
          "!.stversions"
          "--glob"
          "!.stfolder"
          "--glob"
          "!.sync"
        ];
      };
    };

    starship = {
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        enableBashIntegration = true;
        settings = {
          command_timeout = 1000;
          docker_context.disabled = true;
          gcloud.disabled = true;
          python.symbol = " ";
          nix_shell = {
            symbol = " ";
            format = "[$symbol]($style)";
          };
          character = {
            success_symbol = "[󰘧](bold green)";
            error_symbol = "[󰘧](bold red)";
            vimcmd_symbol = "[󰘧](bold purple)";
          };
          right_format = "$nix_shell";
        };
      };
    };

    zoxide = {
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
      };
    };

    tealdeer = {
      programs.tealdeer = {
        enable = true;
        settings = {
          display = {
            compact = false;
            use_pager = true;
          };
          updates.auto_update = true;
        };
      };
    };

    atuin = {
      programs.atuin = {
        enable = true;
        daemon.enable = true;
        enableZshIntegration = true;
        flags = [ "--disable-up-arrow" ];
        settings = {
          auto_sync = true;
          sync_frequency = "1h";
          sync_address = "https://atuin.local.ohlongjohnson.tech";
        };
      };
    };

    direnv = {
      programs.direnv = {
        enable = true;
        nix-direnv.enable = true;
        config = {
          global = {
            load_dotenv = true;
            strict_env = true;
            warn_timeout = 0;
          };
          whitelist = {
            prefix = [ "${config.settings.home}/Projects" ];
          };
        };
      };
    };

    git = {
      programs.difftastic = {
        enable = true;
        git = {
          enable = true;
          diffToolMode = true;
        };
      };

      programs.git = {
        enable = true;
        settings = {
          user = {
            inherit (config.settings) email name;
          };
          http.sslVerify = true;
          init.defaultBranch = "main";
          merge.tool = "nvimdiff";
          pull.rebase = true;
          submodules.recurse = true;
          push = {
            autoSetupRemote = true;
            recurseSubmodules = "on-demand";
          };
          aliases = {
            A = "add .";
            P = "push";
            a = "add";
            c = "clone";
            co = "checkout";
            lg = "log";
            p = "pull";
            r = "restore .";
            ra = "rebase --abort";
            rc = "rebase --continue";
            st = "status";
          };
        };
        ignores = [
          ".env"
          ".direnv"
          "Session.vim"
        ];
      };
    };

    gh = {
      programs.gh = {
        enable = true;
        gitCredentialHelper.enable = true;
      };

      programs.gh-dash = {
        enable = true;
        settings = {
          prSections = [
            {
              title = "All PRs";
              filters = "is:pr is:open";
            }
            {
              title = "My PRs";
              filters = "is:pr is:open author:@me";
            }
            {
              title = "Needs My Review";
              filters = "is:pr is:open review-requested:@me";
            }
            {
              title = "My Involved PRs";
              filters = "is:pr is:open involves:@me";
            }
          ];
        };
      };
    };

    nix-index = {
      programs = {
        nix-index.enable = true;
        nix-index-database.comma.enable = true;
      };
    };

    opencode =
      { pkgs, ... }:
      {
        programs.opencode = {
          enable = true;
          enableMcpIntegration = true;
          settings = {
            model = "github-copilot/gpt-5.3-codex";
            small_model = "github-copilot/gpt-5.4-mini";
            mcp = {
              k8s = {
                type = "local";
                command = [ "${pkgs.mcp-k8s-go}/bin/mcp-k8s-go" ];
                enabled = true;
              };
              terraform = {
                type = "local";
                command = [ "${pkgs.terraform-mcp-server}/bin/terraform-mcp-server" ];
                enabled = true;
              };
              playwright = {
                type = "local";
                command = [ "${pkgs.playwright-mcp}/bin/mcp-server-playwright" ];
                enabled = true;
              };
            };
            provider = {
              google-vertex-anthropic = {
                models = {
                  "claude-sonnet-4-5@20250929" = { };
                };
              };
            };
          };
        };
      };

    kitty = {
      programs.kitty = {
        enable = true;
        shellIntegration.enableZshIntegration = true;
        settings = {
          active_tab_font_style = "bold";
          allow_remote_control = "yes";
          bell_on_tab = "  ";
          clear_all_shortcuts = "yes";
          enable_audio_bell = "no";
          enabled_layouts = "splits:split_axis=horizontal,stack";
          forward_remote_control = "yes";
          hide_window_decorations = "yes";
          inactive_text_alpha = "0.9";
          listen_on = "unix:/tmp/kitty";
          open_url_with = "default";
          shell = "zsh";
          shell_integration = "enabled";
          tab_bar_edge = "bottom";
          tab_bar_min_tabs = 2;
          tab_bar_style = "powerline";
          tab_powerline_style = "slanted";
          tab_title_template = "{index}:{title.split('/')[-1].split(':')[-1]}{'  ' if layout_name == 'stack' else ''}";
          term = "xterm-256color";
          undercurl_style = "thin-sparse";
          update_check_interval = 0;
          window_padding_width = 5;
        };
        keybindings = {
          "ctrl+shift+\\" = "launch --location=vsplit --cwd=current";
          "ctrl+shift+[" = "previous_tab";
          "ctrl+shift+]" = "next_tab";
          "ctrl+shift+," = "move_tab_backward";
          "ctrl+shift+." = "move_tab_forward";
          "ctrl+shift+minus" = "launch --location=hsplit --cwd=current";
          "ctrl+shift+enter" = "start_resizing_window";
          "ctrl+shift+f1" = "debug_config";
          "ctrl+shift+b" = "scroll_page_down";
          "ctrl+shift+c" = "copy_to_clipboard";
          "ctrl+shift+d" = "scroll_line_down";
          "ctrl+shift+f" = "scroll_page_up";
          "ctrl+shift+h" = "neighboring_window left";
          "ctrl+shift+j" = "neighboring_window down";
          "ctrl+shift+k" = "neighboring_window up";
          "ctrl+shift+l" = "neighboring_window right";
          "ctrl+shift+n" = "new_tab_with_cwd";
          "ctrl+shift+o" = "open_url_with_hints";
          "ctrl+shift+q" = "close_window";
          "ctrl+shift+r" = "set_tab_title";
          "ctrl+shift+u" = "scroll_line_up";
          "ctrl+shift+v" = "paste_from_clipboard";
          "ctrl+shift+z" = "combine : toggle_layout stack : scroll_prompt_to_bottom";
          "ctrl+shift+1" = "goto_tab 1";
          "ctrl+shift+2" = "goto_tab 2";
          "ctrl+shift+3" = "goto_tab 3";
          "ctrl+shift+4" = "goto_tab 4";
          "ctrl+shift+5" = "goto_tab 5";
          "ctrl+shift+6" = "goto_tab 6";
          "ctrl+shift+7" = "goto_tab 7";
          "ctrl+shift+8" = "goto_tab 8";
          "ctrl+shift+9" = "goto_tab 9";
          "ctrl+shift+left" = "move_window left";
          "ctrl+shift+right" = "move_window down";
          "ctrl+shift+up" = "move_window up";
          "ctrl+shift+down" = "move_window right";
          "ctrl+minus" = "decrease_font_size";
          "ctrl+equal" = "increase_font_size";
          "ctrl+delete" = "change_font_size all 0";
        };
      };
    };

    tmux =
      { pkgs, lib, ... }:
      {
        programs.tmux = {
          enable = true;
          aggressiveResize = true;
          baseIndex = 1;
          clock24 = true;
          disableConfirmationPrompt = true;
          escapeTime = 0;
          historyLimit = 10000;
          keyMode = "vi";
          mouse = true;
          newSession = true;
          prefix = "C-space";
          shell = lib.getExe pkgs.zsh;
          extraConfig =
            let
              status_bar = " #I:#W#{?window_zoomed_flag, ,}#{?window_bell_flag, ,} ";
            in
            ''
              set -g  default-terminal    tmux-256color
              set -ag terminal-overrides  ",xterm-256color:RGB"
              set -ag terminal-overrides  ",xterm-kitty:RGB"
              set -gq allow-passthrough   on

              set -g detach-on-destroy off
              set -g display-time      4000
              set -g focus-events      on
              set -g renumber-windows  on
              set -g set-clipboard     on
              set -g visual-activity   off

              set -g status              on
              set -g status-interval     3
              set -g status-justify      left
              set -g status-left         "  "
              set -g status-position     top
              set -g status-right        "  #S   #H "
              set -g status-right-length 80
              set -g status-right-style  none

              set-window-option -g visual-bell                  on
              set-window-option -g bell-action                  other
              set-window-option -g window-status-separator      ""
              set-window-option -g window-status-format         "${status_bar}"
              set-window-option -g window-status-current-format "#[bold]${status_bar}#[nobold]"

              unbind ','

              bind '-'   split-window -v -c "#{pane_current_path}"
              bind ':'   command-prompt
              bind '\'   split-window -h -c "#{pane_current_path}"
              bind Enter rotate-window
              bind G     last-window
              bind Q     kill-window
              bind R     command-prompt -I "#S" "rename-session '%%'"
              bind S     command-prompt -p "Session name:" "new-session -s '%%'"
              bind d     detach-client
              bind k     kill-session
              bind n     new-window -c "#{pane_current_path}"
              bind p     paste-buffer
              bind q     kill-pane
              bind r     command-prompt -I "#W" "rename-window '%%'"
              bind w     choose-window
              bind y     copy-mode
              bind z     resize-pane -Z

              bind -r ',' swap-pane -U
              bind -r '.' swap-pane -D
              bind -r '(' switch-client -p
              bind -r ')' switch-client -n
              bind -r '<' previous-layout
              bind -r '>' next-layout
              bind -r '[' previous-window
              bind -r ']' next-window
              bind -r '{' swap-window -t -1 \; select-window -t -1
              bind -r '}' swap-window -t +1 \; select-window -t +1

              bind -T copy-mode-vi v   send-keys -X begin-selection
              bind -T copy-mode-vi y   send-keys -X copy-selection-and-cancel
              bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
              bind -T copy-mode-vi C-h select-pane -L
              bind -T copy-mode-vi C-j select-pane -D
              bind -T copy-mode-vi C-k select-pane -U
              bind -T copy-mode-vi C-l select-pane -R

              bind -n C-h if -F "#{@pane-is-vim}" "send-keys C-h" "select-pane -L"
              bind -n C-j if -F "#{@pane-is-vim}" "send-keys C-j" "select-pane -D"
              bind -n C-k if -F "#{@pane-is-vim}" "send-keys C-k" "select-pane -U"
              bind -n C-l if -F "#{@pane-is-vim}" "send-keys C-l" "select-pane -R"

              bind -n M-h if -F "#{@pane-is-vim}" "send-keys M-h" "resize-pane -L 3"
              bind -n M-j if -F "#{@pane-is-vim}" "send-keys M-j" "resize-pane -D 3"
              bind -n M-k if -F "#{@pane-is-vim}" "send-keys M-k" "resize-pane -U 3"
              bind -n M-l if -F "#{@pane-is-vim}" "send-keys M-l" "resize-pane -R 3"

              run-shell "tmux has-session -t 0 2>/dev/null && tmux kill-session -t 0"
            '';
        };
      };

    lazygit =
      { pkgs, lib, ... }:
      {
        programs.lazygit = {
          enable = true;
          settings = {
            promptToReturnFromSubprocess = false;
            disableStartupPopups = true;
            gui.nerdFontsVersion = "3";
            os.editPreset = "nvim-remote";
            git.pagers = [
              {
                colorArg = "always";
                pager = "${lib.getExe pkgs.delta} --dark --paging=never";
                externalDiffCommand = "${lib.getExe pkgs.difftastic} --color=always";
              }
            ];
          };
        };
      };

    lazydocker = {
      programs.lazydocker.enable = true;
    };

    docker =
      { pkgs, lib, ... }:
      let
        configDrv = pkgs.writeText "docker-config.json" (
          builtins.toJSON {
            credsStore = "secretservice";
          }
        );
      in
      {
        home.file.".docker/.config.json.nix" = {
          source = configDrv;
          onChange = ''
            config="$HOME/.docker/config.json"
            mkdir -p "$(dirname "$config")"
            cp ${configDrv} "$config"
            chmod 600 "$config"
          '';
        };
      };

    k9s = {
      programs.k9s = {
        enable = true;
        settings.k9s.refreshRate = 1;
        plugins = {
          log-bat = {
            shortCut = "Shift-L";
            description = "Logs (bat)";
            scopes = [ "po" ];
            command = "bash";
            background = false;
            args = [
              "-c"
              "\"$@\" | bat"
              "dummy-arg"
              "kubectl"
              "logs"
              "$NAME"
              "-n"
              "$NAMESPACE"
              "--context"
              "$CONTEXT"
              "--kubeconfig"
              "$KUBECONFIG"
            ];
          };
          log-bat-container = {
            shortCut = "Shift-L";
            description = "Logs (bat)";
            scopes = [ "containers" ];
            command = "bash";
            background = false;
            args = [
              "-c"
              "\"$@\" | bat"
              "dummy-arg"
              "kubectl"
              "logs"
              "-c"
              "$NAME"
              "$POD"
              "-n"
              "$NAMESPACE"
              "--context"
              "$CONTEXT"
              "--kubeconfig"
              "$KUBECONFIG"
            ];
          };
        };
      };
    };

    yazi = {
      programs.yazi = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
