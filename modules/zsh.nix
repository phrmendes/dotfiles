{
  lib,
  config,
  pkgs,
  parameters,
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
      common = rec {
        cat = getExe pkgs.bat;
        docker = "podman";
        du = getExe pkgs.gdu;
        find = getExe pkgs.fd;
        fs = getExe pkgs.fselect;
        grep = getExe pkgs.ripgrep;
        k = "${pkgs.kubectl}/bin/kubectl";
        lg = getExe pkgs.lazygit;
        ps = getExe pkgs.procs;
        sed = getExe pkgs.gnused;
        tar = getExe pkgs.gnutar;
        top = getExe pkgs.btop;
        untar = "${tar} -xvf";
        untargz = "${tar} -xzf";
        v = "nvim";
        za = ''${zz} attach --create "$(pwd | sed 's/.*\///g')"'';
        zz = getExe pkgs.zellij;
      };
      desktop = {
        dpct = "duplicati-cli";
        open = "xdg-open";
      };
    in {
      inherit shellAliases initExtra;
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autosuggestion.enable = true;
      history.path = "${parameters.home}/.config/.zsh_history";
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
