{
  lib,
  config,
  pkgs,
  parameters,
  ...
}: {
  options.zsh.enable = lib.mkEnableOption "enable zsh";

  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      autosuggestion.enable = true;
      history.path = "${parameters.home}/.config/.zsh_history";
      syntaxHighlighting.enable = true;
      initExtra = builtins.readFile ../dotfiles/init.sh;
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
      shellAliases = let
        inherit (lib) getExe;
      in {
        cat = getExe pkgs.bat;
        du = getExe pkgs.gdu;
        find = getExe pkgs.fd;
        fs = getExe pkgs.fselect;
        grep = getExe pkgs.ripgrep;
        k = "${pkgs.kubectl}/bin/kubectl";
        ld = getExe pkgs.lazydocker;
        lg = getExe pkgs.lazygit;
        open = "${pkgs.xdg-utils}/bin/xdg-open";
        ps = getExe pkgs.procs;
        sed = getExe pkgs.gnused;
        top = getExe pkgs.btop;
        v = "nvim";
      };
    };
  };
}
