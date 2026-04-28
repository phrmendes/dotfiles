_: {
  modules.homeManager.dev.helix =
    { pkgs, ... }:
    {
      programs.helix = {
        enable = true;
        defaultEditor = true;
        extraPackages = with pkgs; [
          basedpyright
          bash-language-server
          nixd
          nixfmt
          prettier
          ruff
          shellharden
          simple-completion-language-server
          taplo
          terraform-ls
          typescript-language-server
          yaml-language-server
        ];
        settings = {
          editor = {
            line-number = "relative";
            mouse = false;
            cursorline = true;
            color-modes = true;
            scrolloff = 8;
            cursor-shape = {
              insert = "bar";
              normal = "block";
              select = "underline";
            };
            indent-guides.render = true;
            statusline = {
              left = [
                "mode"
                "spinner"
                "file-name"
                "file-modification-indicator"
              ];
              right = [
                "diagnostics"
                "selections"
                "position"
                "file-encoding"
                "file-line-ending"
                "file-type"
              ];
            };
            lsp = {
              display-messages = true;
              display-inlay-hints = true;
            };
          };
          keys = {
            normal = {
              space.space = "file_picker";
              space.w = ":w";
              space.q = ":q";
              space.y.f = ":clipboard-yank %{buffer_name}";
              space.y.l = ":clipboard-yank %{buffer_name} L%{cursor_line}:C%{cursor_column}";
              space.y.r = ":clipboard-yank %{buffer_name} L%{selection_line_start} - L%{selection_line_end}";
            };
            insert = {
              j.k = "normal_mode";
              k.j = "normal_mode";
            };
          };
        };
        languages = {
          language-server.scls = {
            command = "${pkgs.simple-completion-language-server}/bin/simple-completion-language-server";
            config = {
              feature_words = false;
              feature_snippets = true;
              snippets_first = true;
              snippets_inline_by_word_tail = false;
              feature_unicode_input = false;
              feature_paths = false;
            };
          };
          language = [
            {
              name = "python";
              scope = "source.python";
              language-servers = [
                "basedpyright"
                "ruff"
                "scls"
              ];
              auto-format = true;
            }
            {
              name = "bash";
              scope = "source.bash";
              language-servers = [
                "bash-language-server"
                "scls"
              ];
              formatter = {
                command = "${pkgs.shellharden}/bin/shellharden";
                args = [
                  "--transform"
                  ""
                ];
              };
              auto-format = true;
            }
            {
              name = "nix";
              scope = "source.nix";
              language-servers = [
                "nixd"
                "scls"
              ];
              auto-format = true;
            }
            {
              name = "toml";
              scope = "source.toml";
              language-servers = [
                "taplo"
                "scls"
              ];
              auto-format = true;
            }
            {
              name = "hcl";
              scope = "source.hcl";
              language-servers = [
                "terraform-ls"
                "scls"
              ];
              auto-format = true;
            }
            {
              name = "tfvars";
              scope = "source.tfvars";
              language-servers = [
                "terraform-ls"
                "scls"
              ];
              auto-format = true;
            }
            {
              name = "yaml";
              scope = "source.yaml";
              language-servers = [
                "yaml-language-server"
                "scls"
              ];
              formatter = {
                command = "${pkgs.prettier}/bin/prettier";
                args = [
                  "--parser"
                  "yaml"
                ];
              };
              auto-format = true;
            }
            {
              name = "javascript";
              language-servers = [
                "typescript-language-server"
                "scls"
              ];
              formatter = {
                command = "${pkgs.prettier}/bin/prettier";
                args = [
                  "--parser"
                  "babel"
                ];
              };
              auto-format = true;
            }
            {
              name = "typescript";
              language-servers = [
                "typescript-language-server"
                "scls"
              ];
              formatter = {
                command = "${pkgs.prettier}/bin/prettier";
                args = [
                  "--parser"
                  "typescript"
                ];
              };
              auto-format = true;
            }
            {
              name = "jsx";
              language-servers = [
                "typescript-language-server"
                "scls"
              ];
              formatter = {
                command = "${pkgs.prettier}/bin/prettier";
                args = [
                  "--parser"
                  "babel"
                ];
              };
              auto-format = true;
            }
            {
              name = "tsx";
              language-servers = [
                "typescript-language-server"
                "scls"
              ];
              formatter = {
                command = "${pkgs.prettier}/bin/prettier";
                args = [
                  "--parser"
                  "typescript"
                ];
              };
              auto-format = true;
            }
            {
              name = "markdown";
              scope = "source.md";
              language-servers = [ "scls" ];
              formatter = {
                command = "${pkgs.prettier}/bin/prettier";
                args = [
                  "--parser"
                  "markdown"
                ];
              };
            }
          ];
        };
      };
    };
}
