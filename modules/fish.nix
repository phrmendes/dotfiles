{
  lib,
  config,
  pkgs,
  ...
}:
{
  options.fish.enable = lib.mkEnableOption "enable fish";

  config = lib.mkIf config.fish.enable {
    programs.fish =
      let
        inherit (lib) getExe;
      in
      {
        enable = true;
        generateCompletions = true;
        plugins = with pkgs.fishPlugins; [
          {
            name = "pure";
            src = pure.src;
          }
          {
            name = "fzf";
            src = fzf-fish.src;
          }
        ];
        interactiveShellInit = ''
          set fish_greeting
          set --universal pure_symbol_prompt "󰘧"
          set --universal pure_reverse_prompt_symbol_in_vimode true
          set --universal pure_symbol_reverse_prompt " "
          set --universal pure_symbol_virtualenv_prefix " "
          set --universal pure_enable_nixdevshell true
          set --universal pure_symbol_nixdevshell_prefix " "

          fish_add_path "$HOME/.local/bin"

          fish_vi_key_bindings

          if test -f ~/.config/environment.fish
            source ~/.config/environment.fish
          end

          function fish_title
            if test (count $argv) -gt 0
              basename $argv[1]
            else
              echo fish
            end
          end
        '';
        shellAbbrs = {
          diff_persist = "sudo rsync -amvxx --dry-run --no-links --exclude '/tmp/*' --exclude '/root/*' / persist/ | rg -v '^skipping|/$'";
          apply = "git add . && nh os switch";
          asr = "atuin scripts run";
          vremote = "nvim --headless --listen /tmp/nvim-server.pipe &";
          vattach = "nvim --remote-ui --server /tmp/nvim-server.pipe";
        };
        shellAliases = {
          cat = getExe pkgs.bat;
          du = getExe pkgs.gdu;
          find = getExe pkgs.fd;
          fs = getExe pkgs.fselect;
          g = getExe pkgs.git;
          grep = getExe pkgs.ripgrep;
          k = "${pkgs.kubectl}/bin/kubectl";
          lg = getExe pkgs.lazygit;
          ps = getExe pkgs.procs;
          sed = getExe pkgs.gnused;
          top = getExe pkgs.btop;
          v = "nvim";
        };
      };
  };
}
