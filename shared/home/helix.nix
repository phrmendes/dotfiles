{pkgs, ...}: {
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_mocha";
      keys = {
        insert = {
          j.k = "normal_mode";
        };
        select = {
          p = ":clipboard-paste-replace";
          y = "yank_to_clipboard";
        };
        normal = {
          "]".b = "goto_next_buffer";
          "[".b = "goto_previous_buffer";
          D = ["extend_to_line_bounds" "delete_selection"];
          esc = ["keep_primary_selection" "collapse_selection"];
          H = ["unindent"];
          J = ["extend_to_line_bounds" "delete_selection" "paste_after"];
          K = ["extend_to_line_bounds" "delete_selection" "move_line_up" "paste_before"];
          L = ["indent"];
          p = "paste_clipboard_after";
          P = "paste_clipboard_before";
          Y = ["extend_to_line_bounds" "yank_to_clipboard" "collapse_selection"];
          y = "yank_to_clipboard";
          space = {
            p = "no_op";
            P = "no_op";
            y = "no_op";
            Y = "no_op";
            minus = "hsplit";
            "/" = "vsplit";
            x = "wclose";
          };
        };
      };
      editor = {
        bufferline = "multiple";
        color-modes = true;
        cursorline = true;
        line-number = "relative";
        mouse = true;
        true-color = true;
        soft-wrap.enable = true;
        lsp = {
          display-messages = true;
          display-inlay-hints = true;
        };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides = {
          render = true;
          character = "┆";
        };
        statusline = {
          left = [
            "mode"
            "spacer"
            "version-control"
            "spinner"
            "diagnostics"
            "workspace-diagnostics"
          ];
          center = [
            "file-name"
          ];
          right = [
            "file-type"
            "position-percentage"
          ];
        };
      };
    };
    languages = {
      language-server = {
        ruff-lsp = {
          command = "${pkgs.ruff-lsp}/bin/ruff-lsp";
          config.settings.run = "onSave";
        };
        helm-ls = {
          command = "${pkgs.helm-ls}/bin/helm_ls";
          args = ["serve"];
        };
      };
      language = [
        {
          name = "python";
          language-servers = ["pyright" "ruff-lsp"];
          formatter = {
            command = "${pkgs.ruff}";
            args = ["format"];
          };
        }
        {
          name = "yaml";
          roots = ["Chart.yaml"];
          language-servers = ["yaml-language-server" "ansible-language-server" "helm-ls"];
        }
        {
          name = "nix";
          formatter.command = "${pkgs.alejandra}/bin/alejandra";
          auto-format = true;
        }
        {
          name = "json";
          auto-format = true;
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = ["--parser" "json"];
          };
        }
        {
          name = "yaml";
          auto-format = true;
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = ["--parser" "yaml"];
          };
        }
        {
          name = "css";
          auto-format = true;
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = ["--parser" "css"];
          };
        }
        {
          name = "html";
          auto-format = true;
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = ["--parser" "html"];
          };
        }
        {
          name = "markdown";
          language-servers = ["ltex-ls" "marksman"];
          auto-format = true;
          formatter = {
            command = "${pkgs.nodePackages.prettier}/bin/prettier";
            args = ["--parser" "markdown"];
          };
        }
        {
          name = "bash";
          auto-format = true;
          formatter = {
            command = "${pkgs.shellharden}/bin/shellharden";
            args = ["--transform" ""];
          };
        }
      ];
    };
    extraPackages =
      (with pkgs; [
        alejandra
        ansible-lint
        ansible-language-server
        delve
        golangci-lint
        golangci-lint-langserver
        gopls
        ltex-ls
        marksman
        nil
        ruff
        taplo
        terraform-ls
        texlab
      ])
      ++ (with pkgs.nodePackages; [
        bash-language-server
        dockerfile-language-server-nodejs
        pyright
        vscode-langservers-extracted
        yaml-language-server
      ]);
  };
}
