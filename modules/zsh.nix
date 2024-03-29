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
      path = "~/Projects/dotfiles";
      common = with pkgs; {
        cat = lib.getExe bat;
        du = lib.getExe ncdu;
        find = lib.getExe fd;
        fs = lib.getExe fselect;
        grep = lib.getExe ripgrep;
        m = "mkdir -p";
        ps = lib.getExe procs;
        sed = lib.getExe gnused;
        top = lib.getExe btop;
        untar = "tar -xvf";
        untargz = "tar -xzf";
        v = "nvim";
        t = lib.getExe tmux;
        ta = "${lib.getExe tmux} attach";
        tk = "${lib.getExe tmux} kill-session -t";
        tl = "${lib.getExe tmux} list-sessions";
        tn = "${lib.getExe tmux} new-session -s";
        tas = "${lib.getExe tmux} attach -t";
        tks = "${lib.getExe tmux} kill-server";
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
