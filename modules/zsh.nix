{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isLinux;
in {
  options.zsh.enable = lib.mkEnableOption "enable zsh";

  config = lib.mkIf config.zsh.enable {
    programs.zsh = let
      inherit (lib) getExe;
      common = with pkgs; {
        cat = getExe bat;
        du = getExe ncdu;
        find = getExe fd;
        fs = getExe fselect;
        grep = getExe ripgrep;
        lg = getExe lazygit;
        m = "mkdir -p";
        ps = getExe procs;
        sed = getExe gnused;
        t = getExe tmux;
        ta = "${getExe tmux} attach";
        tas = "${getExe tmux} attach -t";
        tk = "${getExe tmux} kill-session -t";
        tks = "${getExe tmux} kill-server";
        tl = "${getExe tmux} list-sessions";
        tn = "${getExe tmux} new-session -s";
        top = getExe btop;
        untar = "tar -xvf";
        untargz = "tar -xzf";
        v = "nvim";
      };
      desktop = {
        dpct = "duplicati-cli";
        open = "xdg-open";
      };
      shellAliases = common // lib.optionalAttrs isLinux desktop;
      initExtra = builtins.readFile ../dotfiles/init.sh;
    in {
      inherit shellAliases initExtra;
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
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
        {
          name = "zsh-vi-mode";
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
          src = pkgs.zsh-vi-mode;
        }
      ];
    };
  };
}
