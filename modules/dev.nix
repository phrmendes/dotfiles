{ config, ... }:
let
  inherit (config.modules.homeManager) dev;
in
{
  modules.homeManager.dev = {
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
          submodule.recurse = true;
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
      { pkgs, lib, ... }:
      let
        logBatPlugin =
          {
            scopes,
            extraArgs ? [ ],
          }:
          {
            shortCut = "Shift-L";
            description = "Logs (bat)";
            inherit scopes;
            command = "bash";
            background = false;
            args = [
              "-c"
              "\"$@\" | bat"
              "dummy-arg"
              "kubectl"
              "logs"
            ]
            ++ extraArgs
            ++ [
              "-n"
              "$NAMESPACE"
              "--context"
              "$CONTEXT"
              "--kubeconfig"
              "$KUBECONFIG"
            ];
          };
      in
      {
        home.packages = with pkgs; [
          kubectl
          kubernetes-helm
        ];

        programs.zsh.shellAliases.k = lib.getExe pkgs.kubectl;

        programs.k9s = {
          enable = true;
          settings.k9s.refreshRate = 1;
          plugins = {
            log-bat = logBatPlugin {
              scopes = [ "po" ];
              extraArgs = [ "$NAME" ];
            };
            log-bat-container = logBatPlugin {
              scopes = [ "containers" ];
              extraArgs = [
                "-c"
                "$NAME"
                "$POD"
              ];
            };
          };
        };
      };

    common = _: {
      imports = with dev; [
        atuin
        bat
        btop
        direnv
        docker
        eza
        fd
        fzf
        gh
        git
        jq
        k8s
        lazydocker
        lazygit
        nix-index
        packages
        ripgrep
        starship
        tealdeer
        tmux
        yazi
        zoxide
        zsh
      ];
    };
  };
}
