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
      inherit (lib) getExe optionalAttrs;
      shellAliases = common // optionalAttrs isLinux desktop;
      initExtra = builtins.readFile ../dotfiles/init.sh;
      common = with pkgs; {
        cat = getExe bat;
        du = getExe gdu;
        find = getExe fd;
        fs = getExe fselect;
        grep = getExe ripgrep;
        ps = getExe procs;
        sed = getExe gnused;
        t = getExe tmux;
        top = getExe btop;
        lg = getExe lazygit;
        untar = "tar -xvf";
        untargz = "tar -xzf";
        v = "nvim";
        docker = "podman";
      };
      desktop = {
        dpct = "duplicati-cli";
        open = "xdg-open";
      };
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
      ];
    };
  };
}
