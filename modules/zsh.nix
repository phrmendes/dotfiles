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
      shellAliases =
        if isLinux
        then common // desktop
        else common;
      envExtra = ''
        export EDITOR="nvim"
        export GIT_EDITOR="nvim"
        export SUDO_EDITOR="nvim"
        export VISUAL="nvim"
        export VAGRANT_DEFAULT_PROVIDER="libvirt"
      '';
      initExtra = builtins.readFile ../dotfiles/init.sh;
    in {
      inherit shellAliases envExtra initExtra;
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      syntaxHighlighting.enable = true;
    };
  };
}
