{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  inherit (pkgs.stdenv) isLinux;
in {
  options.zsh.enable = lib.mkEnableOption "enable zsh";

  config = lib.mkIf config.zsh.enable {
    programs.zsh = let
      inherit (lib) getExe;
      path = "~/Projects/dotfiles";
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
      aliases =
        if isLinux
        then common // desktop
        else common;
    in {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      syntaxHighlighting.enable = true;
      initExtra = builtins.readFile ../dotfiles/init.sh;
      shellAliases = aliases;
    };
  };
}
