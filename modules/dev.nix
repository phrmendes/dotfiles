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
            ld = lib.getExe pkgs.lazydocker;
            lg = lib.getExe pkgs.lazygit;
            v = "nvim";
          };
          initContent = ''
            export PATH="$HOME/.local/bin:$PATH"

            if [ -z "$DOCKER_HOST" ] && [ -n "$XDG_RUNTIME_DIR" ]; then
              export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/docker.sock"
            fi

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
      { pkgs, osConfig, ... }:
      {
        home.sessionVariables = {
          GOOGLE_APPLICATION_CREDENTIALS = osConfig.age.secrets."claude-service-account.json".path;
          GOOGLE_CLOUD_PROJECT = "rj-ia-desenvolvimento";
          VERTEX_LOCATION = "us-east5";
        };

        programs.opencode = {
          enable = true;
          enableMcpIntegration = true;
          settings = {
            model = "google-vertex-anthropic/claude-sonnet-4-6@default";
            small_model = "google-vertex/gemini-3-flash-preview";
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
      { pkgs, ... }:
      let
        configDrv = pkgs.writeText "docker-config.json" (
          builtins.toJSON {
            credsStore = "secretservice";
          }
        );
      in
      {
        home.packages = with pkgs; [
          docker-buildx
          docker-compose
        ];

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

    k8s =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          kubectl
          kubernetes-helm
        ];

        programs.zsh.shellAliases.k = "${pkgs.kubectl}/bin/kubectl";

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

    packages =
      { pkgs, ... }:
      {
        home.packages =
          with pkgs;
          let
            tt = writeShellApplication {
              name = "tt";
              runtimeInputs = [
                pkgs.fzf
                pkgs.tmux
              ];
              text = builtins.readFile ../files/scripts/tt.sh;
            };
          in
          [
            curl
            elixir
            hurl
            jdk
            jqp
            just
            nix-prefetch-github
            nodejs_latest
            parallel
            prek
            python314
            sqlite
            tt
            uv
          ];
      };
  };
}
